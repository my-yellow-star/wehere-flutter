import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/params/oauth2_login.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/provider/authentication_provider.dart';

class LoginButton {
  static Widget build(String path, VoidCallback onTap) {
    return Card(
      elevation: 18.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage('${Constant.image}/$path'),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(35.0),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

class GoogleLoginButton {
  static void _signInWithGoogle(AuthenticationProvider provider) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final auth = await googleUser?.authentication;
    final token = auth?.idToken;

    if (token != null) {
      await provider.login(OAuth2LoginParams(token, 'google'));
    }
  }

  static Widget build(BuildContext context) {
    final provider = Provider.of<AuthenticationProvider>(context, listen: true);
    return LoginButton.build(
      'google-logo.png',
      () => _signInWithGoogle(provider),
    );
  }
}
