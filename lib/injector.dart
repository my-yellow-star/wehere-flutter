import 'package:get_it/get_it.dart';
import 'package:wehere_client/data/repositories/authentication_repository_impl.dart';
import 'package:wehere_client/data/repositories/member_repository_impl.dart';
import 'package:wehere_client/domain/repositories/authentication_repository.dart';
import 'package:wehere_client/domain/repositories/member_repository.dart';
import 'package:wehere_client/domain/usecases/get_profile_usecase.dart';
import 'package:wehere_client/domain/usecases/oauth2_login_usecase.dart';
import 'package:wehere_client/presentation/provider/authentication_provider.dart';
import 'package:wehere_client/presentation/provider/member_provider.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  injector.registerSingleton<MemberRepository>(MemberRepositoryImpl());
  injector.registerSingleton<AuthenticationRepository>(
      AuthenticationRepositoryImpl());
  injector.registerSingleton(GetProfileUseCase(injector()));
  injector.registerSingleton(OAuth2LoginUseCase(injector()));
  injector.registerFactory(() => MemberProvider(injector()));
  injector.registerFactory(() => AuthenticationProvider(injector()));
}
