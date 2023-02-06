import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/extensions.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/presentation/image.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_provider.dart';
import 'package:wehere_client/presentation/widgets/alert.dart';
import 'package:wehere_client/presentation/widgets/back_button.dart';
import 'package:wehere_client/presentation/widgets/bottom_sheet.dart';
import 'package:wehere_client/presentation/widgets/button.dart';
import 'package:wehere_client/presentation/widgets/gallery.dart';
import 'package:wehere_client/presentation/widgets/mixin.dart';
import 'package:wehere_client/presentation/widgets/profile_image.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

import 'package:wehere_client/presentation/widgets/not_found_view.dart';

class NostalgiaDetailScreen extends StatefulWidget {
  const NostalgiaDetailScreen({super.key});

  @override
  _NostalgiaDetailScreenState createState() => _NostalgiaDetailScreenState();
}

class _NostalgiaDetailScreenState extends State<NostalgiaDetailScreen>
    with AfterLayoutMixin {
  static const textColor = ColorTheme.primary;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    context.read<NostalgiaProvider>().initialize();
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    final itemId = ModalRoute.of(context)!.settings.arguments as String;
    context
        .read<NostalgiaProvider>()
        .loadItem(itemId, context.read<LocationProvider>().location!);
  }

  void _onTapProfile() {}

  void _onTapSetting() {
    final provider = context.read<NostalgiaProvider>();
    final nostalgia = provider.nostalgia!;
    showModalBottomSheet(
        context: context,
        builder: (_) => IBottomSheet(items: [
              BottomSheetItem(
                title: '수정',
                onPress: () {
                  Navigator.pushNamed(context, 'nostalgia-editor',
                      arguments: nostalgia.id);
                },
              ),
              BottomSheetItem(
                  title: '삭제', onPress: _showDeleteDialog, color: Colors.red)
            ]));
  }

  Future<void> _showDeleteDialog() async {
    Alert.build(context,
        title: '정말 삭제하시겠습니까?',
        description: '지워진 추억은 돌아오지 않아요',
        showCancelButton: true,
        confirmCallback: _delete);
  }

  Future<void> _delete() async {
    final provider = context.read<NostalgiaProvider>();
    await provider.delete();
    if (mounted) Navigator.pop(context);
  }

  Widget _mapView(Location location) {
    final position = LatLng(location.latitude, location.longitude);
    return GoogleMap(
      onMapCreated: (controller) {
        if (_controller.isCompleted) return;
        _controller.complete(controller);
      },
      myLocationButtonEnabled: false,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
      },
      initialCameraPosition: CameraPosition(
          target: LatLng(location.latitude, location.longitude), zoom: 10),
      markers: {Marker(markerId: MarkerId('item'), position: position)},
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NostalgiaProvider>();
    final item = provider.nostalgia;
    final size = MediaQuery.of(context).size;
    final isMine =
        context.read<AuthenticationProvider>().authentication?.member.id ==
            item?.member.id;

    if (provider.error?.isNotFound == true) {
      return NotFoundView();
    }

    return Scaffold(
        body: provider.isLoading
            ? Center(child: CircularProgressIndicator())
            : item != null
                ? NestedScrollView(
                    physics: RangeMaintainingScrollPhysics(),
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                            automaticallyImplyLeading: false,
                            backgroundColor: ColorTheme.primary,
                            expandedHeight: size.height * .3 - kToolbarHeight,
                            floating: false,
                            pinned: true,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RoundBackButton(),
                                isMine
                                    ? RoundButton(
                                        icon: Icons.settings,
                                        onPress: _onTapSetting,
                                      )
                                    : Container()
                              ],
                            ),
                            flexibleSpace: FlexibleSpaceBar(
                              background: item.images.isNotEmpty
                                  ? Gallery(
                                      height: size.height * .3,
                                      width: size.width,
                                      images: item.images
                                          .map((url) => IImageSource(
                                              url, ImageType.network))
                                          .toList())
                                  : Image.asset(
                                      Constant.defaultImageAsset,
                                      height: size.height * .3,
                                      width: size.width,
                                      fit: BoxFit.cover,
                                    ),
                            )),
                      ];
                    },
                    body: SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: _onTapProfile,
                                child: SizedBox(
                                  height: kToolbarHeight,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          ProfileImage(
                                              size: 18,
                                              url: item.member.profileImageUrl),
                                          Container(width: 8),
                                          IText(
                                            item.member.nickname,
                                            color: textColor.withOpacity(0.8),
                                            size: FontSize.small,
                                            weight: FontWeight.bold,
                                          )
                                        ],
                                      ),
                                      IText(
                                        item.createdAt.parseString(),
                                        color: textColor.withOpacity(0.5),
                                        size: FontSize.small,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              IText(
                                item.title,
                                color: textColor,
                                weight: FontWeight.bold,
                              ),
                              item.description.isNotEmpty
                                  ? Container(
                                      padding: EdgeInsets.only(top: 8),
                                      child: IText(
                                        item.description,
                                        color: textColor,
                                        weight: FontWeight.w200,
                                        maxLines: 20,
                                      ),
                                    )
                                  : Container(),
                              Container(
                                padding: EdgeInsets.only(top: 24, bottom: 24),
                                height: size.height * .3,
                                child: _mapView(item.location),
                              ),
                            ],
                          )),
                    ),
                  )
                : Container());
  }
}
