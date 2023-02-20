import 'package:wehere_client/core/params/nostalgia_visibility.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/data/models/location_model.dart';
import 'package:wehere_client/data/models/member_summary_model.dart';
import 'package:wehere_client/domain/entities/nostalgia.dart';

class NostalgiaModel extends Nostalgia {
  const NostalgiaModel({
    required super.id,
    required super.member,
    required super.title,
    required super.description,
    required super.location,
    super.distance,
    super.thumbnail,
    required super.createdAt,
    required super.images,
    required super.visibility,
    required super.markerColor,
    required super.address,
    required super.isRealLocation,
    required super.memorizedAt,
    required super.bookmarkCount,
    required super.isBookmarked,
  });

  factory NostalgiaModel.fromJson(dynamic json) {
    return NostalgiaModel(
      id: json['id'],
      member: MemberSummaryModel.fromJson(json['member']),
      title: json['title'],
      description: json['description'],
      location: LocationModel.fromJson(json['location']),
      distance: json['distance'],
      thumbnail: json['thumbnail'],
      createdAt: DateTime.parse(json['createdAt']),
      images:
          (json['images'] as List<dynamic>).map((e) => e.toString()).toList(),
      visibility: toNostalgiaVisibility(json['visibility']),
      markerColor: Constant.markerColors
          .singleWhere((e) => e.value == json['markerColor']),
      address: json['address'] ?? '',
      memorizedAt: DateTime.parse(json['memorizedAt']),
      isRealLocation: json['isRealLocation'],
      bookmarkCount: json['bookmarkCount'],
      isBookmarked: json['isBookmarked'],
    );
  }
}
