import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';
import 'package:wehere_client/presentation/providers/statistic_provider.dart';
import 'package:wehere_client/presentation/screens/create_nostalgia_screen.dart';
import 'package:wehere_client/presentation/widgets/background_image.dart';
import 'package:wehere_client/presentation/widgets/mixin.dart';
import 'package:wehere_client/presentation/widgets/nostalgia_list_grid.dart';
import 'package:wehere_client/presentation/widgets/profile_map_view.dart';
import 'package:wehere_client/presentation/widgets/profile_summary.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> with AfterLayoutMixin {
  List<NostalgiaSummary> _recent30Items = [];

  @override
  void initState() {
    super.initState();
    context.read<NostalgiaListProvider>().initialize();
    context.read<StatisticProvider>().initialize();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final member =
        context.read<AuthenticationProvider>().authentication!.member;
    context.read<StatisticProvider>().getSummary(member.id);
    _loadList();
  }

  void _loadList() {
    final location = context.read<LocationProvider>().location!;
    final nostalgia = context.read<NostalgiaListProvider>();
    nostalgia
        .loadList(
            size: 30,
            condition: NostalgiaCondition.member,
            latitude: location.latitude,
            longitude: location.longitude)
        .then((_) {
      if (_recent30Items.isEmpty) {
        setState(() {
          _recent30Items = nostalgia.items;
        });
      }
    });
  }

  void _onTapEditButton() {}

  void _createNostalgia() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateNostalgiaScreen(),
        ));
  }

  void _onTapSettingButton() {}

  @override
  Widget build(BuildContext context) {
    final member =
        context.watch<AuthenticationProvider>().authentication!.member;

    final summary = context.watch<StatisticProvider>().summary;
    final items = context.watch<NostalgiaListProvider>().items;
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: ColorTheme.transparent,
        body: Stack(
          children: [
            BackgroundImage(opacity: 0),
            Positioned(
                bottom: 0,
                child: Container(
                  height: size.height * .45,
                  width: size.width,
                  color: Colors.black,
                )),
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  _loadList();
                }
                return false;
              },
              child: CustomScrollView(
                physics: RangeMaintainingScrollPhysics(),
                slivers: [
                  ProfileSummaryContainer(member: member, summary: summary),
                  SliverToBoxAdapter(
                    child: _recent30Items.isNotEmpty
                        ? ProfileMapView(items: _recent30Items)
                        : Container(),
                  ),
                  items.isNotEmpty
                      ? NostalgiaListGrid(items: items)
                      : SliverToBoxAdapter(
                          child: SizedBox(
                          height: size.height * .4,
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: _createNostalgia,
                                child: Center(
                                  child: IText(
                                    '추억이 비어있어요\n첫 추억을 남겨보세요!',
                                    weight: FontWeight.w100,
                                    align: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
                ],
              ),
            ),
            SafeArea(
                child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _onTapEditButton,
                    child: IText(
                      '편집',
                      color: Colors.white.withOpacity(0.8),
                      weight: FontWeight.w100,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: _createNostalgia,
                        child: Icon(
                          Icons.add_circle,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16),
                        child: InkWell(
                          onTap: _onTapSettingButton,
                          child: Icon(
                            Icons.settings,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ))
          ],
        ));
  }
}
