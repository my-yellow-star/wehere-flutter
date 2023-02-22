import 'package:flutter/material.dart';
import 'package:wehere_client/presentation/screens/widgets/back_button.dart';
import 'package:wehere_client/presentation/screens/widgets/text.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              padding: EdgeInsets.all(16),
              child: RoundBackButton(),
            ),
          ),
          Center(child: IText('존재하지 않는 추억이에요'))
        ],
      ),
    );
  }
}
