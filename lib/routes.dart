import 'package:flutter/cupertino.dart';
import 'package:wehere_client/presentation/screens/login_screen.dart';
import 'package:wehere_client/presentation/screens/main_screen.dart';
import 'package:wehere_client/presentation/screens/screen.dart';

class Routes {
  static final screens = [LoginScreen(), MainScreen()];

  static final routes = {
    for (var screen in screens) screen.path: (context) => screen
  };

  static void push(BuildContext context, StatelessScreen screen) {
    Navigator.pushNamed(context, screen.path);
  }

  static void replace(BuildContext context, StatelessScreen screen) {
    Navigator.pushReplacementNamed(context, screen.path);
  }
}
