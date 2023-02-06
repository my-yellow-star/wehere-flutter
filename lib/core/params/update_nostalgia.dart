import 'package:wehere_client/core/params/nostalgia_visibility.dart';

class UpdateNostalgiaParams {
  final String id;
  final String? title;
  final String? description;
  final NostalgiaVisibility? visibility;
  final List<String>? images;

  UpdateNostalgiaParams(
      {required this.id,
      this.title,
      this.description,
      this.visibility,
      this.images});
}
