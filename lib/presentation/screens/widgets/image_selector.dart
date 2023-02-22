import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/components/image.dart';
import 'package:wehere_client/presentation/screens/widgets/text.dart';

class ImageSelector extends StatefulWidget {
  final Function(List<IImageSource>) onImageSelected;
  final bool canSelectMultipleImage;

  const ImageSelector(
      {super.key,
      required this.onImageSelected,
      this.canSelectMultipleImage = true});

  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final List<XFile> files = [];
    if (source == ImageSource.camera) {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        files.add(image);
      }
    } else {
      if (widget.canSelectMultipleImage) {
        files.addAll(await _picker.pickMultiImage());
      } else {
        final image = await _picker.pickImage(source: source);
        if (image != null) files.add(image);
      }
    }
    widget.onImageSelected(
        files.map((e) => IImageSource(e.path, ImageType.file)).toList());
  }

  List<Widget> _items() {
    return [
      InkWell(
        onTap: () {
          Navigator.pop(context);
          _pickImage(ImageSource.camera);
        },
        child: Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: IText('사진 촬영', color: ColorTheme.primary),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.pop(context);
          _pickImage(ImageSource.gallery);
        },
        child: Container(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: IText('이미지 업로드', color: ColorTheme.primary),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * .3,
      padding: EdgeInsets.all(16),
      child: Column(
        children: _items(),
      ),
    );
  }
}
