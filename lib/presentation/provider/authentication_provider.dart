import 'package:wehere_client/core/params/oauth2_login.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/authentication.dart';
import 'package:wehere_client/domain/usecases/get_profile_usecase.dart';
import 'package:wehere_client/domain/usecases/logout_usecase.dart';
import 'package:wehere_client/domain/usecases/oauth2_login_usecase.dart';
import 'package:wehere_client/presentation/provider/api_provider.dart';

class AuthenticationProvider extends ApiProvider {
  final OAuth2LoginUseCase _oAuth2LoginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetProfileUseCase _getProfileUseCase;

  AuthenticationProvider(
      this._oAuth2LoginUseCase, this._logoutUseCase, this._getProfileUseCase);

  Authentication? _authentication;

  Authentication? get authentication => _authentication;

  Future<void> initialize() async {
    final response = await _getProfileUseCase();
    if (response is DataSuccess && response.data != null) {
      _authentication = Authentication(response.data!);
      notifyListeners();
    }
  }

  Future<void> login(OAuth2LoginParams params) async {
    isLoading = true;
    notifyListeners();
    final response = await _oAuth2LoginUseCase(params);
    if (response is DataSuccess) {
      _authentication = response.data;
    } else {
      error = response.error;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _logoutUseCase();
    _authentication = null;
    notifyListeners();
  }
}
