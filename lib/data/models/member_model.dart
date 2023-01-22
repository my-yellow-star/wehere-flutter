import 'package:wehere_client/domain/entities/member.dart';

class MemberModel extends Member {
  const MemberModel(
      {required super.id,
      required super.nickname,
      super.profileImageUrl,
      required super.email,
      required super.platformType,
      required super.grade,
      required super.createdAt});

  factory MemberModel.fromJson(dynamic json) {
    return MemberModel(
        id: json['id'] as String,
        nickname: json['nickname'] as String,
        profileImageUrl: json['profileImageUrl'] as String?,
        email: json['email'] as String,
        platformType: toPlatformType(json['platformType']),
        grade: toGrade(json['grade']),
        createdAt: DateTime.parse(json['createdAt']));
  }
}

PlatformType toPlatformType(String raw) {
  if (raw == 'GOOGLE') {
    return PlatformType.google;
  } else {
    throw Error();
  }
}

Grade toGrade(String raw) {
  if (raw == 'FREE_TIER') {
    return Grade.freeTier;
  } else {
    throw Error();
  }
}