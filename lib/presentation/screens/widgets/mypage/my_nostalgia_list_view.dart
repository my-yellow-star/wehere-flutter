import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/my_nostalgia_grid_provider.dart';
import 'package:wehere_client/presentation/providers/refresh_propagator.dart';
import 'package:wehere_client/presentation/components/mixin.dart';
import 'package:wehere_client/presentation/screens/widgets/mypage/nostalgia_list_grid.dart';
import 'package:wehere_client/presentation/screens/widgets/text.dart';

class MyNostalgiaListView extends StatefulWidget {
  final bool scrollEnabled;
  final Member member;

  const MyNostalgiaListView(
      {super.key, required this.scrollEnabled, required this.member});

  @override
  State<MyNostalgiaListView> createState() => _MyNostalgiaListViewState();
}

class _MyNostalgiaListViewState extends State<MyNostalgiaListView>
    with AfterLayoutMixin {
  @override
  void initState() {
    super.initState();
    context.read<MyNostalgiaGridProvider>().initialize();
    context.read<RefreshPropagator>().consume('nostalgia-list');
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _loadList();
  }

  void _refresh() {
    context.read<MyNostalgiaGridProvider>().initialize();
    _loadList();
  }

  void _loadList() {
    final location = context.read<LocationProvider>().location!;
    final nostalgia = context.read<MyNostalgiaGridProvider>();
    nostalgia.loadList(
        size: 12,
        condition: NostalgiaCondition.recent,
        memberId: widget.member.id,
        latitude: location.latitude,
        longitude: location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final shouldRefresh =
        context.watch<RefreshPropagator>().consume('nostalgia-list');
    if (shouldRefresh) {
      _refresh();
    }

    final items = context.watch<MyNostalgiaGridProvider>().items;

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
        primary: widget.scrollEnabled,
        physics: NeverScrollableScrollPhysics(),
        slivers: [NostalgiaListGrid(items: items)],
      ),
    );
  }
}
