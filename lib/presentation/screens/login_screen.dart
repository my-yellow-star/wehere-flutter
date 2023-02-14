import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/routes.dart';
import 'package:wehere_client/presentation/screens/main_screen.dart';
import 'package:wehere_client/presentation/widgets/alert.dart';
import 'package:wehere_client/presentation/widgets/background_image.dart';
import 'package:wehere_client/presentation/widgets/login_button.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _onLoginSucceed(BuildContext context) {
    Routes.replace(context, MainScreen());
  }

  Future<void> _onLoginFailed(BuildContext context) {
    return Alert.build(
      context,
      title: '로그인 실패',
      description: '로그인 오류. 다시 시도해주세요',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthenticationProvider>().isLoading;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          Column(children: [
            Container(height: MediaQuery.of(context).size.height / 3),
            Image.asset(
              Constant.defaultMarker,
              height: 48,
              fit: BoxFit.fitHeight,
            ),
            Container(height: 18),
            IText('PINPLE'),
            IText('이순간을 영원하게', weight: FontWeight.w100)
          ]),
          SafeArea(
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Container()),
                    Container(
                        padding: EdgeInsets.only(bottom: 48),
                        child: Column(
                          children: [
                            IText(
                              '다음 계정으로 시작',
                              weight: FontWeight.w100,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PasswordLoginButton.build(
                                    context,
                                    () => _onLoginSucceed(context),
                                    () => _onLoginFailed(context),
                                  ),
                                  Container(width: PaddingHorizontal.small),
                                  GoogleLoginButton.build(
                                      context,
                                      () => _onLoginSucceed(context),
                                      () => _onLoginFailed(context)),
                                  Container(width: PaddingHorizontal.small),
                                  Platform.isIOS
                                      ? AppleLoginButton.build(
                                          context,
                                          () => _onLoginSucceed(context),
                                          () => _onLoginFailed(context))
                                      : SizedBox(width: 0, height: 0),
                                ],
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ]),
          ),
          isLoading ? Center(child: CircularProgressIndicator()) : Container()
        ],
      ),
    );
  }
}
