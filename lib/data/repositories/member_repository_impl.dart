import 'package:dio/dio.dart';
import 'package:wehere_client/core/params/get_bookmark.dart';
import 'package:wehere_client/core/params/update_member.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/data/datasources/member_service.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/domain/entities/pagination.dart';
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
  Future<DataState<Member>> getOtherProfile(String memberId) async {
    try {
      final response = await _memberService.getOtherProfile(memberId);
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

  @override
  Future<DataState<dynamic>> update(UpdateMemberParams params) async {
    try {
      await _memberService.update(params);
      return DataSuccess(null);
    } on DioError catch (error) {
      return DataFailed(error);
    }
  }

  @override
  Future<Pagination<NostalgiaSummary>> getBookmarksOther(
      GetBookmarkParams params) async {
    return await _memberService.getBookmarksOther(params);
  }

  @override
  Future<Pagination<NostalgiaSummary>> getBookmarks(
      GetBookmarkParams params) async {
    return await _memberService.getBookmarks(params);
  }
}
