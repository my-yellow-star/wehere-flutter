import 'package:wehere_client/core/params/email_password.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/repositories/authentication_repository.dart';

class RegisterUseCase extends UseCase<DataState, EmailPasswordParams> {
  final AuthenticationRepository _authenticationRepository;

  RegisterUseCase(this._authenticationRepository);

  @override
  Future<DataState> call(EmailPasswordParams params) async {
    return await _authenticationRepository.register(params);
  }
}
