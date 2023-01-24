import 'package:dio/dio.dart';
import 'package:wehere_client/core/params/oauth2_login.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/data/datasources/credential_service.dart';
import 'package:wehere_client/domain/entities/authentication.dart';
import 'package:wehere_client/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final CredentialService _credentialService = CredentialService();

  @override
  Future<DataState<Authentication>> oauth2Login(
      OAuth2LoginParams params) async {
    try {
      await _credentialService.authorize(params);
      return DataSuccess(Authentication(params.provider));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }
}
