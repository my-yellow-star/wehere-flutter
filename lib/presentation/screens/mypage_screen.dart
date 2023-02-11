import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/member_provider.dart';
import 'package:wehere_client/presentation/screens/components/mypage_header.dart';
import 'package:wehere_client/presentation/screens/components/mypage_tabview.dart';
import 'package:wehere_client/presentation/screens/components/profile_background.dart';
import 'package:wehere_client/presentation/screens/components/setting_options.dart';
import 'package:wehere_client/presentation/screens/nostalgia_editor_screen.dart';
import 'package:wehere_client/presentation/widgets/alert.dart';
import 'package:wehere_client/presentation/widgets/bottom_sheet.dart';
import 'package:wehere_client/presentation/widgets/image_selector.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  bool _editMode = false;
  bool _innerScrollEnabled = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<MemberProvider>().initialize();
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
        builder: (_) => ImageSelector(
            canSelectMultipleImage: false,
            onImageSelected: (images) {
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
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification &&
                  notification.depth == 0) {
                if (notification.metrics.maxScrollExtent -
                        notification.metrics.pixels <
                    10) {
                  setState(() {
                    _innerScrollEnabled = true;
                  });
                } else {
                  setState(() {
                    _innerScrollEnabled = false;
                  });
                }
              }
              return false;
            },
            child: NestedScrollView(
              controller: _scrollController,
              physics: NeverScrollableScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverSafeArea(
                      top: false,
                      sliver: SliverAppBar(
                          automaticallyImplyLeading: false,
                          backgroundColor: ColorTheme.primary,
                          expandedHeight: size.height * .5 - kToolbarHeight,
                          floating: false,
                          pinned: true,
                          title: MyPageHeader(
                              auth: auth,
                              member: member,
                              editMode: _editMode,
                              onTapEditBackground: _onTapEditBackground,
                              onTapEditCancel: _onTapEditCancel,
                              onTapEditSave: _onTapEditSave,
                              createNostalgia: _createNostalgia,
                              onTapSettingButton: _onTapSettingButton),
                          flexibleSpace: FlexibleSpaceBar(
                              background: ProfileBackground(
                            editMode: _editMode,
                          ))),
                    ),
                  ),
                ];
              },
              body: MyPageTabView(
                member: member,
                scrollEnabled: _innerScrollEnabled,
              ),
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
