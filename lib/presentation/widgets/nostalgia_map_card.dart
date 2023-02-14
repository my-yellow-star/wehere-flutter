import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wehere_client/core/extensions.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/widgets/profile_image.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class NostalgiaMapCard extends StatelessWidget {
  final NostalgiaSummary item;
  final double? paddingBottom;

  const NostalgiaMapCard({
    super.key,
    required this.item,
    this.paddingBottom,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'nostalgia-detail', arguments: item.id);
      },
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: item.thumbnail != null
                    ? NetworkImage(item.thumbnail!)
                    : AssetImage(Constant.defaultImageAsset) as ImageProvider)),
        height: size.height * .2 + (paddingBottom ?? 30.h),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            PaddingHorizontal.normal,
            PaddingVertical.normal,
            PaddingHorizontal.normal,
            paddingBottom ?? 30.h,
          ),
          color: Colors.black.withOpacity(0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ProfileImage(
                          size: ProfileSize.small,
                          url: item.member.profileImageUrl,
                        ),
                        Container(width: PaddingHorizontal.small),
                        IText(
                          item.member.nickname,
                          size: FontSize.small,
                        )
                      ],
                    ),
                    Container(height: PaddingVertical.tiny),
                    IText(item.title, weight: FontWeight.bold),
                    Container(height: PaddingVertical.tiny),
                    IText(
                      item.description,
                      size: FontSize.small,
                      maxLines: 3,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.place_outlined,
                                  color: Colors.white, size: IconSize.small),
                              SizedBox(
                                width: PaddingHorizontal.tiny,
                                height: 0,
                              ),
                              SizedBox(
                                width: size.width * .7,
                                child: IText(
                                  '${item.address} • ${item.distance?.parseDistance()}',
                                  color: Colors.white,
                                  size: FontSize.small,
                                ),
                              ),
                            ],
                          ),
                          IText(
                            item.createdAt.parseDate(),
                            size: FontSize.small,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
