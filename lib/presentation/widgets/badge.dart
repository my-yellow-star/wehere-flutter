import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/nostalgia.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class IBadge extends StatelessWidget {
  static double height = 25.h;

  final Color color;
  final String label;
  final IconData icon;
  final bool Function(Nostalgia) condition;
  final bool Function(NostalgiaSummary) summaryCondition;
  final bool wrap;
  final String description;

  const IBadge({
    Key? key,
    required this.color,
    required this.label,
    required this.icon,
    required this.condition,
    required this.summaryCondition,
    required this.wrap,
    required this.description,
  }) : super(key: key);

  static List<IBadge> items = [
    realLocation(false),
    realTime(false),
    qualitative(false),
    photographer(false),
    global(false),
    bookmark(false),
  ];

  static List<IBadge> summaryItems = [
    realLocation(true),
    realTime(true),
    qualitative(true),
    photographer(true),
    global(true),
    bookmark(true),
  ];

  static IBadge realLocation(bool wrap) {
    return IBadge(
      color: Colors.blue,
      label: '현위치',
      icon: Icons.place_rounded,
      condition: (item) => item.isRealLocation,
      summaryCondition: (item) => item.isRealLocation,
      wrap: wrap,
      description: '추억을 경험했던 그 곳에서 작성된 추억이에요.',
    );
  }

  static IBadge realTime(bool wrap) {
    return IBadge(
      color: Colors.green,
      label: '실시간',
      icon: Icons.access_time_filled_rounded,
      condition: (item) => item.isRealTime,
      summaryCondition: (item) => item.isRealTime,
      wrap: wrap,
      description: '추억을 경험했던 그 순간에 작성된 추억이에요.',
    );
  }

  static IBadge qualitative(bool wrap) {
    return IBadge(
      color: Colors.redAccent,
      label: '정성추',
      icon: Icons.favorite,
      condition: (item) => item.description.length >= 300,
      summaryCondition: (item) => item.description.length >= 300,
      wrap: wrap,
      description: '본문이 300자가 넘는 정성 담긴 추억이에요.',
    );
  }

  static IBadge global(bool wrap) {
    return IBadge(
      color: Colors.deepPurple,
      label: '글로벌',
      icon: Icons.language,
      condition: (item) => !item.location.isInKorea,
      summaryCondition: (item) => !item.location.isInKorea,
      wrap: wrap,
      description: '멀리 떠났던 당신. 해외에서 남긴 추억이에요.',
    );
  }

  static IBadge photographer(bool wrap) {
    return IBadge(
      color: Colors.deepOrange,
      label: '사진광',
      icon: Icons.camera_alt,
      condition: (item) => item.images.length >= 10,
      summaryCondition: (item) => item.imageCount >= 10,
      wrap: wrap,
      description: '추억 사진을 10개 이상 올린 그대는 사진광',
    );
  }

  static IBadge bookmark(bool wrap) {
    return IBadge(
      color: Colors.brown,
      label: '책갈피',
      icon: Icons.bookmark,
      condition: (item) => item.bookmarkCount > 0,
      summaryCondition: (item) => item.bookmarkCount > 0,
      wrap: wrap,
      description: '선한 영향력. 누군가 당신의 추억을 담아갔어요.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return wrap
        ? Container(
            padding: EdgeInsets.all(PaddingHorizontal.tiny),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: IconSize.tiny,
            ),
          )
        : Container(
            height: height,
            padding: EdgeInsets.only(
              left: PaddingHorizontal.small,
              right: PaddingHorizontal.tiny,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IText(
                  label,
                  size: FontSize.tiny,
                ),
                Container(width: PaddingHorizontal.tiny),
                Icon(
                  icon,
                  color: Colors.white,
                  size: IconSize.tiny,
                ),
              ],
            ),
          );
  }
}
