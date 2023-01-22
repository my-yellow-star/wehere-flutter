import 'package:wehere_client/data/datasources/Api.dart';
import 'package:wehere_client/data/models/member_model.dart';

class MemberService {
  static const _endpoint = '/api/members';
  Future<MemberModel> getMyProfile() async {
    final response = await Api().dio.get('$_endpoint/me');

    return MemberModel.fromJson(response.data);
  }
}
