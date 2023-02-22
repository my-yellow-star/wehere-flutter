import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:wehere_client/presentation/components/image.dart';
import 'package:wehere_client/presentation/screens/widgets/back_button.dart';
import 'package:wehere_client/presentation/screens/widgets/button.dart';
import 'package:wehere_client/presentation/screens/widgets/text.dart';

class Gallery extends StatefulWidget {
  final List<IImageSource> images;
  final double height;
  final double? width;
  final Function(int)? onDeleteItem;

  const Gallery({
    super.key,
    required this.images,
    required this.height,
    this.width,
    this.onDeleteItem,
  });

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  int _itemIndex = 0;

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: widget.images,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
          onDeleteItem: widget.onDeleteItem,
        ),
      ),
    );
  }

  Widget _resolveImage(IImageSource image) {
    switch (image.type) {
      case ImageType.network:
        return CachedNetworkImage(
          imageUrl: image.path,
          fit: BoxFit.cover,
        );
      case ImageType.file:
        return Image.file(
          File(image.path),
          fit: BoxFit.cover,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: PageView.builder(
            onPageChanged: (value) {
              setState(() {
                _itemIndex = value;
              });
            },
            itemBuilder: (context, index) => InkWell(
                onTap: () {
                  open(context, index);
                },
                child: _resolveImage(widget.images[index])),
            itemCount: widget.images.length,
          ),
        ),
        Positioned(
            bottom: 16,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IText(
                  '${_itemIndex + 1} / ${widget.images.length}',
                  shadows: const [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ],
            ))
      ],
    );
  }
}

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    super.key,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
    this.onDeleteItem,
  }) : pageController = PageController(initialPage: initialIndex);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<IImageSource> galleryItems;
  final Axis scrollDirection;
  final Function(int)? onDeleteItem;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: widget.backgroundDecoration,
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.galleryItems.length,
              loadingBuilder: widget.loadingBuilder,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
          ),
          SafeArea(
              child: Container(
                  margin: EdgeInsets.only(left: 16, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RoundBackButton(),
                      widget.onDeleteItem != null
                          ? RoundButton(
                              icon: Icons.delete_rounded,
                              color: Colors.red,
                              iconSize: 22,
                              onPress: () {
                                widget.onDeleteItem!(currentIndex);
                                Navigator.pop(context);
                              },
                            )
                          : Container()
                    ],
                  ))),
        ],
      ),
    );
  }

  ImageProvider _resolveImageProvider(IImageSource image) {
    switch (image.type) {
      case ImageType.network:
        return CachedNetworkImageProvider(image.path);
      case ImageType.file:
        return FileImage(File(image.path));
    }
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      imageProvider: _resolveImageProvider(widget.galleryItems[index]),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: index.toString()),
    );
  }
}
