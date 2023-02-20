import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double latitude;
  final double longitude;

  const Location(this.latitude, this.longitude);

  bool get isInKorea =>
      latitude >= 33 && latitude <= 43 && longitude >= 124 && longitude <= 132;

  @override
  List<Object?> get props => [latitude, longitude];
}
