import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/injector.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';
import 'package:wehere_client/presentation/providers/statistic_provider.dart';
import 'package:wehere_client/presentation/screens/nostalgia_editor_screen.dart';
import 'package:wehere_client/presentation/screens/home_screen.dart';
import 'package:wehere_client/presentation/screens/map_screen.dart';
import 'package:wehere_client/presentation/screens/mypage_screen.dart';
import 'package:wehere_client/presentation/screens/permission_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    ChangeNotifierProvider(
      create: (_) => injector<NostalgiaListProvider>(),
      child: HomeScreen(),
    ),
    ChangeNotifierProvider(
      create: (_) => injector<NostalgiaListProvider>(),
      child: MapScreen(),
    ),
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => injector<NostalgiaListProvider>()),
        ChangeNotifierProvider(create: (_) => injector<StatisticProvider>())
      ],
      child: MyPageScreen(),
    )
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index && index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NostalgiaEditorScreen(),
          ));
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<LocationProvider>().permitted) {
      return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: ColorTheme.primary,
          items: const [
            TabItem(
                icon: Icon(Icons.home_outlined, color: Colors.white),
                activeIcon: Icon(
                  Icons.home,
                  color: Colors.white,
                )),
            TabItem(
              icon: Icon(Icons.place_rounded,
                  color: ColorTheme.primary, size: 36),
              activeIcon:
                  Icon(Icons.add_circle, color: ColorTheme.primary, size: 36),
            ),
            TabItem(
              icon: Icon(Icons.account_circle_outlined, color: Colors.white),
              activeIcon: Icon(Icons.account_circle, color: Colors.white),
            ),
          ],
          style: TabStyle.fixedCircle,
          initialActiveIndex: 0,
          onTap: _onItemTapped,
          color: Colors.white,
        ),
      );
    } else {
      return PermissionScreen();
    }
  }
}
