import 'package:flutter/material.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/presentation/screens/widgets/mypage/my_bookmark_view.dart';
import 'package:wehere_client/presentation/screens/widgets/mypage/my_nostalgia_list_view.dart';
import 'package:wehere_client/presentation/screens/widgets/mypage/my_nostalgia_map_view.dart';
import 'package:wehere_client/presentation/screens/widgets/mypage/mypage_tabbar.dart';

class MyPageTabView extends StatefulWidget {
  final Member? member;
  final bool scrollEnabled;

  const MyPageTabView(
      {super.key, required this.member, required this.scrollEnabled});

  @override
  State<MyPageTabView> createState() => _MyPageTabViewState();
}

class _MyPageTabViewState extends State<MyPageTabView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyPageTabBar(tabController: _tabController),
        widget.member != null
            ? Expanded(
                child: TabBarView(controller: _tabController, children: [
                  MyNostalgiaListView(
                    member: widget.member!,
                    scrollEnabled: widget.scrollEnabled,
                  ),
                  MyNostalgiaMapView(
                    member: widget.member!,
                    scrollEnabled: widget.scrollEnabled,
                  ),
                  MyBookmarkView(
                    member: widget.member!,
                    scrollEnabled: widget.scrollEnabled,
                  )
                ]),
              )
            : Container(),
      ],
    );
  }
}
