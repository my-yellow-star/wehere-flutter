import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    Future.microtask(() {
      context.read<LocationProvider>().getLocation();
    });
    super.initState();
  }

  CameraPosition currentPosition(Location location) {
    return CameraPosition(
        target: LatLng(location.latitude, location.longitude), zoom: 14);
  }

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationProvider>().location;
    return location != null
        ? GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: currentPosition(location),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            })
        : Center(child: CircularProgressIndicator());
  }
}
