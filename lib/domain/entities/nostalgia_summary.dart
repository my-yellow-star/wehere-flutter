import 'package:equatable/equatable.dart';
import 'package:wehere_client/core/params/marker_color.dart';
import 'package:wehere_client/core/params/nostalgia_visibility.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/entities/member_summary.dart';

class NostalgiaSummary extends Equatable {
  final String id;
  final MemberSummary member;
  final String title;
  final String description;
  final Location location;
  final int? distance;
  final String? thumbnail;
  final DateTime createdAt;
  final NostalgiaVisibility visibility;
  final MarkerColor markerColor;
  final String address;
  final DateTime memorizedAt;
  final bool isRealLocation;

  const NostalgiaSummary({
    required this.id,
    required this.member,
    required this.title,
    required this.description,
    required this.location,
    this.distance,
    this.thumbnail,
    required this.createdAt,
    required this.visibility,
    required this.markerColor,
    required this.address,
    required this.memorizedAt,
    required this.isRealLocation,
  });

  bool get isRealTime => createdAt.difference(memorizedAt).inMinutes.abs() < 1;

  @override
  List<Object?> get props =>
      [id, member, location, distance, thumbnail, createdAt];
}
