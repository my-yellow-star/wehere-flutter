import 'package:flutter/material.dart';

class Routes {
  static void push(BuildContext context, Widget screen) {
    Navigator.push(context, _noAnimation(screen));
  }

  static void replace(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      _noAnimation(screen),
    );
  }

  static PageRouteBuilder _noAnimation(Widget screen) => PageRouteBuilder(
        pageBuilder: (context, anim1, anim2) => screen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
}
