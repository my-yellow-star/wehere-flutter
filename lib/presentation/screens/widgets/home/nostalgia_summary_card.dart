import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/screens/widgets/detail/nostalgia_badge_list.dart';
import 'package:wehere_client/presentation/screens/widgets/profile_image.dart';
import 'package:wehere_client/presentation/screens/widgets/text.dart';

class NostalgiaSummaryCard extends StatelessWidget {
  final NostalgiaSummary item;

  const NostalgiaSummaryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'nostalgia-detail', arguments: item.id);
      },
      child: UnconstrainedBox(
        constrainedAxis: Axis.horizontal,
        child: CachedNetworkImage(
          imageUrl: item.thumbnail ?? Constant.defaultImage,
          imageBuilder: (context, imageProvider) => Container(
            height: size.height / 2,
            margin: EdgeInsets.only(
              right: PaddingHorizontal.big,
              left: PaddingHorizontal.big,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 26),
                      color: Colors.black54,
                      blurRadius: 16,
                      spreadRadius: -12),
                ],
                image:
                    DecorationImage(fit: BoxFit.cover, image: imageProvider)),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                PaddingHorizontal.normal,
                PaddingVertical.normal,
                PaddingHorizontal.normal,
                PaddingVertical.normal,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ProfileImage(
                          size: ProfileSize.small,
                          url: item.member.profileImageUrl),
                      Container(width: PaddingHorizontal.small),
                      IText(
                        item.member.nickname,
                        size: FontSize.small,
                        shadows: [
                          Shadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 16)
                        ],
                      )
                    ],
                  ),
                  NostalgiaBadgeList.buildFromSummary(context, item)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
