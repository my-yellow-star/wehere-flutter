import 'package:flutter/material.dart';
import 'package:wehere_client/core/extensions.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class NostalgiaMapCard extends StatelessWidget {
  final NostalgiaSummary item;
  static const double paddingBottom = 20;

  const NostalgiaMapCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'nostalgia-detail', arguments: item.id);
      },
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(item.thumbnail!))),
        height: size.height * .2,
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, paddingBottom),
          color: Colors.black.withOpacity(0.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IText(item.title, weight: FontWeight.bold),
                    Container(height: 4),
                    IText(
                      item.description,
                      size: FontSize.small,
                      maxLines: 4,
                    ),
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
        ),
      ),
    );
  }
}
