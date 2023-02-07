import 'package:flutter/material.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class MyBookmarkView extends StatelessWidget {
  const MyBookmarkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Center(
          child: IText(
            '준비중이에요',
            weight: FontWeight.w100,
          ),
        )
      ],
    );
  }
}
