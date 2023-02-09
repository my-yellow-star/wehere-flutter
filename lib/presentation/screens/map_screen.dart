import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';
import 'package:wehere_client/presentation/screens/components/create_nostalgia_bubble.dart';
import 'package:wehere_client/presentation/widgets/button.dart';
import 'package:wehere_client/presentation/widgets/marker.dart';
import 'package:wehere_client/presentation/widgets/marker_generator.dart';
import 'package:wehere_client/presentation/widgets/mixin.dart';
import 'package:wehere_client/presentation/widgets/nostalgia_map_card.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with AfterLayoutMixin {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  NostalgiaSummary? _tappedItem;
  Set<Circle> _circles = {};
  double _zoom = 12;
  late Location _location;
  bool _shouldRefresh = false;

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

  void _generateMarker() {
    final nostalgia = context.read<NostalgiaListProvider>();
    nostalgia.initialize();
    nostalgia
        .loadList(
            condition: NostalgiaCondition.around,
            latitude: _location.latitude,
            longitude: _location.longitude,
            maxDistance: _maxDistance(context))
        .then((_) {
      MarkerGenerator(nostalgia.items.map((e) => IMarker(item: e)).toList(),
          (bitmaps) {
        _mapBitmapsToMarkers(bitmaps, nostalgia.items);
      }).addOverlay(context);
    });
  }

  _maxDistance(BuildContext context) =>
      _metersPerPx() * MediaQuery.of(context).size.height / 2;

  _metersPerPx() =>
      156543.03392 * cos(_location.latitude * pi / 180) / pow(2, _zoom);

  _mapBitmapsToMarkers(List<Uint8List> bitmaps, List<NostalgiaSummary> items) {
    if (items.isEmpty) return;
    setState(() {
      _shouldRefresh = false;
      _markers = bitmaps
          .asMap()
          .entries
          .map((entry) => Marker(
              consumeTapEvents: true,
              markerId: MarkerId(items[entry.key].id),
              position: _getPosition(items[entry.key]),
              onTap: () {
                setState(() {
                  _tappedItem = items[entry.key];
                  _circles = {_circle(items[entry.key])};
                });
              },
              icon: BitmapDescriptor.fromBytes(entry.value)))
          .toSet();
    });
  }

  CameraPosition _currentPosition(BuildContext context) {
    return CameraPosition(
        target: LatLng(_location.latitude, _location.longitude), zoom: _zoom);
  }

  LatLng _getPosition(NostalgiaSummary item) =>
      LatLng(item.location.latitude, item.location.longitude);

  void _onCameraIdle(BuildContext context) {}

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _location = Location(position.target.latitude, position.target.longitude);
      _zoom = position.zoom;
      _shouldRefresh = true;
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

  Circle _circle(NostalgiaSummary item) => Circle(
      circleId: CircleId('center'),
      center: LatLng(item.location.latitude, item.location.longitude),
      strokeWidth: 0,
      radius: _metersPerPx() * 12,
      fillColor: Colors.blue.withOpacity(0.7));

  @override
  Widget build(BuildContext context) {
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
          mainAxisSize: MainAxisSize.min,
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
            _shouldRefresh
                ? RoundButton(
                    icon: Icons.refresh,
                    onPress: _generateMarker,
                    backgroundOpacity: 1,
                    backgroundColor: Colors.white,
                    color: Colors.blue,
                    shadowColor: Colors.blue,
                  )
                : Container(
                    height: 0,
                  )
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
