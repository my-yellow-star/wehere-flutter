import 'package:equatable/equatable.dart';
import 'package:wehere_client/core/params/nostalgia_visibility.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/entities/member_summary.dart';

class Nostalgia extends Equatable {
  final String id;
  final MemberSummary member;
  final String title;
  final String description;
  final Location location;
  final int? distance;
  final String? thumbnail;
  final DateTime createdAt;
  final List<String> images;
  final NostalgiaVisibility visibility;

  const Nostalgia(
      {required this.id,
      required this.member,
      required this.title,
      required this.description,
      required this.location,
      this.distance,
      this.thumbnail,
      required this.createdAt,
      required this.images,
      required this.visibility});

  @override
  List<Object?> get props => [
        id,
        member,
        title,
        description,
        location,
        distance,
        thumbnail,
        createdAt,
        images,
        visibility
      ];
}