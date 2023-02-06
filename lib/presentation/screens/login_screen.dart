import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';
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
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          Column(children: [
            Container(height: MediaQuery.of(context).size.height / 3),
            Image.asset(
              '${Constant.image}/logo-white.png',
              height: 48,
              width: 48,
            ),
            Container(height: 18),
            IText('PINPLE'),
            IText('이순간을 기억할 때', weight: FontWeight.w100)
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
                              child: GoogleLoginButton.build(
                                  context,
                                  () => _onLoginSucceed(context),
                                  () => _onLoginFailed(context)),
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
