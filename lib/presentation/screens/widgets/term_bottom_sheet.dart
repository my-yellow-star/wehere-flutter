import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/core/resources/term.dart';
import 'package:wehere_client/presentation/screens/widgets/text.dart';

class TermBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(
            left: PaddingHorizontal.normal,
            right: PaddingHorizontal.normal,
            top: PaddingVertical.big,
            bottom: PaddingVertical.big),
        height: MediaQuery.of(context).size.height * .8,
        child: Column(
          children: [
            IText(
              '서비스 이용 약관',
              color: Colors.black,
            ),
            Container(height: PaddingVertical.normal),
            Expanded(
              child: SingleChildScrollView(
                child: IText(
                  Term.value,
                  maxLines: 1000,
                  size: FontSize.small,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
