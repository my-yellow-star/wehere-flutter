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

  Future<void> resign() async {
    await Api().dio.delete('$_endpoint/me');
  }
}
