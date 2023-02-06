import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/injector.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/create_nostalgia_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_provider.dart';
import 'package:wehere_client/presentation/routes.dart';
import 'package:wehere_client/presentation/screens/login_screen.dart';
import 'package:wehere_client/presentation/screens/main_screen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
            create: (_) => injector<CreateNostalgiaProvider>()),
        ChangeNotifierProvider(create: (_) => injector<NostalgiaProvider>())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: Constant.fontFamily),
        home: resolveScreen(),
        routes: Routes.map,
      )));
}
