import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/nostalgia.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/screens/widgets/detail/nostalgia_badge_question_modal.dart';
import 'package:wehere_client/presentation/screens/widgets/badge.dart';
import 'package:wehere_client/presentation/screens/widgets/button.dart';

class NostalgiaBadgeList {
  static void _onTapBadgeQuestion(BuildContext context) {
    showModalBottomSheet(
        context: context, builder: (context) => NostalgiaBadgeQuestionModal());
  }

  static Widget buildFromSummary(BuildContext context, NostalgiaSummary item) {
    return Row(
      children: IBadge.summaryItems
          .where((element) => element.summaryCondition(item))
          .map((element) => Container(
              padding: EdgeInsets.only(right: PaddingHorizontal.small),
              child: element))
          .toList(),
    );
  }

  static Widget build(BuildContext context, Nostalgia item) {
    final badges = IBadge.items
        .where((element) => element.condition(item))
        .map((element) => Container(
            padding: EdgeInsets.only(right: PaddingHorizontal.tiny),
            child: element))
        .toList();
    return InkWell(
      onTap: () {
        _onTapBadgeQuestion(context);
      },
      child: SizedBox(
        height: IBadge.height,
        child: Row(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(right: PaddingHorizontal.small),
                scrollDirection: Axis.horizontal,
                children: badges,
              ),
            ),
            Container(width: PaddingHorizontal.small),
            RoundButton(
              onPress: () {
                _onTapBadgeQuestion(context);
              },
              icon: Icons.question_mark_rounded,
              color: Colors.white,
              backgroundOpacity: 1,
              backgroundColor: Colors.grey,
              iconSize: IconSize.tiny,
              size: IconSize.small,
            )
          ],
        ),
      ),
    );
  }
}
