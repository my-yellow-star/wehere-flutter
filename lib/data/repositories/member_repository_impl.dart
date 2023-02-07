import 'package:dio/dio.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/data/datasources/member_service.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/domain/repositories/member_repository.dart';

class MemberRepositoryImpl extends MemberRepository {
  final MemberService _memberService = MemberService();

  @override
  Future<DataState<Member>> getMyProfile() async {
    try {
      final response = await _memberService.getMyProfile();
      return DataSuccess(response);
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<dynamic>> resign() async {
    try {
      await _memberService.resign();
      return DataSuccess(null);
    } on DioError catch (error) {
      return DataFailed(error);
    }
  }
}
