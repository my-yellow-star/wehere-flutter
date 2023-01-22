import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final String id;
  final String nickname;
  final String? profileImageUrl;
  final String email;
  final PlatformType platformType;
  final Grade grade;
  final DateTime createdAt;

  const Member(
      {required this.id,
      required this.nickname,
      this.profileImageUrl,
      required this.email,
      required this.platformType,
      required this.grade,
      required this.createdAt});

  @override
  List<Object?> get props =>
      [id, nickname, profileImageUrl, email, platformType, grade, createdAt];
}

enum PlatformType { google }

enum Grade { freeTier }
