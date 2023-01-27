import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';

class IText extends StatelessWidget {
  final double? size;
  final Color? color;
  final String text;
  final FontWeight? weight;
  final TextAlign? align;

  const IText(this.text,
      {super.key, this.size, this.color, this.weight, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
          fontSize: size ?? FontSize.regular,
          color: color ?? Colors.white,
          fontWeight: weight ?? FontWeight.normal),
    );
  }
}
