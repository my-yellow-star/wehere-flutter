import 'dart:math';

import 'package:wehere_client/domain/entities/location.dart';

class LocationUtil {
  static double calculateZoom(
      Location location, double maxDistance, double mapSize) {
    return log(156543.03392 *
            cos(location.latitude * pi / 180) /
            maxDistance *
            mapSize /
            2) /
        log(2);
  }

  static double metersPerPx(Location location, double zoom) =>
      156543.03392 * cos(location.latitude * pi / 180) / pow(2, zoom);
}
