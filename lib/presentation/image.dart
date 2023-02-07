import 'package:flutter/services.dart';
import 'package:image/image.dart' as image;

class IImageSource {
  final String path;
  final ImageType type;

  IImageSource(this.path, this.type);
}

enum ImageType { network, file }

class ImageUtil {
  static Future<Uint8List> toBytes(String url) async {
    return (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();
  }

  static Uint8List? resizeImage(Uint8List data, width, height) {
    Uint8List? resizedData = data;
    image.Image? img = image.decodeImage(data);
    image.Image resized = image.copyResize(img!, width: width, height: height);
    resizedData = Uint8List.fromList(image.encodePng(resized));
    return resizedData;
  }
}
