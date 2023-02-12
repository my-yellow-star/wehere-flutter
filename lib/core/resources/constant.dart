import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  static double tiny = 10.sp;
  static double small = 13.sp;
  static double regular = 17.sp;
  static double big = 28.sp;
  static double huge = 34.sp;
}

class PaddingHorizontal {
  static double tiny = 4.w;
  static double small = 8.w;
  static double normal = 16.w;
  static double big = 24.w;
}

class PaddingVertical {
  static double tiny = 4.h;
  static double small = 8.h;
  static double normal = 16.h;
  static double big = 24.h;
}

class IconSize {
  static double small = 16;
  static double normal = 24;
  static double big = 36;
}

class ProfileSize {
  static double tiny = 16.h;
  static double small = 24.h;
  static double normal = 36.h;
  static double big = 48.h;
  static double huge = 60.h;
  static double title = 80.h;
}

class MarkerSize {
  static Map<String, int> large = {'width': 88, 'height': 99};
}

class ColorTheme {
  static const primary = Colors.black;
  static final transparent = Colors.black.withOpacity(0);
}
