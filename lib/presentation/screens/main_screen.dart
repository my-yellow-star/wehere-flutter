import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/refresh_propagator.dart';
import 'package:wehere_client/presentation/screens/components/app_version_manager.dart';
import 'package:wehere_client/presentation/screens/home_screen.dart';
import 'package:wehere_client/presentation/screens/map_screen.dart';
import 'package:wehere_client/presentation/screens/mypage_screen.dart';
import 'package:wehere_client/presentation/screens/nostalgia_editor_screen.dart';
import 'package:wehere_client/presentation/screens/permission_screen.dart';
import 'package:wehere_client/presentation/widgets/mixin.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with AfterLayoutMixin {
  int _selectedIndex = 0;

  @override
  void initState() {
    AppVersionManager.manage(context);
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final member =
        context.read<AuthenticationProvider>().authentication?.member;

    if (member == null) {
      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
    }
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MapScreen(),
    MyPageScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index && index == 0) {
      context.read<RefreshPropagator>().propagate('nostalgia-list');
    }
    if (_selectedIndex == index && index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NostalgiaEditorScreen(),
          ));
    }
    if (_selectedIndex == index && index == 2) {
      context.read<RefreshPropagator>().propagate('member');
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<LocationProvider>().permitted) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: ColorTheme.primary,
          items: [
            TabItem(
                icon: Icon(Icons.home_outlined, color: Colors.white),
                activeIcon: Icon(
                  Icons.home,
                  color: Colors.white,
                )),
            TabItem(
              // icon: Icon(Icons.place_rounded,
              //     color: ColorTheme.primary, size: 36),
              icon: Center(
                child: Image.asset(
                  Constant.defaultMarker,
                  height: 36,
                  width: 32,
                ),
              ),
              activeIcon: Center(
                child: Image.asset(
                  Constant.plusButton,
                  height: 36,
                  width: 36,
                ),
              ),
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
