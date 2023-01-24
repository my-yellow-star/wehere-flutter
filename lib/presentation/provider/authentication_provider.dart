import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:wehere_client/core/params/oauth2_login.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/authentication.dart';
import 'package:wehere_client/domain/usecases/oauth2_login_usecase.dart';

class AuthenticationProvider extends ChangeNotifier {
  final OAuth2LoginUseCase _oAuth2LoginUseCase;

  AuthenticationProvider(this._oAuth2LoginUseCase);

  bool _isLoading = false;
  Authentication? _authentication;
  DioError? _error;

  bool get isLoading => _isLoading;

  Authentication? get authentication => _authentication;

  DioError? get error => _error;

  Future<void> login(OAuth2LoginParams params) async {
    _isLoading = true;
    notifyListeners();
    final response = await _oAuth2LoginUseCase(params);
    if (response is DataSuccess) {
      _authentication = response.data;
    } else {
      _error = response.error;
    }
    _isLoading = false;
    notifyListeners();
  }
}
