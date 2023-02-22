import 'package:equatable/equatable.dart';
import 'package:wehere_client/domain/entities/location.dart';

class SearchedLocation extends Equatable {
  final String id;
  final String name;
  final Location? location;
  final String address;
  final String? category;
  final int? distance;

  const SearchedLocation({
    required this.id,
    required this.name,
    this.location,
    required this.address,
    this.distance,
    this.category,
  });

  @override
  List<Object?> get props => [name, location, address, category];
}
