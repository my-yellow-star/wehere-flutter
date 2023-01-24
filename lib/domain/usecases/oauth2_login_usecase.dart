import 'package:wehere_client/core/params/oauth2_login.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/entities/authentication.dart';
import 'package:wehere_client/domain/repositories/authentication_repository.dart';

class OAuth2LoginUseCase
    extends UseCase<DataState<Authentication>, OAuth2LoginParams> {
  final AuthenticationRepository _authenticationRepository;

  OAuth2LoginUseCase(this._authenticationRepository);

  @override
  Future<DataState<Authentication>> call(OAuth2LoginParams params) async {
    return await _authenticationRepository.oauth2Login(params);
  }
}
