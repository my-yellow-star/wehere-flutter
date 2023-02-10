import 'package:flutter/material.dart';
import 'package:wehere_client/core/params/nostalgia_visibility.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class MapVisibilitySwitch extends StatelessWidget {
  final Function() onTap;
  final NostalgiaVisibility visibility;
  final bool highlight;

  const MapVisibilitySwitch(
      {super.key,
      required this.onTap,
      required this.highlight,
      required this.visibility});

  String get label => visibility == NostalgiaVisibility.all ? '나만 보기' : '전체 보기';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.fromLTRB(24, 7, 24, 7),
        decoration: BoxDecoration(
            color: highlight ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                  color:
                      (highlight ? Colors.black : Colors.blue).withOpacity(0.5),
                  blurRadius: 8)
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IText(
              label,
              size: FontSize.small,
              color: highlight ? Colors.white : Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
