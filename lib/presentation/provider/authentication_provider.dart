import 'package:wehere_client/core/params/oauth2_login.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/authentication.dart';
import 'package:wehere_client/domain/usecases/oauth2_login_usecase.dart';
import 'package:wehere_client/presentation/provider/api_provider.dart';

class AuthenticationProvider extends ApiProvider {
  final OAuth2LoginUseCase _oAuth2LoginUseCase;

  AuthenticationProvider(this._oAuth2LoginUseCase);

  Authentication? _authentication;

  Authentication? get authentication => _authentication;

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
}
