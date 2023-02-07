import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Function()? onPress;
  final double size;
  final double iconSize;
  final IconData icon;
  final Color color;
  final double shadowOpacity;

  const RoundButton(
      {super.key,
      this.onPress,
      this.size = 32,
      required this.icon,
      this.color = Colors.white,
      this.iconSize = 18,
      this.shadowOpacity = 0.4});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(shadowOpacity),
            borderRadius: BorderRadius.circular(size)),
        child: Icon(icon, size: iconSize, color: color),
      ),
    );
  }
}
