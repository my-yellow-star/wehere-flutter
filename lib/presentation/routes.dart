import 'package:flutter/material.dart';
import 'package:wehere_client/presentation/screens/nostalgia_editor_screen.dart';
import 'package:wehere_client/presentation/screens/home_screen.dart';
import 'package:wehere_client/presentation/screens/login_screen.dart';
import 'package:wehere_client/presentation/screens/main_screen.dart';
import 'package:wehere_client/presentation/screens/map_screen.dart';
import 'package:wehere_client/presentation/screens/mypage_screen.dart';
import 'package:wehere_client/presentation/screens/nostalgia_detail_screen.dart';
import 'package:wehere_client/presentation/screens/permission_screen.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> map = {
    'permission': (_) => PermissionScreen(),
    'login': (_) => LoginScreen(),
    'main': (_) => MainScreen(),
    'home': (_) => HomeScreen(),
    'map': (_) => MapScreen(),
    'my-page': (_) => MyPageScreen(),
    'nostalgia-editor': (_) => NostalgiaEditorScreen(),
    'nostalgia-detail': (_) => NostalgiaDetailScreen()
  };

  static void push(BuildContext context, Widget screen) {
    Navigator.push(context, _noAnimation(screen));
  }

  static void replace(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      _noAnimation(screen),
    );
  }

  static PageRouteBuilder _noAnimation(Widget screen) => PageRouteBuilder(
        pageBuilder: (context, anim1, anim2) => screen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
}
