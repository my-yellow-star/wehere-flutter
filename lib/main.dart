import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/injector.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';
import 'package:wehere_client/presentation/screens/login_screen.dart';
import 'package:wehere_client/presentation/screens/main_screen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDependencies();

  final authenticationProvider = injector<AuthenticationProvider>();
  // await authenticationProvider.initialize();
  final authentication = authenticationProvider.authentication;

  FlutterNativeSplash.remove();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => authenticationProvider),
      ChangeNotifierProvider(create: (_) => injector<NostalgiaListProvider>())
    ],
    child: MaterialApp(
      home: authentication != null ? MainScreen() : LoginScreen(),
    ),
  ));
}
