import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wehere_client/domain/entities/nostalgia_summary.dart';
import 'package:wehere_client/presentation/components/image.dart';
import 'package:wehere_client/presentation/components/clustered_place.dart';
import 'package:wehere_client/presentation/components/marker_icon_provider.dart';

class MarkerBuilder {
  static Future<Marker> build(
      {required Cluster<ClusteredPlace> cluster,
      Function(NostalgiaSummary item)? onTapSingle,
      Function(List<NostalgiaSummary> items)? onTapMultiple}) async {
    final item = cluster.items.first.item;
    return Marker(
        consumeTapEvents: true,
        markerId: MarkerId(cluster.getId()),
        onTap: () {
          cluster.isMultiple
              ? onTapMultiple?.call(cluster.items.map((e) => e.item).toList())
              : onTapSingle?.call(item);
        },
        position: cluster.location,
        icon: cluster.isMultiple
            ? await _getMultipleMarkerBitmap(150,
                text: cluster.count.toString())
            : (await MarkerIconProvider.getIcons(
                size: MarkerIconSize.large))[item.markerColor.value]!);
  }

  static Future<BitmapDescriptor> _getMultipleMarkerBitmap(int size,
      {String? text}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    canvas.drawImage(await loadUiImage('asset/image/circle-rainbow.png', size),
        Offset(0, 0), Paint());

    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data =
        await img.toByteData(format: ui.ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  static Future<ui.Image> loadUiImage(String assetPath, int size) async {
    final data = ImageUtil.resizeImage(
        (await rootBundle.load(assetPath)).buffer.asUint8List(), size, size);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(data!, completer.complete);
    return completer.future;
  }
}
