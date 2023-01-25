import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wehere_client/domain/entities/location.dart';

class LocationProvider extends ChangeNotifier {
  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.unableToDetermine;
  Location? location;
  LocationError? error;

  bool get permitted =>
      _permission == LocationPermission.whileInUse ||
      _permission == LocationPermission.always;

  Future<void> initialize() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      error = LocationError.serviceDisabled;
      return;
    }
    _permission = await Geolocator.checkPermission();
    if (permitted) {
      final position = await Geolocator.getCurrentPosition();
      location = Location(position.latitude, position.longitude);
    }
  }

  Future<void> requestPermission() async {
    if (permitted) {
      return;
    }

    _permission = await Geolocator.requestPermission();
    if (_permission == LocationPermission.denied) {
      error = LocationError.permissionDenied;
    }
    if (_permission == LocationPermission.deniedForever) {
      error = LocationError.permissionDeniedForever;
    }

    notifyListeners();
  }

  Future<void> getLocation() async {
    await requestPermission();
    if (permitted) {
      final position = await Geolocator.getCurrentPosition();
      location = Location(position.latitude, position.longitude);
      notifyListeners();
    }
  }
}

enum LocationError {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever
}
