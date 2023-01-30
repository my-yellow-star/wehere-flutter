import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/core/resources/location_util.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class ProfileMapView extends StatefulWidget {
  final List<NostalgiaSummary> items;

  const ProfileMapView({super.key, required this.items});

  @override
  State<ProfileMapView> createState() => _ProfileMapViewState();
}

class _ProfileMapViewState extends State<ProfileMapView> {
  static const double _mapHeight = 200;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late double _maxDistance;

  @override
  void initState() {
    _maxDistance = widget.items
        .reduce((curr, next) => curr.distance! > next.distance! ? curr : next)
        .distance!
        .toDouble();
    super.initState();
  }

  CameraPosition _initialCameraPosition() {
    final location = context.read<LocationProvider>().location!;
    return CameraPosition(target: _toLatLng(location), zoom: _getZoom());
  }

  double _getZoom() {
    return LocationUtil.calculateZoom(
        context.read<LocationProvider>().location!, _maxDistance, _mapHeight);
  }

  LatLng _toLatLng(Location location) =>
      LatLng(location.latitude, location.longitude);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: _mapHeight,
          child: GoogleMap(
              myLocationButtonEnabled: false,
              circles: widget.items
                  .map((e) => Circle(
                      circleId: CircleId(e.id),
                      strokeWidth: 0,
                      radius: LocationUtil.metersPerPx(
                              context.read<LocationProvider>().location!,
                              _getZoom()) *
                          2,
                      fillColor: Colors.red,
                      center: _toLatLng(e.location)))
                  .toSet(),
              polygons: {
                Polygon(
                    polygonId: PolygonId("polygon1"),
                    points:
                        widget.items.map((e) => _toLatLng(e.location)).toList(),
                    fillColor: Colors.white.withOpacity(0.5),
                    strokeColor: Colors.white.withOpacity(0.8),
                    strokeWidth: 1)
              },
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
              initialCameraPosition: _initialCameraPosition()),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: IText(
              '* 최근 30개의 추억 반경',
              color: Colors.black,
              size: FontSize.tiny,
              weight: FontWeight.w200,
            ))
      ],
    );
  }
}
