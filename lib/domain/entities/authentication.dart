import 'package:equatable/equatable.dart';
import 'package:wehere_client/domain/entities/member.dart';

class Authentication extends Equatable {
  final Member member;

  const Authentication(this.member);

  @override
  List<Object?> get props => [member];
}
