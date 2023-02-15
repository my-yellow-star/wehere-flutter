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
}
