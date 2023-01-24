import 'package:wehere_client/core/usecases/usecase.dart';
import 'package:wehere_client/domain/repositories/authentication_repository.dart';

class LogoutUseCase extends SimpleUseCase<void> {
  final AuthenticationRepository _authenticationRepository;

  LogoutUseCase(this._authenticationRepository);

  @override
  Future<void> call() async {
    await _authenticationRepository.logout();
  }
}
