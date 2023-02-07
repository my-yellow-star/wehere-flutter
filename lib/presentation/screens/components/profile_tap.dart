import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/presentation/screens/components/my_bookmark_view.dart';
import 'package:wehere_client/presentation/screens/components/my_nostalgia_list_view.dart';
import 'package:wehere_client/presentation/screens/components/my_nostalgia_map_view.dart';

class ProfileTabBar extends StatefulWidget {
  final Member member;

  const ProfileTabBar({super.key, required this.member});

  @override
  State<ProfileTabBar> createState() => _ProfileTabBarState();
}

class _ProfileTabBarState extends State<ProfileTabBar>
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
        Container(
          color: ColorTheme.primary,
          child: TabBar(
            controller: _tabController,
            tabs: [
              Container(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.apps),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.map_outlined),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.bookmark),
              )
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 1,
            dividerColor: Colors.grey,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        Expanded(
          child: TabBarView(controller: _tabController, children: [
            MyNostalgiaListView(),
            MyNostalgiaMapView(
              member: widget.member,
            ),
            MyBookmarkView()
          ]),
        ),
      ],
    );
  }
}
