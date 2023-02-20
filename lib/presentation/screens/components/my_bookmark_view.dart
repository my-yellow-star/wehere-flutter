import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/my_nostalgia_bookmark_provider.dart';
import 'package:wehere_client/presentation/providers/refresh_propagator.dart';
import 'package:wehere_client/presentation/widgets/mixin.dart';
import 'package:wehere_client/presentation/widgets/nostalgia_map_card.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class MyBookmarkView extends StatefulWidget {
  final bool scrollEnabled;
  final Member member;

  const MyBookmarkView(
      {super.key, required this.member, required this.scrollEnabled});

  @override
  State<MyBookmarkView> createState() => _MyBookmarkViewState();
}

class _MyBookmarkViewState extends State<MyBookmarkView> with AfterLayoutMixin {
  @override
  void initState() {
    super.initState();
    context.read<MyNostalgiaBookmarkProvider>().initialize();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final bookmarkProvider = context.read<MyNostalgiaBookmarkProvider>();
    bookmarkProvider
        .initializeLocation(context.read<LocationProvider>().location!);
    if (context.read<AuthenticationProvider>().authentication!.member.id !=
        widget.member.id) {
      bookmarkProvider.initializeMemberId(widget.member.id);
    }
    _loadList();
  }

  void _refresh() {
    final provider = context.read<MyNostalgiaBookmarkProvider>();
    provider.initialize();
    provider.loadList();
  }

  void _loadList() {
    final provider = context.read<MyNostalgiaBookmarkProvider>();
    provider.loadList();
  }

  @override
  Widget build(BuildContext context) {
    final shouldRefresh =
        context.watch<RefreshPropagator>().consume('nostalgia-bookmark');

    if (shouldRefresh) {
      _refresh();
    }

    final items = context.watch<MyNostalgiaBookmarkProvider>().items;

    if (items.isEmpty) {
      return Stack(
        children: const [
          Center(
            child: IText(
              '다른 사람들의 추억을 둘러보고\n맘에 드는 추억을 담아보세요!',
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
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => NostalgiaMapCard(
                        item: items[index],
                        paddingBottom: PaddingVertical.normal,
                      ),
                  childCount: items.length)),
        ],
      ),
    );
  }
}
