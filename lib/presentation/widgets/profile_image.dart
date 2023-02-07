import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final double size;
  final String? url;

  const ProfileImage({super.key, required this.size, this.url});

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
              backgroundImage: CachedNetworkImageProvider(url!),
            )
          : Icon(Icons.account_circle, size: size, color: Colors.grey),
    );
  }
}
