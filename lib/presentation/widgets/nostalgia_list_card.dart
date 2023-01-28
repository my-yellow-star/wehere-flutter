import 'package:flutter/material.dart';
import 'package:wehere_client/core/extensions.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class NostalgiaListCard extends StatelessWidget {
  final NostalgiaSummary item;

  const NostalgiaListCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24),
      padding: EdgeInsets.only(left: 8, right: 16, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: const [BoxShadow(blurRadius: 8)],
          borderRadius: BorderRadius.all(Radius.circular(24))),
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            child: Image.network(
              item.thumbnail!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Container(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IText(item.title),
                Container(height: 4),
                IText(item.description, weight: FontWeight.w300),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.place_outlined,
                              color: Colors.white, size: 16),
                          IText(item.distance?.parseDistance() ?? '???',
                              size: FontSize.small),
                        ],
                      ),
                      IText(
                        item.createdAt.parseDate(),
                        size: FontSize.small,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
