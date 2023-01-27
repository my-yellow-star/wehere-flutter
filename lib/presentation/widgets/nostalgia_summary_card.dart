import 'package:flutter/material.dart';
import 'package:wehere_client/core/extensions.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/widgets/profile_image.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class NostalgiaSummaryCard extends StatelessWidget {
  final NostalgiaSummary item;
  static const double radius = 16;
  static const double width = 150;
  static const double imageHeight = 200;
  static const double elevation = 2;
  static const double paddingHorizontal = 8;
  static const double paddingVertical = 12;
  static const double iconSize = 12;
  static const fontColor = Colors.white;

  const NostalgiaSummaryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        width: width,
        child: Card(
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(radius)),
                child: Image.network(
                  item.thumbnail!,
                  width: width,
                  height: imageHeight,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                  margin: EdgeInsets.only(
                      left: paddingHorizontal, top: paddingVertical),
                  child:
                      ProfileImage(url: item.member.profileImageUrl, size: 24)),
              Container(
                margin: EdgeInsets.only(top: imageHeight / 2),
                padding: EdgeInsets.fromLTRB(
                    paddingHorizontal, 4, paddingHorizontal, paddingVertical),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(radius),
                        bottomRight: Radius.circular(radius))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IText(
                          item.title,
                          color: fontColor,
                          size: FontSize.small,
                        ),
                        Container(height: 2),
                        IText(
                          item.description,
                          color: fontColor,
                          size: FontSize.small,
                          weight: FontWeight.w200,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.place_outlined,
                                color: fontColor, size: iconSize),
                            IText(item.distance?.parseDistance() ?? '???',
                                color: fontColor, size: FontSize.tiny)
                          ],
                        ),
                        IText(
                          item.createdAt.parseDate(),
                          color: fontColor,
                          size: FontSize.tiny,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
