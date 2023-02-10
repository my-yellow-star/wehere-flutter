import 'package:wehere_client/domain/entities/member.dart';

class MemberModel extends Member {
  const MemberModel(
      {required super.id,
      required super.nickname,
      super.profileImageUrl,
      super.backgroundImageUrl,
      super.description,
      required super.email,
      required super.platformType,
      required super.grade,
      required super.createdAt});

  factory MemberModel.fromJson(dynamic json) {
    return MemberModel(
        id: json['id'],
        nickname: json['nickname'],
        profileImageUrl: json['profileImageUrl'],
        backgroundImageUrl: json['backgroundImageUrl'],
        description: json['description'],
        email: json['email'],
        platformType: toPlatformType(json['platformType']),
        grade: toGrade(json['grade']),
        createdAt: DateTime.parse(json['createdAt']));
  }
}

PlatformType toPlatformType(String raw) {
  return PlatformType.values
      .singleWhere((value) => value.name.toUpperCase() == raw);
}

Grade toGrade(String raw) {
  if (raw == 'FREE_TIER') {
    return Grade.freeTier;
  } else {
    throw Error();
  }
}
