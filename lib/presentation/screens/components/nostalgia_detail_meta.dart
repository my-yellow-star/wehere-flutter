import 'package:flutter/material.dart';
import 'package:wehere_client/core/extensions.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/nostalgia.dart';
import 'package:wehere_client/presentation/screens/components/nostalgia_badge_list.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class NostalgiaDetailMeta extends StatefulWidget {
  final Nostalgia item;

  const NostalgiaDetailMeta({Key? key, required this.item}) : super(key: key);

  @override
  State<NostalgiaDetailMeta> createState() => _NostalgiaDetailMetaState();
}

class _NostalgiaDetailMetaState extends State<NostalgiaDetailMeta> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        NostalgiaBadgeList.build(context, widget.item),
        Container(height: PaddingVertical.normal),
        Row(
          children: [
            Icon(
              Icons.calendar_month,
              size: IconSize.small,
              color: Colors.grey,
            ),
            Container(width: PaddingHorizontal.tiny),
            IText(
              widget.item.memorizedAt.parseString(),
              color: Colors.grey,
              size: FontSize.small,
            )
          ],
        ),
        Container(height: PaddingVertical.tiny),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.place_rounded,
              size: IconSize.small,
              color: Colors.grey,
            ),
            Container(width: PaddingHorizontal.tiny),
            SizedBox(
              width: size.width * .8,
              child: IText(
                widget.item.address,
                color: Colors.grey,
                size: FontSize.small,
                maxLines: 2,
              ),
            ),
          ],
        ),
        Container(height: PaddingVertical.tiny),
        Row(
          children: [
            Icon(
              Icons.my_location_rounded,
              size: IconSize.small,
              color: Colors.grey,
            ),
            Container(width: PaddingHorizontal.tiny),
            IText(
              '${widget.item.distance?.parseDistance()}',
              color: Colors.grey,
              size: FontSize.small,
            )
          ],
        )
      ],
    );
  }
}
