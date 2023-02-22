import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wehere_client/presentation/components/image.dart';

class ProfileImage extends StatelessWidget {
  final double size;
  final String? url;
  final ImageType type;

  const ProfileImage(
      {super.key, required this.size, this.url, this.type = ImageType.network});

  ImageProvider get _provider {
    if (type == ImageType.network) {
      return CachedNetworkImageProvider(url!);
    } else {
      return FileImage(File(url!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4)
          ]),
      child: url != null
          ? CircleAvatar(
              radius: size / 2,
              backgroundImage: _provider,
            )
          : Icon(Icons.account_circle, size: size, color: Colors.white),
    );
  }
}
