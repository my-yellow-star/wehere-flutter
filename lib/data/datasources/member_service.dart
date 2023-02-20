import 'package:wehere_client/core/params/get_bookmark.dart';
import 'package:wehere_client/core/params/update_member.dart';
import 'package:wehere_client/data/datasources/api.dart';
import 'package:wehere_client/data/models/member_model.dart';
import 'package:wehere_client/data/models/nostalgia_summary_model.dart';
import 'package:wehere_client/data/models/pagination_model.dart';

class MemberService {
  static const _endpoint = '/api/members';

  MemberService._();

  static final _singleton = MemberService._();

  factory MemberService() => _singleton;

  Future<MemberModel> getMyProfile() async {
    final response = await Api().dio.get('$_endpoint/me');

    return MemberModel.fromJson(response.data);
  }

  Future<MemberModel> getOtherProfile(String memberId) async {
    final response = await Api().dio.get('$_endpoint/$memberId');

    return MemberModel.fromJson(response.data);
  }

  Future<void> resign() async {
    await Api().dio.delete('$_endpoint/me');
  }

  Future<void> update(UpdateMemberParams params) async {
    final requestBody = {
      'nickname': params.nickname,
      'profileImageUrl': params.profileImageUrl,
      'backgroundImageUrl': params.backgroundImageUrl,
      'description': params.description
    };
    final dio = Api().dio;
    dio.options.contentType = 'application/json';
    await dio.patch('$_endpoint/me', data: requestBody);
  }

  Future<PaginationModel<NostalgiaSummaryModel>> getBookmarks(
      GetBookmarkParams params) async {
    final queryParameters = {
      'page': params.page,
      'size': params.size,
      'latitude': params.latitude,
      'longitude': params.longitude
    };
    final dio = Api().dio;
    final response = await dio.get('$_endpoint/me/bookmarks',
        queryParameters: queryParameters);
    return PaginationModel.fromJson(response.data, NostalgiaSummaryModel.fromJson);
  }

  Future<PaginationModel<NostalgiaSummaryModel>> getBookmarksOther(
      GetBookmarkParams params) async {
    final queryParameters = {
      'page': params.page,
      'size': params.size,
      'latitude': params.latitude,
      'longitude': params.longitude
    };
    final dio = Api().dio;
    final response = await dio.get('$_endpoint/${params.memberId}/bookmarks',
        queryParameters: queryParameters);
    return PaginationModel.fromJson(response.data, NostalgiaSummaryModel.fromJson);
  }
}
