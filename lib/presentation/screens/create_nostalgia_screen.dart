import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/providers/location_provider.dart';
import 'package:wehere_client/presentation/providers/create_nostalgia_provider.dart';
import 'package:wehere_client/presentation/widgets/alert.dart';
import 'package:wehere_client/presentation/widgets/back_button.dart';
import 'package:wehere_client/presentation/widgets/gallery.dart';
import 'package:wehere_client/presentation/widgets/text.dart';
import 'package:wehere_client/presentation/widgets/upload_button.dart';
import 'package:wehere_client/presentation/widgets/visibility_dropdown.dart';

class CreateNostalgiaScreen extends StatefulWidget {
  const CreateNostalgiaScreen({super.key});

  @override
  _CreateNostalgiaScreenState createState() => _CreateNostalgiaScreenState();
}

class _CreateNostalgiaScreenState extends State<CreateNostalgiaScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();

  static final _titleKey =
      GlobalKey<EditableTextState>(debugLabel: 'title key');

  static final _descriptionKey =
      GlobalKey<EditableTextState>(debugLabel: 'description key');

  @override
  void initState() {
    final provider = context.read<CreateNostalgiaProvider>();
    _titleController.text = provider.title;
    _descriptionController.text = provider.description;
    super.initState();
  }

  Future<void> _create() async {
    final nostalgia = context.read<CreateNostalgiaProvider>();
    if (nostalgia.title.isEmpty) {
      Alert.build(context, title: '필수 항목을 입력해주세요', description: '제목을 입력해주세요');
      return;
    }
    await nostalgia.create(context.read<LocationProvider>().location!);
    if (nostalgia.id != null) {
      nostalgia.initialize();
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final nostalgia = context.watch<CreateNostalgiaProvider>();
    if (nostalgia.error != null) {
      Alert.build(context,
          title: '오류', description: '오류가 발생했어요. 잠시 후 다시 시도해주세요.');
    }
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    nostalgia.images.isNotEmpty
                        ? Gallery(
                            height: size.height * .3,
                            width: size.width,
                            images: nostalgia.images
                                .map((e) => File(e.path))
                                .toList(),
                            onDeleteItem: nostalgia.deleteImage,
                          )
                        : Container(
                            height: size.height * .3,
                            width: size.width,
                            color: Colors.black,
                            child: Center(
                                child: IText('그곳의 사진을 올려보세요',
                                    weight: FontWeight.w100)),
                          ),
                    Positioned(bottom: 16, right: 16, child: UploadButton()),
                    SafeArea(
                        child: Container(
                            margin: EdgeInsets.only(top: 16, left: 16),
                            child: RoundBackButton()))
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              VisibilityDropdown(
                                  selectedVisibility: nostalgia.visibility)
                            ],
                          ),
                          TextField(
                            autofocus: true,
                            key: _titleKey,
                            controller: _titleController,
                            onChanged: nostalgia.updateTitle,
                            style: TextStyle(
                                color: ColorTheme.primary,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                                hintText: '네가 있던 그곳',
                                hintStyle: TextStyle(
                                    color: ColorTheme.primary.withOpacity(0.2),
                                    fontWeight: FontWeight.bold),
                                border: InputBorder.none),
                            onSubmitted: (_) {
                              _descriptionFocusNode.requestFocus();
                            },
                          ),
                          TextField(
                            focusNode: _descriptionFocusNode,
                            key: _descriptionKey,
                            controller: _descriptionController,
                            onChanged: nostalgia.updateDescription,
                            style: TextStyle(
                                color: ColorTheme.primary,
                                fontWeight: FontWeight.w200),
                            decoration: InputDecoration(
                                hintText: '지나고 보니 추억이었다',
                                hintStyle: TextStyle(
                                    color: ColorTheme.primary.withOpacity(0.2),
                                    fontWeight: FontWeight.w200),
                                border: InputBorder.none),
                            maxLines: null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black,
                  height: 100,
                  child: SafeArea(
                    top: false,
                    child: InkWell(
                      onTap: _create,
                      child: Center(
                          child: IText(
                        '업로드',
                        weight: FontWeight.bold,
                      )),
                    ),
                  ),
                )
              ],
            ),
            nostalgia.isLoading
                ? Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.black.withOpacity(0.2),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
