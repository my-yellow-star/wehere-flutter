import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double latitude;
  final double longitude;

  const Location(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}
