import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/presentation/provider/authentication_provider.dart';
import 'package:wehere_client/presentation/screens/main_screen.dart';
import 'package:wehere_client/presentation/screens/screen.dart';
import 'package:wehere_client/presentation/widgets/login_button.dart';
import 'package:wehere_client/routes.dart';

class LoginScreen extends StatelessScreen {
  const LoginScreen({key}) : super(key: key, path: '/login');

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authentication =
          Provider.of<AuthenticationProvider>(context, listen: false)
              .authentication;
      if (authentication != null) {
        Routes.replace(context, MainScreen());
      }
    });
    return Center(
      child: GoogleLoginButton.build(context),
    );
  }
}
