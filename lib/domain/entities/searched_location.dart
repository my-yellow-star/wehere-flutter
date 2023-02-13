import 'package:equatable/equatable.dart';
import 'package:wehere_client/domain/entities/location.dart';

class SearchedLocation extends Equatable {
  final String name;
  final Location location;
  final String address;
  final String? category;
  final int distance;

  const SearchedLocation(
      {required this.name,
      required this.location,
      required this.address,
      required this.distance,
      this.category});

  @override
  // TODO: implement props
  List<Object?> get props => [name, location, address, category];
}
