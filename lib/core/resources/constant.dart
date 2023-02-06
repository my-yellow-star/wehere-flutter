import 'package:flutter/material.dart';

class Constant {
  // static const apiHost = 'http://43.201.113.135';
  static const apiHost = 'http://localhost:8080';
  static const defaultImage =
      'https://wehere-public.s3.ap-northeast-2.amazonaws.com/64e1f72c-9359-46cd-bf61-aba6a4d3d272/9ea67a95-5926-4687-86b7-c49631813de6.png';
  static const defaultImageAsset = 'asset/image/sky-airplane.png';
  static const image = 'asset/image';
  static const fontFamily = 'Pretendard';
}

class FontSize {
  static const double tiny = 10;
  static const double small = 13;
  static const double regular = 17;
  static const double big = 28;
  static const double huge = 34;
}

class ColorTheme {
  static const primary = Colors.black;
  static final transparent = Colors.black.withOpacity(0);
}
