import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/extensions.dart';
import 'package:wehere_client/core/params/nostalgia_visibility.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/presentation/image.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_provider.dart';
import 'package:wehere_client/presentation/providers/refresh_propagator.dart';
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
  final Set<Marker> _marker = {};

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
        .loadItem(itemId, context.read<LocationProvider>().location!)
        .then((_) {
      _addMarker();
    });
  }

  void _onTapProfile(String memberId) {
    if (context.read<AuthenticationProvider>().authentication?.member.id ==
        memberId) {
      return;
    }
    Navigator.pushNamed(context, 'my-page', arguments: memberId);
  }

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
    if (mounted) {
      context.read<RefreshPropagator>().propagate('nostalgia-list');
      Navigator.pop(context);
    }
  }

  void _addMarker() async {
    final item = context.read<NostalgiaProvider>().nostalgia;
    final byte = ImageUtil.resizeImage(
        (await rootBundle.load(item!.markerColor.filename))
            .buffer
            .asUint8List(),
        MarkerSize.large['width'],
        MarkerSize.large['height']);

    final icon = BitmapDescriptor.fromBytes(byte!);
    setState(() {
      _marker.add(Marker(
          markerId: MarkerId(item.id),
          position: LatLng(item.location.latitude, item.location.longitude),
          icon: icon));
    });
  }

  Widget _mapView(Location location) {
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
      markers: _marker,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NostalgiaProvider>();
    final item = provider.nostalgia;
    final size = MediaQuery.of(context).size;
    final imageHeight = size.height * .4;
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
                            expandedHeight: imageHeight - kToolbarHeight,
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
                                      height: imageHeight,
                                      width: size.width,
                                      images: item.images
                                          .map((url) => IImageSource(
                                              url, ImageType.network))
                                          .toList())
                                  : Image.asset(
                                      Constant.defaultImageAsset,
                                      height: imageHeight,
                                      width: size.width,
                                      fit: BoxFit.cover,
                                    ),
                            )),
                      ];
                    },
                    body: SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.only(
                            left: PaddingHorizontal.normal,
                            right: PaddingHorizontal.normal,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  _onTapProfile(item.member.id);
                                },
                                child: SizedBox(
                                  height: kToolbarHeight,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          ProfileImage(
                                              size: ProfileSize.small,
                                              url: item.member.profileImageUrl),
                                          Container(
                                              width: PaddingHorizontal.small),
                                          IText(
                                            item.member.nickname,
                                            color: textColor.withOpacity(0.8),
                                            size: FontSize.small,
                                            weight: FontWeight.bold,
                                          ),
                                          Container(
                                              width: PaddingHorizontal.small),
                                          item.visibility !=
                                                  NostalgiaVisibility.all
                                              ? Icon(
                                                  Icons.lock_outline,
                                                  color: Colors.grey,
                                                  size: IconSize.small,
                                                )
                                              : Container(
                                                  height: 0,
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
                                      padding: EdgeInsets.only(
                                          top: PaddingVertical.small),
                                      child: IText(
                                        item.description,
                                        color: textColor,
                                        weight: FontWeight.w200,
                                        maxLines: 20,
                                      ),
                                    )
                                  : Container(),
                              Container(
                                padding: EdgeInsets.only(
                                  top: PaddingVertical.big,
                                  bottom: PaddingVertical.big,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.my_location_rounded,
                                          size: IconSize.small,
                                          color: Colors.grey,
                                        ),
                                        Container(
                                            width: PaddingHorizontal.tiny),
                                        IText(
                                          item.address,
                                          color: Colors.grey,
                                          size: FontSize.small,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: PaddingVertical.tiny,
                                    ),
                                    SizedBox(
                                        height: size.height * .3,
                                        child: _mapView(item.location)),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                  )
                : Container());
  }
}
