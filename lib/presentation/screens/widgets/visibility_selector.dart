import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/params/nostalgia_visibility.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/providers/nostalgia_editor_provider.dart';
import 'package:wehere_client/presentation/screens/widgets/text.dart';

class VisibilitySelector extends StatelessWidget {
  const VisibilitySelector({super.key});

  List<Widget> _items(BuildContext context) {
    final provider = context.read<NostalgiaEditorProvider>();
    final options = [NostalgiaVisibility.all, NostalgiaVisibility.owner];
    return options
        .map((e) => InkWell(
              onTap: () {
                Navigator.pop(context);
                provider.updateVisibility(e);
              },
              child: Container(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: IText(e.translate(),
                      color: ColorTheme.primary,
                      weight: provider.visibility == e
                          ? FontWeight.bold
                          : FontWeight.normal)),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .3,
      padding: EdgeInsets.all(16),
      child: Column(
        children: _items(context),
      ),
    );
  }
}
