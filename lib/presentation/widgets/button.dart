import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Function()? onPress;
  final double size;
  final double iconSize;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final double backgroundOpacity;
  final Color shadowColor;

  const RoundButton(
      {super.key,
      this.onPress,
      this.size = 32,
      required this.icon,
      this.color = Colors.white,
      this.backgroundColor = Colors.black,
      this.shadowColor = Colors.transparent,
      this.iconSize = 18,
      this.backgroundOpacity = 0.4});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            color: backgroundColor.withOpacity(backgroundOpacity),
            borderRadius: BorderRadius.circular(size),
            boxShadow: [BoxShadow(color: shadowColor, blurRadius: 4)]),
        child: Icon(icon, size: iconSize, color: color),
      ),
    );
  }
}
