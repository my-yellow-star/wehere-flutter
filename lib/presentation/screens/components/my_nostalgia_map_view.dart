import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/params/get_nostalgia.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/location.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/my_nostalgia_map_provider.dart';
import 'package:wehere_client/presentation/providers/statistic_provider.dart';
import 'package:wehere_client/presentation/widgets/mixin.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class MyNostalgiaMapView extends StatefulWidget {
  final Member member;
  final bool scrollEnabled;

  const MyNostalgiaMapView(
      {super.key, required this.member, required this.scrollEnabled});

  @override
  State<MyNostalgiaMapView> createState() => _MyNostalgiaMapViewState();
}

class _MyNostalgiaMapViewState extends State<MyNostalgiaMapView>
    with AfterLayoutMixin {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  late Location _location;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    context.read<MyNostalgiaMapProvider>().initialize();
    context.read<StatisticProvider>().initialize();
    _location = context.read<LocationProvider>().location!;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    context.read<StatisticProvider>().getSummary(widget.member.id);
    _loadList();
  }

  void _loadList() {
    final nostalgia = context.read<MyNostalgiaMapProvider>();
    nostalgia
        .loadList(
            size: 30,
            latitude: _location.latitude,
            longitude: _location.longitude,
            memberId: widget.member.id,
            condition: NostalgiaCondition.member)
        .then((_) {
      _addMarkers(nostalgia.items);
    });
  }

  CameraPosition _initialCameraPosition() {
    final location = context.read<LocationProvider>().location!;
    return CameraPosition(target: _toLatLng(location), zoom: 4);
  }

  LatLng _toLatLng(Location location) =>
      LatLng(location.latitude, location.longitude);

  void _addMarkers(List<NostalgiaSummary> items) async {
    final icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), Constant.defaultMarker24);
    final markers = items.map((item) => Marker(
          consumeTapEvents: true,
          markerId: MarkerId(item.id),
          position: _toLatLng(item.location),
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'nostalgia-detail',
                      arguments: item.id);
                },
                child: Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          opacity: 0.5,
                          image: (item.thumbnail != null
                              ? CachedNetworkImageProvider(item.thumbnail!)
                              : AssetImage(Constant.defaultImageAsset)
                                  as ImageProvider))),
                  child: Center(
                    child: IText(
                      item.title,
                      weight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
              _toLatLng(item.location),
            );
          },
          icon: icon,
        ));
    setState(() {
      _markers.addAll(markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    final statistic = context.watch<StatisticProvider>().summary;
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    IText(
                      '추억',
                      size: FontSize.small,
                    ),
                    Container(width: 4),
                    IText(
                      '${statistic?.totalCount ?? 0}',
                      weight: FontWeight.bold,
                    )
                  ],
                ),
                Row(
                  children: [
                    IText(
                      '여행',
                      size: FontSize.small,
                    ),
                    Container(width: 4),
                    IText(
                      ((statistic?.accumulatedDistance ?? 0) / 1000)
                          .round()
                          .toString(),
                      weight: FontWeight.bold,
                    ),
                    IText(
                      'km',
                      size: FontSize.small,
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: size.height * .5,
            child: Stack(
              children: [
                GoogleMap(
                    onCameraMove: (position) {
                      _customInfoWindowController.hideInfoWindow!();
                      setState(() {
                        _location = Location(position.target.latitude,
                            position.target.longitude);
                      });
                    },
                    onTap: (position) {
                      _customInfoWindowController.hideInfoWindow!();
                    },
                    markers: _markers,
                    onCameraIdle: () {
                      _loadList();
                    },
                    gestureRecognizers: widget.scrollEnabled
                        ? <Factory<OneSequenceGestureRecognizer>>{
                            Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer())
                          }
                        : {},
                    myLocationButtonEnabled: false,
                    onMapCreated: (controller) {
                      _customInfoWindowController.googleMapController =
                          controller;
                      if (!_controller.isCompleted) {
                        _controller.complete(controller);
                      }
                    },
                    initialCameraPosition: _initialCameraPosition()),
                CustomInfoWindow(
                  controller: _customInfoWindowController,
                  height: size.height * .1,
                  width: size.width * .5,
                  offset: 30,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
