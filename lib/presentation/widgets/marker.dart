import 'package:flutter/material.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/widgets/profile_image.dart';

class IMarker extends StatelessWidget {
  final NostalgiaSummary item;

  const IMarker({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ProfileImage(
      size: 36,
      url: item.thumbnail,
    );
  }
}
