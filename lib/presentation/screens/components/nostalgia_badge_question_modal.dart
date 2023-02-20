import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/widgets/badge.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class NostalgiaBadgeQuestionModal extends StatelessWidget {
  const NostalgiaBadgeQuestionModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(PaddingHorizontal.normal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IText(
            '추억 뱃지',
            weight: FontWeight.bold,
            color: Colors.black,
            align: TextAlign.center,
          ),
          Container(height: PaddingVertical.big),
          IText(
            '핀플에서는 몇몇 특별한 추억들에게 뱃지를 남겨줘요.',
            weight: FontWeight.w100,
            color: Colors.black,
            size: FontSize.small,
            maxLines: 2,
          ),
          Container(height: PaddingVertical.big),
          ...IBadge.items.where((badge) => !badge.hidden).map((badge) => Container(
                padding: EdgeInsets.only(bottom: PaddingVertical.normal),
                child: Row(
                  children: [
                    badge,
                    Container(width: PaddingHorizontal.small),
                    IText(
                      badge.description,
                      weight: FontWeight.w100,
                      color: Colors.black,
                      size: FontSize.small,
                    )
                  ],
                ),
              )),
          Container(height: PaddingVertical.normal),
          IText(
            '이 외에 숨겨진 뱃지가 있을지도 몰라요',
            weight: FontWeight.w100,
            color: Colors.black,
            size: FontSize.small,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
