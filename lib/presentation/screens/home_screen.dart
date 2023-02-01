import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/extensions.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_list_provider.dart';
import 'package:wehere_client/presentation/screens/create_nostalgia_screen.dart';
import 'package:wehere_client/presentation/widgets/background_image.dart';
import 'package:wehere_client/presentation/widgets/nostalgia_summary_card.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static const double _foregroundPageViewportFraction = 0.8;
  final PageController _backgroundPageController = PageController();
  final PageController _foregroundPageController =
      PageController(viewportFraction: _foregroundPageViewportFraction);
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<NostalgiaListProvider>().initialize();
    _loadItems();
  }

  void _loadItems() {
    final locationProvider = context.read<LocationProvider>();
    context.read<NostalgiaListProvider>().loadList(
          condition: NostalgiaCondition.recent,
          latitude: locationProvider.location?.latitude,
          longitude: locationProvider.location?.longitude,
        );
  }

  @override
  void dispose() {
    _backgroundPageController.dispose();
    _foregroundPageController.dispose();
    super.dispose();
  }

  void _createNostalgia() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateNostalgiaScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final nostalgia = context.watch<NostalgiaListProvider>();
    if (nostalgia.isLoading) {
      return Stack(
        children: const [
          BackgroundImage(),
          Center(child: CircularProgressIndicator())
        ],
      );
    }
    final items = context.watch<NostalgiaListProvider>().items;
    final item = items[_selectedIndex];
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: items.length,
            controller: _backgroundPageController,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Image.network(
                  item.thumbnail!,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          Positioned.fill(
            bottom: size.height * .05,
            child: Visibility(
              visible: true,
              maintainState: true,
              child: PageView.builder(
                itemCount: items.length,
                controller: _foregroundPageController,
                onPageChanged: (i) {
                  setState(() => _selectedIndex = i);
                  if (i == items.length - 1) {
                    _loadItems();
                  }
                },
                itemBuilder: (context, index) {
                  return NostalgiaSummaryCard(item: items[index]);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: UnconstrainedBox(
              child: Container(
                width: size.width,
                height: size.height * .2,
                color: Colors.black.withOpacity(0.5),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IText(item.title, weight: FontWeight.bold),
                        Container(height: 8),
                        IText(
                          item.description,
                          maxLines: 3,
                          weight: FontWeight.w100,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.place_outlined,
                                color: Colors.white, size: 16),
                            Container(width: 2),
                            IText(
                              item.distance?.parseDistance() ?? '???',
                              size: FontSize.small,
                            )
                          ],
                        ),
                        IText(
                          item.createdAt.parseDate(),
                          size: FontSize.small,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
              child: Container(
                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IText(
                        '실시간',
                        weight: FontWeight.w100,
                        shadows: const [
                          Shadow(blurRadius: 2, color: Colors.black)
                        ],
                      ),
                      InkWell(
                        onTap: _createNostalgia,
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          weight: 0.5,
                          shadows: const [
                            Shadow(blurRadius: 2, color: Colors.black)
                          ],
                        ),
                      )
                    ],
                  )))
        ],
      ),
    );
  }
}
