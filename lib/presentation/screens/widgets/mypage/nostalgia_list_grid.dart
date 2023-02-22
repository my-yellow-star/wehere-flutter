import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wehere_client/core/params/nostalgia_visibility.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';

class NostalgiaListGrid extends StatelessWidget {
  final List<NostalgiaSummary> items;

  const NostalgiaListGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      delegate: SliverChildBuilderDelegate(
          (context, index) => InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'nostalgia-detail',
                      arguments: items[index].id);
                },
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: items[index].thumbnail ?? Constant.defaultImage,
                      width: size.width / 3,
                      height: size.width / 3,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                        top: 4,
                        right: 4,
                        child:
                            items[index].visibility != NostalgiaVisibility.all
                                ? Icon(Icons.lock, size: IconSize.small)
                                : SizedBox(width: 0, height: 0))
                  ],
                ),
              ),
          childCount: items.length),
    );
  }
}
