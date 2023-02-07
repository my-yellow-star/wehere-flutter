import 'package:wehere_client/core/params/update_member.dart';
import 'package:wehere_client/data/datasources/api.dart';
import 'package:wehere_client/data/models/member_model.dart';

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
}
