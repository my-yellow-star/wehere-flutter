import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/params/nostalgia_visibility.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/core/resources/logger.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';
import 'package:wehere_client/presentation/providers/refresh_propagator.dart';
import 'package:wehere_client/presentation/screens/components/create_nostalgia_bubble.dart';
import 'package:wehere_client/presentation/screens/components/map_visibility_switch.dart';
import 'package:wehere_client/presentation/screens/components/marker_icon_provider.dart';
import 'package:wehere_client/presentation/widgets/mixin.dart';
import 'package:wehere_client/presentation/widgets/nostalgia_map_card.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with AfterLayoutMixin {
  static const maxMarkersSize = 500;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  NostalgiaSummary? _tappedItem;
  Set<Circle> _circles = {};
  double _zoom = 12;
  NostalgiaVisibility _visibility = NostalgiaVisibility.all;
  late Location _location;

  @override
  void initState() {
    super.initState();
    context.read<NostalgiaListProvider>().initialize();
    final locationProvider = context.read<LocationProvider>();
    locationProvider.getLocation();
    _location = context.read<LocationProvider>().location!;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _generateMarker();
  }

  void _refresh() {
    setState(() {
      _markers = {};
      _tappedItem = null;
      _circles = {};
    });
    context.read<NostalgiaListProvider>().initialize();
    _generateMarker();
  }

  void _generateMarker() {
    final nostalgia = context.read<NostalgiaListProvider>();
    nostalgia.initialize();
    nostalgia
        .loadList(
            condition: NostalgiaCondition.around,
            latitude: _location.latitude,
            longitude: _location.longitude,
            memberId: _visibility == NostalgiaVisibility.owner
                ? context
                    .read<AuthenticationProvider>()
                    .authentication!
                    .member
                    .id
                : null,
            maxDistance: _maxDistance(context))
        .then((_) {
      _addMarkers(nostalgia.items);
    });
  }

  _maxDistance(BuildContext context) =>
      _metersPerPx() * MediaQuery.of(context).size.height / 2;

  _metersPerPx() =>
      156543.03392 * cos(_location.latitude * pi / 180) / pow(2, _zoom);

  void _addMarkers(List<NostalgiaSummary> items) async {
    final iconMap = await MarkerIconProvider.getIcons();
    final filtered = items.where((item) =>
        _markers.where((marker) => marker.markerId.value == item.id).isEmpty);
    final markers = filtered
        .map((item) => Marker(
            consumeTapEvents: true,
            markerId: MarkerId(item.id),
            position: _getPosition(item),
            onTap: () {
              setState(() {
                _tappedItem = item;
                _circles = {_circle(item)};
              });
            },
            icon: iconMap[item.markerColor.value]!))
        .toSet();
    setState(() {
      var total = {..._markers, ...markers};
      if (total.length > maxMarkersSize) {
        total = total.skip(total.length - maxMarkersSize).toSet();
      }
      _markers = total;
      apiLogger.d(_markers.length);
    });
  }

  CameraPosition _currentPosition(BuildContext context) {
    return CameraPosition(
        target: LatLng(_location.latitude, _location.longitude), zoom: _zoom);
  }

  LatLng _getPosition(NostalgiaSummary item) =>
      LatLng(item.location.latitude, item.location.longitude);

  void _onCameraIdle(BuildContext context) {
    _generateMarker();
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _location = Location(position.target.latitude, position.target.longitude);
      _zoom = position.zoom;
    });
    _metersPerPx();
  }

  void _onMapTapped(_) {
    if (_tappedItem == null) {
      return;
    }
    setState(() {
      _tappedItem = null;
      _circles = {};
    });
  }

  void _onTapVisibilitySwitch() {
    setState(() {
      _visibility = _visibility == NostalgiaVisibility.all
          ? NostalgiaVisibility.owner
          : NostalgiaVisibility.all;
    });
    _refresh();
  }

  Circle _circle(NostalgiaSummary item) => Circle(
      circleId: CircleId('center'),
      center: LatLng(item.location.latitude, item.location.longitude),
      strokeWidth: 0,
      radius: 100,
      fillColor: Colors.blue.withOpacity(0.5));

  @override
  Widget build(BuildContext context) {
    final shouldRefresh =
        context.watch<RefreshPropagator>().consume('nostalgia-list');
    if (shouldRefresh) {
      _refresh();
    }

    final nostalgia = context.watch<NostalgiaListProvider>();
    if (nostalgia.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _currentPosition(context),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _markers,
            onTap: _onMapTapped,
            onMapCreated: (GoogleMapController controller) {
              if (!_controller.isCompleted) {
                _controller.complete(controller);
              }
            },
            onCameraIdle: () {
              _onCameraIdle(context);
            },
            onCameraMove: _onCameraMove,
            circles: _circles,
          ),
        ),
        SafeArea(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.fromLTRB(24, 6, 24, 6),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.5), blurRadius: 8)
                  ]),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IText(
                    '근처 추억 ',
                    size: FontSize.small,
                  ),
                  IText(
                    '${nostalgia.total}',
                    weight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            MapVisibilitySwitch(
                onTap: _onTapVisibilitySwitch,
                visibility: _visibility,
                highlight: _visibility != NostalgiaVisibility.all)
          ],
        )),
        CreateNostalgiaBubble(),
        _tappedItem == null
            ? Container()
            : Align(
                alignment: Alignment.bottomCenter,
                child: NostalgiaMapCard(item: _tappedItem!))
      ],
    );
  }
}
