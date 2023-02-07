import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/member_provider.dart';
import 'package:wehere_client/presentation/screens/components/profile_background.dart';
import 'package:wehere_client/presentation/screens/components/profile_tap.dart';
import 'package:wehere_client/presentation/screens/components/setting_options.dart';
import 'package:wehere_client/presentation/screens/nostalgia_editor_screen.dart';
import 'package:wehere_client/presentation/widgets/bottom_sheet.dart';
import 'package:wehere_client/presentation/widgets/button.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null) {
        // other member's my page
        context.read<MemberProvider>().loadUser(id: (args as String));
      } else {
        context.read<MemberProvider>().loadUser();
      }
    });
  }

  void _createNostalgia() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NostalgiaEditorScreen(),
        ));
  }

  void _onTapSettingButton() {
    showModalBottomSheet(
        context: context,
        builder: (context) =>
            IBottomSheet(items: SettingOptions(context).options));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthenticationProvider>().authentication;
    final member = context.watch<MemberProvider>().member;

    if (auth == null) {
      Future.microtask(() {
        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
      });
      return Container();
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorTheme.primary,
      body: NestedScrollView(
        physics: RangeMaintainingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverSafeArea(
                top: false,
                sliver: SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: ColorTheme.primary,
                    expandedHeight: size.height * .5 - kToolbarHeight,
                    floating: false,
                    pinned: true,
                    title: auth.member.id == member?.id
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RoundButton(
                                icon: Icons.add_circle,
                                iconSize: 24,
                                color: Colors.white,
                                shadowOpacity: 0,
                                onPress: _createNostalgia,
                              ),
                              RoundButton(
                                icon: Icons.settings,
                                iconSize: 24,
                                color: Colors.white,
                                shadowOpacity: 0,
                                onPress: _onTapSettingButton,
                              )
                            ],
                          )
                        : Container(),
                    flexibleSpace: FlexibleSpaceBar(
                        background: ProfileBackground(
                      member: member,
                    ))),
              ),
            ),
          ];
        },
        body: ProfileTabBar(
          member: member,
        ),
      ),
    );
  }
}
