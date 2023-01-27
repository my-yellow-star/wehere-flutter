import 'package:wehere_client/data/models/location_model.dart';
import 'package:wehere_client/data/models/member_summary_model.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';

class NostalgiaSummaryModel extends NostalgiaSummary {
  const NostalgiaSummaryModel(
      {required super.id,
      required super.member,
      required super.location,
      required super.title,
      required super.description,
      super.distance,
      super.thumbnail,
      required super.createdAt});

  factory NostalgiaSummaryModel.fromJson(dynamic json) {
    return NostalgiaSummaryModel(
        id: json['id'],
        member: MemberSummaryModel.fromJson(json['member']),
        title: json['title'],
        description: json['description'],
        location: LocationModel.fromJson(json['location']),
        distance: json['distance'],
        thumbnail: json['thumbnail'],
        createdAt: DateTime.parse(json['createdAt']));
  }
}
