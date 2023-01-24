import 'package:wehere_client/domain/entities/location.dart';

class LocationModel extends Location {
  const LocationModel(super.latitude, super.longitude);

  factory LocationModel.fromJson(dynamic json) {
    return LocationModel(json['latitude'], json['longitude']);
  }
}
