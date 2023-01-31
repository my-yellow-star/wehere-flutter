import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wehere_client/presentation/widgets/mixin.dart';

class MarkerGenerator {
  final Function(List<Uint8List>) callback;
  final List<Widget> markerWidgets;

  MarkerGenerator(this.markerWidgets, this.callback);

  void generate(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterFirstLayout(context));
  }

  void afterFirstLayout(BuildContext context) {
    addOverlay(context);
  }

  void addOverlay(BuildContext context) {
    OverlayState overlayState = Overlay.of(context);

    OverlayEntry entry = OverlayEntry(
        builder: (context) {
          return _MarkerHelper(
            markerWidgets: markerWidgets,
            callback: callback,
          );
        },
        maintainState: true);

    overlayState.insert(entry);
  }
}

class _MarkerHelper extends StatefulWidget {
  final List<Widget> markerWidgets;
  final Function(List<Uint8List>) callback;

  const _MarkerHelper({required this.markerWidgets, required this.callback});

  @override
  _MarkerHelperState createState() => _MarkerHelperState();
}

class _MarkerHelperState extends State<_MarkerHelper> with AfterLayoutMixin {
  List<GlobalKey> globalKeys = <GlobalKey>[];

  @override
  void afterFirstLayout(BuildContext context) {
    _getBitmaps(context).then((list) {
      widget.callback(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(MediaQuery.of(context).size.width, 0),
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: widget.markerWidgets.map((widget) {
            final markerKey = GlobalKey();
            globalKeys.add(markerKey);
            return RepaintBoundary(
              key: markerKey,
              child: widget,
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<List<Uint8List>> _getBitmaps(BuildContext context) async {
    final futures = globalKeys.map((key) => _getUInt8List(key));
    return Future.wait(futures);
  }

  Future<Uint8List> _getUInt8List(GlobalKey markerKey) async {
    final context = markerKey.currentContext!;
    RenderRepaintBoundary boundary =
        context.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2.0);
    ByteData byteData = (await image.toByteData(format: ImageByteFormat.png))!;
    return byteData.buffer.asUint8List();
  }
}
