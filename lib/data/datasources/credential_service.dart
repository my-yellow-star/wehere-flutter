import 'package:dio/dio.dart';
import 'package:wehere_client/core/params/email_password.dart';
import 'package:wehere_client/core/params/oauth2_login.dart';
import 'package:wehere_client/core/resources/secret.dart';
import 'package:wehere_client/data/datasources/api.dart';
import 'package:wehere_client/data/datasources/storage_service.dart';
import 'package:wehere_client/data/models/credential_model.dart';

class CredentialService {
  CredentialService._();

  static final _singleton = CredentialService._();

  Dio get _dio => Dio(BaseOptions(baseUrl: Secret.apiHost));
  final StorageService _storageService = StorageService();

  factory CredentialService() => _singleton;

  Future<CredentialModel> refreshSession(String sessionId) async {
    final dio = _dio;
    dio.options.headers['SessionId'] = sessionId;
    final response = await dio.post('/session/refresh');
    final credential = CredentialModel.fromJson(response.data);
    _saveCredential(credential);
    return credential;
  }

  Future<CredentialModel> authorize(OAuth2LoginParams params) async {
    final dio = _dio;
    dio.options.headers['Authorization'] = 'Bearer ${params.token}';
    dio.options.headers['Provider'] = params.provider;
    dio.interceptors.add(LoggingInterceptor());
    final response = await dio.post('/oauth2/authorize');
    final credential = CredentialModel.fromJson(response.data);
    _saveCredential(credential);
    return credential;
  }

  Future<void> register(EmailPasswordParams params) async {
    final dio = _dio;
    dio.options.contentType = 'application/json';
    final requestBody = {'email': params.email, 'password': params.password};
    await dio.post('/auth/register', data: requestBody);
  }

  Future<CredentialModel> login(EmailPasswordParams params) async {
    final dio = _dio;
    dio.options.contentType = 'application/json';
    final requestBody = {'email': params.email, 'password': params.password};
    final response = await dio.post('/auth/login', data: requestBody);
    final credential = CredentialModel.fromJson(response.data);
    _saveCredential(credential);
    return credential;
  }

  Future<void> _saveCredential(CredentialModel credential) async {
    await _storageService.setAccessToken(credential.accessToken);
    await _storageService.setRefreshToken(credential.refreshToken);
  }
}
