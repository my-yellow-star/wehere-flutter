import 'package:wehere_client/data/models/location_model.dart';
import 'package:wehere_client/domain/entities/searched_location.dart';

class SearchedLocationModel extends SearchedLocation {
  const SearchedLocationModel(
      {required super.name,
      required super.location,
      required super.address,
      required super.distance,
      super.category});

  factory SearchedLocationModel.fromJson(dynamic json) {
    return SearchedLocationModel(
        name: json['name'],
        location: LocationModel.fromJson(json['location']),
        address: json['address'],
        distance: json['distance'],
        category: json['category']);
  }
}
