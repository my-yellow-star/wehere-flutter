import 'package:get_it/get_it.dart';
import 'package:wehere_client/data/repositories/authentication_repository_impl.dart';
import 'package:wehere_client/data/repositories/file_repository_impl.dart';
import 'package:wehere_client/data/repositories/member_repository_impl.dart';
import 'package:wehere_client/data/repositories/nostalgia_repository_impl.dart';
import 'package:wehere_client/data/repositories/search_repository_impl.dart';
import 'package:wehere_client/domain/repositories/authentication_repository.dart';
import 'package:wehere_client/domain/repositories/file_repository.dart';
import 'package:wehere_client/domain/repositories/member_repository.dart';
import 'package:wehere_client/domain/repositories/nostalgia_repository.dart';
import 'package:wehere_client/domain/repositories/search_repository.dart';
import 'package:wehere_client/domain/usecases/create_nostalgia_usecase.dart';
import 'package:wehere_client/domain/usecases/delete_nostalgia_usecase.dart';
import 'package:wehere_client/domain/usecases/get_nostalgia_list_usecase.dart';
import 'package:wehere_client/domain/usecases/get_nostalgia_usecase.dart';
import 'package:wehere_client/domain/usecases/get_other_profile_usecase.dart';
import 'package:wehere_client/domain/usecases/get_profile_usecase.dart';
import 'package:wehere_client/domain/usecases/get_statistic_summary_usecase.dart';
import 'package:wehere_client/domain/usecases/login_usecase.dart';
import 'package:wehere_client/domain/usecases/logout_usecase.dart';
import 'package:wehere_client/domain/usecases/oauth2_login_usecase.dart';
import 'package:wehere_client/domain/usecases/register_usecase.dart';
import 'package:wehere_client/domain/usecases/resign_usecase.dart';
import 'package:wehere_client/domain/usecases/search_location_usecase.dart';
import 'package:wehere_client/domain/usecases/update_member_usecase.dart';
import 'package:wehere_client/domain/usecases/update_nostalgia_usecase.dart';
import 'package:wehere_client/domain/usecases/upload_file_usecase.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/member_provider.dart';
import 'package:wehere_client/presentation/providers/my_nostalgia_grid_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_editor_provider.dart';
import 'package:wehere_client/presentation/providers/my_nostalgia_map_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_provider.dart';
import 'package:wehere_client/presentation/providers/search_location_provider.dart';
import 'package:wehere_client/presentation/providers/statistic_provider.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  // repository
  injector.registerSingleton<MemberRepository>(MemberRepositoryImpl());
  injector.registerSingleton<AuthenticationRepository>(
      AuthenticationRepositoryImpl());
  injector.registerSingleton<NostalgiaRepository>(NostalgiaRepositoryImpl());
  injector.registerSingleton<FileRepository>(FileRepositoryImpl());
  injector.registerSingleton<SearchRepository>(SearchRepositoryImpl());

  // use case
  injector.registerSingleton(GetProfileUseCase(injector()));
  injector.registerSingleton(OAuth2LoginUseCase(injector()));
  injector.registerSingleton(GetNostalgiaListUseCase(injector()));
  injector.registerSingleton(LogoutUseCase(injector()));
  injector.registerSingleton(GetStatisticSummaryUseCase(injector()));
  injector.registerSingleton(CreateNostalgiaUseCase(injector()));
  injector.registerSingleton(UploadFileUseCase(injector()));
  injector.registerSingleton(GetNostalgiaUseCase(injector()));
  injector.registerSingleton(UpdateNostalgiaUseCase(injector()));
  injector.registerSingleton(DeleteNostalgiaUseCase(injector()));
  injector.registerSingleton(ResignUseCase(injector()));
  injector.registerSingleton(GetOtherProfileUseCase(injector()));
  injector.registerSingleton(UpdateMemberUseCase(injector()));
  injector.registerSingleton(SearchLocationUseCase(injector()));
  injector.registerSingleton(RegisterUseCase(injector()));
  injector.registerSingleton(LoginUseCase(injector()));

  // provider
  injector.registerFactory(() => AuthenticationProvider(
      injector(), injector(), injector(), injector(), injector()));
  injector.registerFactory(() => NostalgiaListProvider(injector()));
  injector.registerFactory(() => StatisticProvider(injector()));
  injector.registerFactory(() =>
      NostalgiaEditorProvider(injector(), injector(), injector(), injector()));
  injector.registerFactory(() => NostalgiaProvider(injector(), injector()));
  injector.registerFactory(() => MyNostalgiaMapProvider(injector()));
  injector.registerFactory(() => MyNostalgiaGridProvider(injector()));
  injector.registerFactory(
      () => MemberProvider(injector(), injector(), injector(), injector()));
  injector.registerFactory(() => SearchLocationProvider(injector()));
}
