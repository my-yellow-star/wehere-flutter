import 'package:wehere_client/core/params/oauth2_login.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/authentication.dart';

abstract class AuthenticationRepository {
  Future<DataState<Authentication>> oauth2Login(OAuth2LoginParams params);

  Future<void> logout();
}
