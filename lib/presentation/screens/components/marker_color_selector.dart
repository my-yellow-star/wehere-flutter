import 'package:flutter/material.dart';
import 'package:wehere_client/core/params/marker_color.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class MarkerColorSelector extends StatefulWidget {
  final MarkerColor selected;
  final Function(MarkerColor) onSelected;

  const MarkerColorSelector(
      {super.key, required this.selected, required this.onSelected});

  @override
  State<MarkerColorSelector> createState() => _MarkerColorSelectorState();
}

class _MarkerColorSelectorState extends State<MarkerColorSelector> {
  void _onTap() async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.fromLTRB(16, 36, 16, 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: Constant.markerColors
                  .map((e) => InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          widget.onSelected(e);
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(4, 6, 4, 6),
                          decoration: widget.selected.value == e.value
                              ? BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black, blurRadius: 4)
                                    ])
                              : null,
                          child: Image.asset(
                            e.filename,
                            height: 50,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      child: Row(
        children: [
          Image.asset(
            widget.selected.filename,
            height: 24,
            fit: BoxFit.fitHeight,
          ),
          Container(
            width: 8,
          ),
          IText(
            '색상선택',
            color: Colors.black,
            size: FontSize.small,
          )
        ],
      ),
    );
  }
}
