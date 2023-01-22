import 'package:get_it/get_it.dart';
import 'package:wehere_client/data/repositories/member_repository_impl.dart';
import 'package:wehere_client/domain/repositories/member_repository.dart';
import 'package:wehere_client/domain/usecases/get_profile_usecase.dart';
import 'package:wehere_client/presentation/provider/member_provider.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  injector.registerSingleton<MemberRepository>(MemberRepositoryImpl());
  injector.registerSingleton(GetProfileUseCase(injector()));
  injector.registerFactory(() => MemberProvider(injector()));
}
