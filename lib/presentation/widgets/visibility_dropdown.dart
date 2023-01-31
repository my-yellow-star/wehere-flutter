import 'package:flutter/material.dart';
import 'package:wehere_client/core/params/nostalgia_visibility.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/widgets/text.dart';
import 'package:wehere_client/presentation/widgets/visibility_selector.dart';

class VisibilityDropdown extends StatelessWidget {
  final NostalgiaVisibility selectedVisibility;

  const VisibilityDropdown({super.key, required this.selectedVisibility});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return VisibilitySelector();
              });
        },
        child: Row(
          children: [
            Icon(Icons.arrow_drop_down, size: 24),
            IText(
              selectedVisibility.translate(),
              color: ColorTheme.primary,
              size: FontSize.small,
            )
          ],
        ));
  }
}
