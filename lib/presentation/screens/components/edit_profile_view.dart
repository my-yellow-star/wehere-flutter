import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/image.dart';
import 'package:wehere_client/presentation/providers/member_provider.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  ImageProvider _provider(IImageSource? image) {
    if (image?.type == ImageType.network) {
      return CachedNetworkImageProvider(image!.path);
    } else if (image?.type == ImageType.file) {
      return FileImage(File(image!.path));
    } else {
      return AssetImage(Constant.defaultImageAsset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MemberProvider>();
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: _provider(provider.backgroundImage), opacity: 0.5)),
      child: Column(
        children: [],
      ),
    );
  }
}
