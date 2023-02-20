import 'package:wehere_client/core/params/get_bookmark.dart';
import 'package:wehere_client/core/params/update_member.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/domain/entities/pagination.dart';

abstract class MemberRepository {
  Future<DataState<Member>> getMyProfile();

  Future<DataState<Member>> getOtherProfile(String memberId);

  Future<DataState<dynamic>> resign();

  Future<DataState<dynamic>> update(UpdateMemberParams params);

  Future<Pagination<NostalgiaSummary>> getBookmarks(GetBookmarkParams params);

  Future<Pagination<NostalgiaSummary>> getBookmarksOther(
      GetBookmarkParams params);
}
