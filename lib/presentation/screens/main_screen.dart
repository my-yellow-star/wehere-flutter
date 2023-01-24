import 'package:flutter/cupertino.dart';
import 'package:wehere_client/presentation/screens/screen.dart';

class MainScreen extends StatelessScreen {
  const MainScreen({key}) : super(key: key, path: '/home');

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('main'));
  }
}
