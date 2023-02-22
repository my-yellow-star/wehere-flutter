import 'package:flutter/material.dart';

import '../../../../core/resources/constant.dart';

class MyPageTabBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController tabController;

  const MyPageTabBar({super.key, required this.tabController});

  @override
  _MyPageTabBarState createState() => _MyPageTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(50);
}

class _MyPageTabBarState extends State<MyPageTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorTheme.primary,
      child: TabBar(
        controller: widget.tabController,
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
    );
  }
}
