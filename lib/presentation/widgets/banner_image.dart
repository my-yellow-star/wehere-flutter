import 'package:flutter/material.dart';

import 'package:wehere_client/core/resources/constant.dart';

class BannerImage extends StatelessWidget {
  const BannerImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Image.asset(
        '${Constant.image}/banner.png',
        width: 120,
      ),
    );
  }
}
