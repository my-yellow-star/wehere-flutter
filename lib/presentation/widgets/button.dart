import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Function()? onPress;
  final double size;
  final double iconSize;
  final IconData icon;
  final Color color;

  const RoundButton(
      {super.key,
      this.onPress,
      this.size = 32,
      required this.icon,
      this.color = Colors.white,
      this.iconSize = 18});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(size)),
        child: Icon(icon, size: iconSize, color: color),
      ),
    );
  }
}
