import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/injector.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/member_provider.dart';
import 'package:wehere_client/presentation/providers/my_nostalgia_grid_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_editor_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';
import 'package:wehere_client/presentation/providers/my_nostalgia_map_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_provider.dart';
import 'package:wehere_client/presentation/providers/refresh_propagator.dart';
import 'package:wehere_client/presentation/providers/search_location_provider.dart';
import 'package:wehere_client/presentation/providers/statistic_provider.dart';
import 'package:wehere_client/presentation/routes.dart';
import 'package:wehere_client/presentation/screens/login_screen.dart';
import 'package:wehere_client/presentation/screens/main_screen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeDependencies();

  final authenticationProvider = injector<AuthenticationProvider>();
  await authenticationProvider.initialize();
  final authentication = authenticationProvider.authentication;

  final locationProvider = LocationProvider();
  await locationProvider.initialize();

  FlutterNativeSplash.remove();

  Widget resolveScreen() {
    if (authentication == null) {
      return LoginScreen();
    }

    return MainScreen();
  }

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authenticationProvider),
        ChangeNotifierProvider(create: (_) => locationProvider),
        ChangeNotifierProvider(
            create: (_) => injector<NostalgiaEditorProvider>()),
        ChangeNotifierProvider(create: (_) => injector<NostalgiaProvider>()),
        ChangeNotifierProvider(create: (_) => injector<MemberProvider>()),
        ChangeNotifierProvider(
            create: (_) => injector<NostalgiaListProvider>()),
        ChangeNotifierProvider(
            create: (_) => injector<MyNostalgiaMapProvider>()),
        ChangeNotifierProvider(
            create: (_) => injector<MyNostalgiaGridProvider>()),
        ChangeNotifierProvider(create: (_) => injector<StatisticProvider>()),
        ChangeNotifierProvider(create: (_) => RefreshPropagator()),
        ChangeNotifierProvider(
            create: (_) => injector<SearchLocationProvider>())
      ],
      child: ScreenUtilInit(
        designSize: Size(390, 844),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: Constant.fontFamily),
            home: resolveScreen(),
            routes: Routes.map,
            initialRoute: 'main',
          );
        },
      )));
}
