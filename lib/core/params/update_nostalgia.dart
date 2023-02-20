import 'package:wehere_client/core/params/marker_color.dart';
import 'package:wehere_client/core/params/nostalgia_visibility.dart';

class UpdateNostalgiaParams {
  final String id;
  final String? title;
  final String? description;
  final NostalgiaVisibility? visibility;
  final List<String>? images;
  final MarkerColor? markerColor;
  final double? latitude;
  final double? longitude;
  final DateTime? memorizedAt;
  final String? address;
  final bool? isRealLocation;

  UpdateNostalgiaParams({
    required this.id,
    this.title,
    this.description,
    this.visibility,
    this.images,
    this.markerColor,
    this.latitude,
    this.longitude,
    this.memorizedAt,
    this.address,
    this.isRealLocation,
  });
}
