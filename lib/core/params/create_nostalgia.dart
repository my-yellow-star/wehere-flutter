import 'package:wehere_client/core/params/marker_color.dart';
import 'package:wehere_client/core/params/nostalgia_visibility.dart';

class CreateNostalgiaParams {
  final String title;
  final String description;
  final NostalgiaVisibility visibility;
  final double latitude;
  final double longitude;
  final List<String> images;
  final MarkerColor markerColor;

  CreateNostalgiaParams({
    required this.title,
    required this.description,
    required this.visibility,
    required this.latitude,
    required this.longitude,
    required this.images,
    required this.markerColor,
  });
}
