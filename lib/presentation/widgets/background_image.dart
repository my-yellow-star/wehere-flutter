import 'package:flutter/material.dart';

import '../../core/resources/constant.dart';

class BackgroundImage extends StatelessWidget {
  final String? url;
  final double? opacity;

  const BackgroundImage({super.key, this.url, this.opacity});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        url == null
            ? Image.asset(
                '${Constant.image}/airplane_window.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              )
            : Image.network(
                url!,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
        Container(
          color: ColorTheme.primary.withOpacity(opacity ?? 0.8),
        ),
      ],
    );
  }
}
