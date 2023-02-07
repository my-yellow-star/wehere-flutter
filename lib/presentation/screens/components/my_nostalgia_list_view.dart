import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';
import 'package:wehere_client/presentation/widgets/mixin.dart';
import 'package:wehere_client/presentation/widgets/nostalgia_list_grid.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class MyNostalgiaListView extends StatefulWidget {
  const MyNostalgiaListView({super.key});

  @override
  State<MyNostalgiaListView> createState() => _MyNostalgiaListViewState();
}

class _MyNostalgiaListViewState extends State<MyNostalgiaListView>
    with AfterLayoutMixin {
  @override
  void initState() {
    super.initState();
    context.read<NostalgiaListProvider>().initialize();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _loadList();
  }

  void _loadList() {
    final location = context.read<LocationProvider>().location!;
    final nostalgia = context.read<NostalgiaListProvider>();
    nostalgia.loadList(
        size: 12,
        condition: NostalgiaCondition.member,
        latitude: location.latitude,
        longitude: location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final items = context.watch<NostalgiaListProvider>().items;

    if (items.isEmpty) {
      return Stack(
        children: const [
          Center(
            child: IText(
              '추억이 비어있어요\n첫 추억을 남겨보세요!',
              weight: FontWeight.w100,
              align: TextAlign.center,
            ),
          )
        ],
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          _loadList();
        }
        return false;
      },
      child: CustomScrollView(
        physics: RangeMaintainingScrollPhysics(),
        slivers: [NostalgiaListGrid(items: items)],
      ),
    );
  }
}
