import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/image.dart';

class MarkerIconProvider {
  static final Map<String, BitmapDescriptor> _iconMap = {};

  static Future<Map<String, BitmapDescriptor>> getIcons() async {
    if (_iconMap.isEmpty) {
      for (var markerColor in Constant.markerColors) {
        final byte = ImageUtil.resizeImage(
            (await rootBundle.load(markerColor.filename)).buffer.asUint8List(),
            MarkerSize.large['width'],
            MarkerSize.large['height']);
        final icon = BitmapDescriptor.fromBytes(byte!);
        _iconMap[markerColor.value] = icon;
      }
    }
    return _iconMap;
  }
}
