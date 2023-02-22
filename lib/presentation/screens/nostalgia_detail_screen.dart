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
import 'package:wehere_client/presentation/screens/widgets/detail/nostalgia_detail_meta.dart';
import 'package:wehere_client/presentation/components/report_manager.dart';
import 'package:wehere_client/presentation/screens/widgets/alert.dart';
import 'package:wehere_client/presentation/screens/widgets/back_button.dart';
import 'package:wehere_client/presentation/screens/widgets/bottom_sheet.dart';
import 'package:wehere_client/presentation/screens/widgets/button.dart';
import 'package:wehere_client/presentation/screens/widgets/gallery.dart';
import 'package:wehere_client/presentation/components/mixin.dart';
import 'package:wehere_client/presentation/screens/widgets/profile_image.dart';
import 'package:wehere_client/presentation/screens/widgets/detail/report_modal.dart';
import 'package:wehere_client/presentation/screens/widgets/text.dart';

import 'package:wehere_client/presentation/screens/widgets/not_found_view.dart';

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

  void _onTapReport() {
    showModalBottomSheet(
        context: context,
        builder: (_) => IBottomSheet(items: [
              BottomSheetItem(
                title: '게시글 신고',
                onPress: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => ReportModal(
                            nostalgia:
                                context.read<NostalgiaProvider>().nostalgia!,
                          ));
                },
              ),
              BottomSheetItem(
                  title: '게시글 차단',
                  onPress: _showBlacklistDialog,
                  color: Colors.red)
            ]));
  }

  void _onTapBookmark() {
    final provider = context.read<NostalgiaProvider>();
    if (provider.isBookmarked) {
      provider.cancelBookmark();
    } else {
      provider.bookmark();
    }
    context.read<RefreshPropagator>().propagate('nostalgia-bookmark');
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

  Future<void> _showBlacklistDialog() async {
    Alert.build(context,
        title: '게시글 차단',
        description: '해당 게시글을 차단하시겠어요?',
        showCancelButton: true,
        confirmCallback: _blacklist);
  }

  Future<void> _blacklist() async {
    ReportManager.blacklistNostalgia(
        nostalgiaId: context.read<NostalgiaProvider>().nostalgia!.id,
        successCallback: () {
          if (mounted) {
            context.read<RefreshPropagator>().propagate('nostalgia-list');
            Navigator.pop(context);
          }
          Alert.build(context,
              title: '게시글 차단 완료', description: '해당 게시글 차단을 완료했어요');
        },
        failedCallback: () {
          Alert.build(context,
              title: '게시글 차단 실패', description: '문제가 발생했어요. 잠시 후 다시 시도해주세요.');
        });
  }

  void _addMarker() async {
    final item = context.read<NostalgiaProvider>().nostalgia;
    final byte = ImageUtil.resizeImage(
        (await rootBundle.load(item!.markerColor.filename))
            .buffer
            .asUint8List(),
        MarkerSize.normal['width'],
        MarkerSize.normal['height']);

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
                                    : Row(
                                        children: [
                                          RoundButton(
                                            icon: Icons.report_problem_outlined,
                                            color: Colors.red,
                                            onPress: _onTapReport,
                                          ),
                                          Container(
                                              width: PaddingHorizontal.normal),
                                          RoundButton(
                                            icon: provider.isBookmarked
                                                ? Icons.bookmark
                                                : Icons.bookmark_border,
                                            color: Colors.white,
                                            onPress: _onTapBookmark,
                                          )
                                        ],
                                      )
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
                                        item.createdAt.parseDate(),
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
                                        maxLines: 1000,
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
                                    NostalgiaDetailMeta(item: item),
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
