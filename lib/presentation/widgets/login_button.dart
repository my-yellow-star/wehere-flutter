import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/params/oauth2_login.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';

class LoginButton {
  static Widget build(String path, VoidCallback onTap) {
    return Card(
      elevation: 8.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage('${Constant.image}/$path'),
        width: 48,
        height: 48,
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
  static void _signInWithGoogle(AuthenticationProvider provider,
      VoidCallback onLoginSucceed, VoidCallback onLoginFailed) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final auth = await googleUser.authentication;
    final token = auth.idToken;

    if (token != null) {
      await provider.login(OAuth2LoginParams(token, 'google'));
    }

    if (provider.authentication != null) {
      onLoginSucceed();
    } else {
      onLoginFailed();
    }
  }

  static Widget build(BuildContext context, VoidCallback onLoginSucceed,
      VoidCallback onLoginFailed) {
    return LoginButton.build(
      'google-logo.png',
      () => _signInWithGoogle(
          Provider.of<AuthenticationProvider>(context, listen: false),
          onLoginSucceed,
          onLoginFailed),
    );
  }
}
