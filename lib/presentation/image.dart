class IImageSource {
  final String path;
  final ImageType type;

  IImageSource(this.path, this.type);
}

enum ImageType { network, file }
