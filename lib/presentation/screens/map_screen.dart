import 'dart:async';
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

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  List<NostalgiaSummary> nostalgiaList = [];
  List<Uint8List> bitmaps = [];

  @override
  void initState() {
    super.initState();
    final locationProvider = context.read<LocationProvider>();
    final nostalgiaListProvider = context.read<NostalgiaListProvider>();
    locationProvider.getLocation().then((_) => {
          nostalgiaListProvider
              .loadList(
                  condition: NostalgiaCondition.around,
                  latitude: locationProvider.location!.latitude,
                  longitude: locationProvider.location!.longitude,
                  maxDistance: 1000000)
              .then((_) {
            _generateMarker(context);
          })
        });
  }

  void _generateMarker(BuildContext context) {
    final items = context.read<NostalgiaListProvider>().items;
    MarkerGenerator(items.map((e) => IMarker(item: e)).toList(), (bitmaps) {
      setState(() {
        this.bitmaps = bitmaps;
        nostalgiaList = items;
      });
    }).generate(context);
  }

  CameraPosition _currentPosition(Location location) {
    return CameraPosition(
        target: LatLng(location.latitude, location.longitude), zoom: 12);
  }

  Set<Marker> _mapBitmapsToMarkers() {
    return bitmaps
        .asMap()
        .entries
        .map((entry) => Marker(
            markerId: MarkerId(nostalgiaList[entry.key].id),
            position: _getPosition(nostalgiaList[entry.key]),
            icon: BitmapDescriptor.fromBytes(entry.value)))
        .toSet();
  }

  LatLng _getPosition(NostalgiaSummary item) =>
      LatLng(item.location.latitude, item.location.longitude);

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationProvider>().location;
    return location != null
        ? GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _currentPosition(location),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _mapBitmapsToMarkers(),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            })
        : Center(child: CircularProgressIndicator());
  }
}
