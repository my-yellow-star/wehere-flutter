import 'package:dio/dio.dart';
import 'package:wehere_client/core/params/email_password.dart';
import 'package:wehere_client/core/params/oauth2_login.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/data/datasources/credential_service.dart';
import 'package:wehere_client/data/datasources/member_service.dart';
import 'package:wehere_client/data/datasources/storage_service.dart';
import 'package:wehere_client/domain/entities/authentication.dart';
import 'package:wehere_client/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final CredentialService _credentialService = CredentialService();
  final StorageService _storageService = StorageService();
  final MemberService _memberService = MemberService();

  @override
  Future<DataState<Authentication>> oauth2Login(
      OAuth2LoginParams params) async {
    try {
      await _credentialService.authorize(params);
      final member = await _memberService.getMyProfile();
      return DataSuccess(Authentication(member));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<Authentication>> login(EmailPasswordParams params) async {
    try {
      await _credentialService.login(params);
      final member = await _memberService.getMyProfile();
      return DataSuccess(Authentication(member));
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState> register(EmailPasswordParams params) async {
    try {
      await _credentialService.register(params);
      return DataSuccess(null);
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<void> logout() async {
    await _storageService.deleteAccessToken();
    await _storageService.deleteRefreshToken();
  }
}
