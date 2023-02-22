import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/image.dart';

class MarkerIconProvider {
  static final Map<MarkerIconSize, Map<String, BitmapDescriptor>> _iconMap = {
    MarkerIconSize.normal: {},
    MarkerIconSize.large: {}
  };

  static Future<Map<String, BitmapDescriptor>> getIcons(
      {MarkerIconSize size = MarkerIconSize.normal}) async {
    if (_iconMap[size]!.isEmpty) {
      for (var markerColor in Constant.markerColors) {
        final byte = ImageUtil.resizeImage(
            (await rootBundle.load(markerColor.filename)).buffer.asUint8List(),
            size == MarkerIconSize.normal
                ? MarkerSize.normal['width']
                : MarkerSize.large['width'],
            size == MarkerIconSize.normal
                ? MarkerSize.normal['height']
                : MarkerSize.large['height']);
        final icon = BitmapDescriptor.fromBytes(byte!);
        _iconMap[size]![markerColor.value] = icon;
      }
    }
    return _iconMap[size]!;
  }
}

enum MarkerIconSize { normal, large }
