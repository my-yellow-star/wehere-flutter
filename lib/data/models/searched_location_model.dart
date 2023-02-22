import 'package:wehere_client/data/models/location_model.dart';
import 'package:wehere_client/domain/entities/searched_location.dart';

class SearchedLocationModel extends SearchedLocation {
  const SearchedLocationModel({
    required super.id,
    required super.name,
    super.location,
    required super.address,
    super.distance,
    super.category,
  });

  factory SearchedLocationModel.fromJson(dynamic json) {
    return SearchedLocationModel(
        id: json['id'],
        name: json['name'],
        location: json['location'] != null
            ? LocationModel.fromJson(json['location'])
            : null,
        address: json['address'],
        distance: json['distance'],
        category: json['category']);
  }
}
