import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final double size;
  final String? url;

  const ProfileImage({super.key, required this.size, this.url});

  @override
  Widget build(BuildContext context) {
    return url != null
        ? CircleAvatar(
            radius: size / 2,
            backgroundImage: NetworkImage(url!),
          )
        : Icon(Icons.account_circle, size: size, color: Colors.grey);
  }
}
