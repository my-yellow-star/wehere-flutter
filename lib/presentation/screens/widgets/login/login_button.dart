import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wehere_client/core/params/oauth2_login.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/screens/widgets/login/password_login_modal.dart';

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

class AppleLoginButton {
  static void _signInWithApple(AuthenticationProvider provider,
      VoidCallback onLoginSucceed, VoidCallback onLoginFailed) async {
    final AuthorizationCredentialAppleID credential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final token = credential.identityToken;

    if (token != null) {
      await provider.login(OAuth2LoginParams(token, 'apple'));
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
      'apple-logo.png',
      () => _signInWithApple(
          Provider.of<AuthenticationProvider>(context, listen: false),
          onLoginSucceed,
          onLoginFailed),
    );
  }
}

class PasswordLoginButton {
  static void _login(BuildContext context, VoidCallback onLoginSucceed,
      VoidCallback onLoginFailed) async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return PasswordLoginModal(
            onLoginSucceed: onLoginSucceed,
          );
        });
  }

  static Widget build(BuildContext context, VoidCallback onLoginSucceed,
      VoidCallback onLoginFailed) {
    return LoginButton.build(
      'lock.png',
      () => _login(context, onLoginSucceed, onLoginFailed),
    );
  }
}
