import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/presentation/providers/nostalgia_editor_provider.dart';
import 'package:wehere_client/presentation/widgets/image_selector.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<NostalgiaEditorProvider>();
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) => ImageSelector(
                  canSelectMultipleImage: true,
                  onImageSelected: (images) {
                    provider.addImages(images);
                  },
                ));
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(40)),
        child: Icon(Icons.photo, size: 24, color: Colors.white),
      ),
    );
  }
}
