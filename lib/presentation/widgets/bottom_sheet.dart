import 'package:flutter/material.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

import 'package:wehere_client/core/resources/constant.dart';

class IBottomSheet extends StatefulWidget {
  final List<BottomSheetItem> items;

  const IBottomSheet({super.key, required this.items});

  @override
  _IBottomSheetState createState() => _IBottomSheetState();
}

class _IBottomSheetState extends State<IBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Container(
        height: widget.items.length * 40 + 32,
        padding: EdgeInsets.all(16),
        child: Column(
          children: widget.items
              .map((e) => InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      e.onPress();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: IText(e.title, color: e.color),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class BottomSheetItem {
  final String title;
  final Function() onPress;
  final Color color;

  BottomSheetItem(
      {required this.title,
      required this.onPress,
      this.color = ColorTheme.primary});
}
