import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';
import 'package:wehere_client/presentation/providers/statistic_provider.dart';
import 'package:wehere_client/presentation/widgets/background_image.dart';
import 'package:wehere_client/presentation/widgets/mixin.dart';
import 'package:wehere_client/presentation/widgets/nostalgia_list_grid.dart';
import 'package:wehere_client/presentation/widgets/profile_summary.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> with AfterLayoutMixin {
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
    context.read<NostalgiaListProvider>().loadList(
        size: 12,
        condition: NostalgiaCondition.member,
        latitude: location.latitude,
        longitude: location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final member =
        context.watch<AuthenticationProvider>().authentication!.member;

    final summary = context.watch<StatisticProvider>().summary;
    final items = context.watch<NostalgiaListProvider>().items;
    return Scaffold(
        backgroundColor: ColorTheme.transparent,
        body: Stack(
          children: [
            BackgroundImage(opacity: 0),
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollEndNotification) {
                  _loadList();
                }
                return false;
              },
              child: CustomScrollView(
                slivers: [
                  ProfileSummaryContainer(member: member, summary: summary),
                  NostalgiaListGrid(items: items),
                ],
              ),
            )
          ],
        ));
  }
}
