import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/member.dart';

abstract class MemberRepository {
  Future<DataState<Member>> getMyProfile();
}