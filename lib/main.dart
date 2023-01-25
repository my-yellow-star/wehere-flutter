import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/injector.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';
import 'package:wehere_client/presentation/screens/login_screen.dart';
import 'package:wehere_client/presentation/screens/map_screen.dart';
import 'package:wehere_client/presentation/screens/permission_screen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDependencies();

  final authenticationProvider = injector<AuthenticationProvider>();
  await authenticationProvider.initialize();
  final authentication = authenticationProvider.authentication;

  final locationProvider = LocationProvider();
  await locationProvider.initialize();
  final locationPermitted = locationProvider.permitted;

  FlutterNativeSplash.remove();

  Widget resolveScreen() {
    if (authentication == null) {
      return LoginScreen();
    }

    return locationPermitted ? MapScreen() : PermissionScreen();
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => authenticationProvider),
      ChangeNotifierProvider(create: (_) => injector<NostalgiaListProvider>()),
      ChangeNotifierProvider(create: (_) => locationProvider),
    ],
    child:
        MaterialApp(debugShowCheckedModeBanner: false, home: resolveScreen()),
  ));
}
