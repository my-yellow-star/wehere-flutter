import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:wehere_client/core/resources/logger.dart';
import 'package:wehere_client/core/resources/secret.dart';
import 'package:wehere_client/data/datasources/credential_service.dart';
import 'package:wehere_client/data/datasources/storage_service.dart';

class Api {
  Api._();

  static final _singleton = Api._();

  factory Api() => _singleton;

  final dio = createDio();

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: Secret.apiHost,
      receiveTimeout: 15000,
      connectTimeout: 15000,
      sendTimeout: 15000,
    ));

    dio.interceptors
        .addAll([LoggingInterceptor(), RefreshSessionInterceptor(dio)]);
    return dio;
  }
}

class RefreshSessionInterceptor extends QueuedInterceptor {
  final Dio dio;

  RefreshSessionInterceptor(this.dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final storageService = StorageService();
    var accessToken = await storageService.getAccessToken();

    if (shouldBeRefreshed(accessToken)) {
      final refreshToken = await storageService.getRefreshToken();
      if (refreshToken != null) {
        await CredentialService()
            .refreshSession(refreshToken)
            .then((value) => {accessToken = value.accessToken})
            .catchError((error, stackTrace) {
          handler.reject(error, true);
        });
      }
    }
    options.headers['Authorization'] = 'Bearer $accessToken';

    return handler.next(options);
  }

  bool shouldBeRefreshed(String? accessToken) {
    if (accessToken == null) {
      return true;
    }
    if (Jwt.isExpired(accessToken)) {
      return true;
    }

    final expiry = Jwt.getExpiryDate(accessToken);
    if (expiry == null) {
      return false;
    }
    return expiry.millisecondsSinceEpoch <
        DateTime.now().millisecondsSinceEpoch - 1000 * 60;
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    apiLogger.i('request: [${options.method}] ${options.uri}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    apiLogger.i('response: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    apiLogger.e('error: ${err.message}');
    super.onError(err, handler);
  }
}
