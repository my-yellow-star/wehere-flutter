import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final String id;
  final String nickname;
  final String? profileImageUrl;
  final String? backgroundImageUrl;
  final String? description;
  final String email;
  final PlatformType platformType;
  final Grade grade;
  final DateTime createdAt;

  const Member({
    required this.id,
    required this.nickname,
    this.profileImageUrl,
    required this.email,
    required this.platformType,
    required this.grade,
    required this.createdAt,
    this.backgroundImageUrl,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        nickname,
        profileImageUrl,
        backgroundImageUrl,
        description,
        email,
        platformType,
        grade,
        createdAt
      ];
}

enum PlatformType { google, apple, kakao }

enum Grade { freeTier }
