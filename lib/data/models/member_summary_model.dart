import 'package:wehere_client/domain/entities/member_summary.dart';

class MemberSummaryModel extends MemberSummary {
  const MemberSummaryModel(
      {required super.id, required super.nickname, super.profileImageUrl});

  factory MemberSummaryModel.fromJson(dynamic json) {
    return MemberSummaryModel(
        id: json['id'],
        nickname: json['nickname'],
        profileImageUrl: json['profileImageUrl']);
  }
}
