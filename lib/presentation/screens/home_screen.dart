import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/injector.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';
import 'package:wehere_client/presentation/widgets/nostalgia_summary_card.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Future.microtask(() {
      final locationProvider = context.read<LocationProvider>();
      locationProvider.getLocation();
    });
    super.initState();
  }

  ChangeNotifierProvider<NostalgiaListProvider> _nostalgiaListContainer(
      NostalgiaCondition condition) {
    return ChangeNotifierProvider<NostalgiaListProvider>(
        create: (_) => injector<NostalgiaListProvider>(),
        child:
            Consumer<NostalgiaListProvider>(builder: (context, value, child) {
          if (!value.end && value.items.isEmpty) {
            value.loadList(
              condition: condition,
              latitude: context.read<LocationProvider>().location?.latitude,
              longitude: context.read<LocationProvider>().location?.longitude,
            );
          }
          if (value.isLoading) {
            return CircularProgressIndicator();
          }
          return SizedBox(
            height: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: value.items.length,
                itemBuilder: (context, index) {
                  final item = value.items.elementAt(index);
                  return NostalgiaSummaryCard(item: item);
                }),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorTheme.primary,
        appBar: AppBar(
          backgroundColor: ColorTheme.primary,
          elevation: 0,
          title: Align(
              alignment: Alignment.topLeft,
              child: Image.asset('${Constant.image}/banner.png', width: 160)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 24),
                child: IText(
                  '실시간',
                )),
            _nostalgiaListContainer(NostalgiaCondition.recent),
            Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 24),
                child: IText(
                  '내주변',
                )),
            _nostalgiaListContainer(NostalgiaCondition.around)
          ],
        ));
  }
}
