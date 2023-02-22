import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/params/nostalgia_visibility.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/core/resources/location_util.dart';
import 'package:wehere_client/core/resources/logger.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/domain/entities/searched_location.dart';
import 'package:wehere_client/presentation/components/mixin.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';
import 'package:wehere_client/presentation/providers/refresh_propagator.dart';
import 'package:wehere_client/presentation/screens/widgets/button.dart';
import 'package:wehere_client/presentation/screens/widgets/location_search_modal.dart';
import 'package:wehere_client/presentation/components/clustered_place.dart';
import 'package:wehere_client/presentation/screens/widgets/map/create_nostalgia_bubble.dart';
import 'package:wehere_client/presentation/screens/widgets/map/map_visibility_switch.dart';
import 'package:wehere_client/presentation/components/marker.dart';
import 'package:wehere_client/presentation/screens/widgets/map/nostalgia_map_card.dart';
import 'package:wehere_client/presentation/screens/widgets/map/nostalgia_nearby_modal.dart';
import 'package:wehere_client/presentation/screens/widgets/text.dart';

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
  NostalgiaVisibility _visibility = NostalgiaVisibility.all;
  late Location _location;
  late ClusterManager _clusterManager;

  @override
  void initState() {
    super.initState();
    context.read<NostalgiaListProvider>().initialize();
    context.read<RefreshPropagator>().consume('nostalgia-list');
    final locationProvider = context.read<LocationProvider>();
    locationProvider.getLocation();
    _location = context.read<LocationProvider>().location!;
    _clusterManager = ClusterManager<ClusteredPlace>([], _updateMarkers,
        markerBuilder: (cluster) async {
      return await MarkerBuilder.build(
          cluster: cluster,
          onTapSingle: _onTapSingleMarker,
          onTapMultiple: _showNostalgiaList);
    },
        levels: [1, 2, 4, 6.75, 9, 12, 14.5, 16.0, 17],
        stopClusteringZoom: 18);
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
    final current = context.read<LocationProvider>().location!;
    nostalgia.initialize();
    nostalgia.updateTargetLatitude(_location.latitude);
    nostalgia.updateTargetLongitude(_location.longitude);
    nostalgia
        .loadList(
            condition: NostalgiaCondition.around,
            latitude: current.latitude,
            longitude: current.longitude,
            size: 50,
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
      LocationUtil.metersPerPx(_location, _zoom) *
      MediaQuery.of(context).size.height /
      2;

  void _addMarkers(List<NostalgiaSummary> items) async {
    final filtered = items.where((item) =>
        _markers.where((marker) => marker.markerId.value == item.id).isEmpty);

    _clusterManager.setItems(filtered.map((e) => ClusteredPlace(e)).toList());
  }

  void _onTapSingleMarker(NostalgiaSummary item) {
    setState(() {
      _tappedItem = item;
      _circles = {_circle(item)};
    });
  }

  void _updateMarkers(Set<Marker> markers) {
    setState(() {
      _markers = markers;
    });
  }

  CameraPosition _currentPosition(BuildContext context) {
    return CameraPosition(
        target: LatLng(_location.latitude, _location.longitude), zoom: _zoom);
  }

  void _onCameraIdle(BuildContext context) {
    _generateMarker();
    apiLogger.d(_zoom);
    _clusterManager.updateMap();
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _location = Location(position.target.latitude, position.target.longitude);
      _zoom = position.zoom;
    });
    _clusterManager.onCameraMove(position);
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

  void _onTapSearchButton() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return LocationSearchModal(
            onItemPressed: _updatePosition,
          );
        });
  }

  void _updatePosition(SearchedLocation searched) async {
    (await _controller.future).moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                searched.location!.latitude, searched.location!.longitude),
            zoom: 16)));
  }

  void _onTapNostalgiaNearby() {
    _showNostalgiaList(context.read<NostalgiaListProvider>().items);
  }

  void _showNostalgiaList(List<NostalgiaSummary> items) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return NostalgiaNearbyModal(
            items: items,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final shouldRefresh =
        context.watch<RefreshPropagator>().consume('nostalgia-list');
    if (shouldRefresh) {
      _refresh();
    }

    final nostalgia = context.watch<NostalgiaListProvider>();

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
              _clusterManager.setMapId(controller.mapId);
            },
            onCameraIdle: () {
              _onCameraIdle(context);
            },
            onCameraMove: _onCameraMove,
            circles: _circles,
          ),
        ),
        SafeArea(
            child: Container(
          padding: EdgeInsets.only(top: PaddingVertical.normal),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: PaddingHorizontal.normal),
                    padding: EdgeInsets.fromLTRB(
                      PaddingHorizontal.normal,
                      PaddingVertical.small,
                      PaddingHorizontal.normal,
                      PaddingVertical.small,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, blurRadius: 8)
                        ]),
                    child: InkWell(
                      onTap: _onTapNostalgiaNearby,
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
                            size: FontSize.small,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: PaddingHorizontal.small,
                    height: 0,
                  ),
                  MapVisibilitySwitch(
                      onTap: _onTapVisibilitySwitch,
                      visibility: _visibility,
                      highlight: _visibility != NostalgiaVisibility.all)
                ],
              ),
              Container(
                padding: EdgeInsets.only(right: PaddingHorizontal.normal),
                child: RoundButton(
                  onPress: _onTapSearchButton,
                  icon: Icons.search_rounded,
                  backgroundColor: Colors.black,
                  shadowColor: Colors.black,
                  backgroundOpacity: 1,
                  color: Colors.white,
                  size: IconSize.big,
                ),
              )
            ],
          ),
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
