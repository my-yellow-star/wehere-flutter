import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';

class IText extends StatelessWidget {
  final double? size;
  final Color? color;
  final String text;
  final FontWeight? weight;
  final TextAlign? align;
  final int? maxLines;
  final List<Shadow>? shadows;

  const IText(this.text,
      {super.key,
      this.size,
      this.color,
      this.weight,
      this.align,
      this.maxLines,
      this.shadows});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: align,
      style: TextStyle(
          shadows: shadows,
          fontSize: size ?? FontSize.regular,
          color: color ?? Colors.white,
          fontWeight: weight ?? FontWeight.normal,
          fontFamilyFallback: const [
            '-apple-system',
            'BlinkMacSystemFont',
            'system-ui',
            'Roboto',
            'Helvetica Neue',
            'Segoe UI',
            'Apple SD Gothic Neo',
            'Noto Sans KR',
            'Malgun Gothic',
            'Apple Color Emoji',
            'Segoe UI Emoji',
            'Segoe UI Symbol',
            'sans-serif'
          ]),
    );
  }
}
