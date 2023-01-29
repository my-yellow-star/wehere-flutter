import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/routes.dart';
import 'package:wehere_client/presentation/screens/main_screen.dart';
import 'package:wehere_client/presentation/widgets/alert.dart';
import 'package:wehere_client/presentation/widgets/background_image.dart';
import 'package:wehere_client/presentation/widgets/login_button.dart';

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
            Image(
                width: 200, image: AssetImage('${Constant.image}/banner.png')),
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
                            Text('다음 계정으로 로그인',
                                style: TextStyle(color: Colors.white)),
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
