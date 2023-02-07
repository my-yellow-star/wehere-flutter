import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/member_provider.dart';
import 'package:wehere_client/presentation/screens/components/profile_background.dart';
import 'package:wehere_client/presentation/screens/components/profile_tap.dart';
import 'package:wehere_client/presentation/screens/components/setting_options.dart';
import 'package:wehere_client/presentation/screens/nostalgia_editor_screen.dart';
import 'package:wehere_client/presentation/widgets/alert.dart';
import 'package:wehere_client/presentation/widgets/bottom_sheet.dart';
import 'package:wehere_client/presentation/widgets/button.dart';
import 'package:wehere_client/presentation/widgets/image_selector.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  bool _editMode = false;

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
        builder: (context) => IBottomSheet(
            items: SettingOptions(context, _onTapEditProfile).options));
  }

  void _onTapEditProfile() {
    setState(() {
      _editMode = true;
    });
  }

  void _onTapEditBackground() {
    final provider = context.read<MemberProvider>();
    showModalBottomSheet(
        context: context,
        builder: (_) => ImageSelector(onImageSelected: (images) {
              provider.updateBackgroundImage(images[0]);
            }));
  }

  void _onTapEditSave() {
    final provider = context.read<MemberProvider>();
    if (provider.nickname.length < 2) {
      Alert.build(context,
          title: '닉네임을 확인해주세요', description: '최소 두 글자 이상 작성해주세요');
      return;
    }

    Alert.build(
      context,
      title: '프로필 수정',
      description: '변경 사항을 저장할까요?',
      confirmCallback: _update,
    );
  }

  void _update() async {
    final provider = context.read<MemberProvider>();
    await provider.update();
    await provider.loadUser();
    setState(() {
      _editMode = false;
    });
  }

  void _onTapEditCancel() {
    final provider = context.read<MemberProvider>();
    Alert.build(
      context,
      title: '프로필 수정 취소',
      description: '프로필 수정을 취소하시겠어요?',
      confirmCallback: () {
        provider.cancelUpdate();
        setState(() {
          _editMode = false;
        });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthenticationProvider>().authentication;
    final provider = context.watch<MemberProvider>();
    final member = provider.member;

    if (auth == null) {
      Future.microtask(() {
        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
      });
      return Container();
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorTheme.primary,
      body: Stack(
        children: [
          NestedScrollView(
            physics: RangeMaintainingScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    sliver: SliverAppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: ColorTheme.primary,
                        expandedHeight: size.height * .5 - kToolbarHeight,
                        floating: false,
                        pinned: true,
                        title: auth.member.id == member?.id
                            ? _editMode
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: _onTapEditBackground,
                                        child: IText('배경 편집'),
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: _onTapEditCancel,
                                            child: IText('취소'),
                                          ),
                                          Container(width: 12),
                                          InkWell(
                                            onTap: _onTapEditSave,
                                            child: IText('저장'),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                : Row(
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
                          editMode: _editMode,
                        ))),
                  ),
                ),
              ];
            },
            body: ProfileTabBar(
              member: member,
            ),
          ),
          provider.isLoading
              ? Center(child: CircularProgressIndicator())
              : Container()
        ],
      ),
    );
  }
}
