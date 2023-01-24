import 'package:equatable/equatable.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/entities/member_summary.dart';

class NostalgiaSummary extends Equatable {
  final String id;
  final MemberSummary member;
  final Location location;
  final int? distance;
  final String? thumbnail;
  final DateTime createdAt;

  const NostalgiaSummary(
      {required this.id,
      required this.member,
      required this.location,
      this.distance,
      this.thumbnail,
      required this.createdAt});

  @override
  List<Object?> get props =>
      [id, member, location, distance, thumbnail, createdAt];
}
