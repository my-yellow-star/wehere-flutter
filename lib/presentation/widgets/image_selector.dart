import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/providers/create_nostalgia_provider.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class ImageSelector extends StatefulWidget {
  const ImageSelector({super.key});

  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final List<XFile> files = [];
    final provider = context.read<CreateNostalgiaProvider>();
    if (source == ImageSource.camera) {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        files.add(image);
      }
    } else {
      final List<XFile> images = await _picker.pickMultiImage();
      files.addAll(images);
    }
    provider.addImages(files);
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
