import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/data/datasources/storage_service.dart';
import 'package:wehere_client/data/models/credential_model.dart';

class CredentialService {
  CredentialService._();

  static final _singleton = CredentialService._();

  static final _dio = Dio(BaseOptions(baseUrl: Constant.apiHost));
  final StorageService _storageService = StorageService();

  factory CredentialService() => _singleton;

  Future<CredentialModel> refreshSession(String sessionId) async {
    //
    final logger = Logger();
    logger.i('Trying refresh Session');
    //
    _dio.options.headers['SessionId'] = sessionId;
    final response = await _dio.post('/session/refresh');
    final credential = CredentialModel.fromJson(response.data);
    _storageService.setAccessToken(credential.accessToken);
    _storageService.setRefreshToken(credential.refreshToken);
    return credential;
  }
}
