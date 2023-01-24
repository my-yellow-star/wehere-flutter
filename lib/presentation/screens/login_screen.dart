import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/screens/main_screen.dart';
import 'package:wehere_client/presentation/widgets/login_button.dart';
import 'package:wehere_client/presentation/routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
