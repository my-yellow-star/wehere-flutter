import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';
import 'package:wehere_client/presentation/widgets/marker.dart';
import 'package:wehere_client/presentation/widgets/marker_generator.dart';
import 'package:wehere_client/presentation/widgets/mixin.dart';
import 'package:wehere_client/presentation/widgets/nostalgia_list_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with AfterLayoutMixin {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  List<NostalgiaSummary> nostalgiaList = [];
  List<Uint8List> bitmaps = [];
  NostalgiaSummary? tappedItem;
  Set<Circle> circles = {};
  double zoom = 12;
  late Location location;

  @override
  void initState() {
    super.initState();
    final locationProvider = context.read<LocationProvider>();
    locationProvider.getLocation();
    location = context.read<LocationProvider>().location!;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _generateMarker(context);
  }

  void _generateMarker(BuildContext context) {
    final nostalgia = context.read<NostalgiaListProvider>();
    nostalgia.initialize();
    nostalgia
        .loadList(
            condition: NostalgiaCondition.around,
            latitude: location.latitude,
            longitude: location.longitude,
            maxDistance: _maxDistance(context))
        .then((_) {
      MarkerGenerator(nostalgia.items.map((e) => IMarker(item: e)).toList(),
          (bitmaps) {
        setState(() {
          this.bitmaps = bitmaps;
          nostalgiaList = nostalgia.items;
        });
      }).addOverlay(context);
    });
  }

  _maxDistance(BuildContext context) =>
      _metersPerPx() * MediaQuery.of(context).size.height / 2;

  _metersPerPx() =>
      156543.03392 * cos(location.latitude * pi / 180) / pow(2, zoom);

  Set<Marker> _mapBitmapsToMarkers() {
    return bitmaps
        .asMap()
        .entries
        .map((entry) => Marker(
            markerId: MarkerId(nostalgiaList[entry.key].id),
            position: _getPosition(nostalgiaList[entry.key]),
            onTap: () {
              setState(() {
                tappedItem = nostalgiaList[entry.key];
                circles = {_circle(nostalgiaList[entry.key])};
              });
            },
            icon: BitmapDescriptor.fromBytes(entry.value)))
        .toSet();
  }

  CameraPosition _currentPosition(BuildContext context) {
    return CameraPosition(
        target: LatLng(location.latitude, location.longitude), zoom: zoom);
  }

  LatLng _getPosition(NostalgiaSummary item) =>
      LatLng(item.location.latitude, item.location.longitude);

  void _onCameraIdle(BuildContext context) {
    _generateMarker(context);
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      location = Location(position.target.latitude, position.target.longitude);
      zoom = position.zoom;
    });
    _metersPerPx();
  }

  void _onMapTapped(_) {
    if (tappedItem == null) {
      return;
    }
    setState(() {
      tappedItem = null;
      circles = {};
    });
  }

  Circle _circle(NostalgiaSummary item) => Circle(
      circleId: CircleId('center'),
      center: LatLng(item.location.latitude, item.location.longitude),
      strokeWidth: 0,
      radius: _metersPerPx() * 18,
      fillColor: Colors.blue.withOpacity(0.5));

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
            markers: _mapBitmapsToMarkers(),
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
            circles: circles,
          ),
        ),
        tappedItem == null
            ? Container()
            : Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: NostalgiaListCard(item: tappedItem!)))
      ],
    );
  }
}
