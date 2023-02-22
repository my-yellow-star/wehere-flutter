import 'package:flutter/material.dart';

class RoundBackButton extends StatelessWidget {
  final bool Function()? onPress;
  final double size;

  const RoundBackButton({super.key, this.onPress, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onPress?.call() == false) {
          return;
        }
        Navigator.pop(context);
      },
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(size)),
        child: Icon(Icons.arrow_back_ios_sharp, size: 18, color: Colors.white),
      ),
    );
  }
}
