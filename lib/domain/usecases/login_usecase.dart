import 'package:wehere_client/core/params/email_password.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/entities/authentication.dart';
import 'package:wehere_client/domain/repositories/authentication_repository.dart';

class LoginUseCase
    extends UseCase<DataState<Authentication>, EmailPasswordParams> {
  final AuthenticationRepository _authenticationRepository;

  LoginUseCase(this._authenticationRepository);

  @override
  Future<DataState<Authentication>> call(EmailPasswordParams params) async {
    return await _authenticationRepository.login(params);
  }
}
