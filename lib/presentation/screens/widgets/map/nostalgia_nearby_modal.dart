import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/screens/widgets/map/nostalgia_map_card.dart';

class NostalgiaNearbyModal extends StatelessWidget {
  final List<NostalgiaSummary> items;

  const NostalgiaNearbyModal({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: ColorTheme.primary,
      height: size.height * .8,
      child: Column(
        children: [
          SizedBox(
            height: 24,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
                height: 2,
                width: size.width * .2,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              physics: RangeMaintainingScrollPhysics(),
              children: items
                  .map((item) => NostalgiaMapCard(
                        item: item,
                        paddingBottom: PaddingVertical.normal,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
