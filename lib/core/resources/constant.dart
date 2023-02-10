import 'package:flutter/material.dart';
import 'package:wehere_client/core/params/marker_color.dart';

class Constant {
  static const defaultImage =
      'https://wehere-public.s3.ap-northeast-2.amazonaws.com/64e1f72c-9359-46cd-bf61-aba6a4d3d272/9ea67a95-5926-4687-86b7-c49631813de6.png';
  static const image = 'asset/image';
  static const defaultImageAsset = 'asset/image/sky-airplane.png';
  static const defaultMarker = 'asset/image/pin-blue-green.png';
  static const plusButton = 'asset/image/plus-blue-green.png';
  static const fontFamily = 'Pretendard';
  static const fontFamilyCallback = [
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
  ];
  static List<MarkerColor> markerColors = [
    MarkerColor('BLUE_GREEN', 'asset/image/pin-blue-green.png'),
    MarkerColor('GREEN_YELLOW', 'asset/image/pin-green-yellow.png'),
    MarkerColor('PINK_ORANGE', 'asset/image/pin-pink-orange.png'),
    MarkerColor('RED_YELLOW', 'asset/image/pin-red-yellow.png'),
    MarkerColor('PURPLE_BLUE', 'asset/image/pin-purple-blue.png'),
  ];
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
