import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/routes.dart';
import 'package:wehere_client/presentation/screens/map_screen.dart';
import 'package:wehere_client/presentation/screens/permission_screen.dart';
import 'package:wehere_client/presentation/widgets/login_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authentication =
          Provider.of<AuthenticationProvider>(context, listen: false)
              .authentication;
      if (authentication != null) {
        final permitted =
            Provider.of<LocationProvider>(context, listen: false).permitted;
        Routes.replace(context, permitted ? MapScreen() : PermissionScreen());
      }
    });
    return Center(
      child: GoogleLoginButton.build(context),
    );
  }
}
