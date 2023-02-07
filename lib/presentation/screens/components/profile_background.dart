import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/presentation/widgets/profile_image.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class ProfileBackground extends StatelessWidget {
  final Member member;

  const ProfileBackground({super.key, required this.member});

  ImageProvider get _backgroundImage {
    if (member.backgroundImageUrl != null) {
      return CachedNetworkImageProvider(member.backgroundImageUrl!);
    } else {
      return AssetImage(Constant.defaultImageAsset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .5,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: _backgroundImage, fit: BoxFit.cover, opacity: 0.5)),
      child: Container(
        padding: EdgeInsets.only(top: kToolbarHeight + 80, left: 16, right: 16),
        child: Column(
          children: [
            ProfileImage(size: 80, url: member.profileImageUrl),
            Container(height: 16),
            IText(
              member.nickname,
              color: Colors.white,
            ),
            Container(
              height: 24,
            ),
            IText(
              member.description ?? '...',
              color: Colors.white,
              weight: FontWeight.w100,
              maxLines: 3,
            )
          ],
        ),
      ),
    );
  }
}
