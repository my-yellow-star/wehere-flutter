import 'package:flutter/material.dart';

import '../../core/resources/constant.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          '${Constant.image}/airplane_window.jpg',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        Container(
          color: ColorTheme.primary.withOpacity(0.8),
        ),
      ],
    );
  }
}
