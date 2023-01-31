import 'package:flutter/material.dart';
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
          (context, index) => Image.network(
                items[index].thumbnail!,
                width: size.width / 3,
                height: size.width / 3,
                fit: BoxFit.cover,
              ),
          childCount: items.length),
    );
  }
}