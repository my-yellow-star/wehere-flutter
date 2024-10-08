import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/components/image.dart';
import 'package:wehere_client/presentation/providers/member_provider.dart';
import 'package:wehere_client/presentation/screens/widgets/button.dart';
import 'package:wehere_client/presentation/screens/widgets/image_selector.dart';
import 'package:wehere_client/presentation/screens/widgets/profile_image.dart';

class ProfileBackground extends StatefulWidget {
  final bool editMode;

  const ProfileBackground({super.key, required this.editMode});

  @override
  State<ProfileBackground> createState() => _ProfileBackgroundState();
}

class _ProfileBackgroundState extends State<ProfileBackground> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _nicknameKey = GlobalKey<EditableTextState>(
      debugLabel: 'nickname key - ${DateTime.now().millisecondsSinceEpoch}');

  final _descriptionKey = GlobalKey<EditableTextState>(
      debugLabel: 'description key - ${DateTime.now().millisecondsSinceEpoch}');

  ImageProvider _backgroundImage(IImageSource? image) {
    if (image == null) {
      return AssetImage(Constant.defaultImageAsset);
    }

    if (image.type == ImageType.network) {
      return CachedNetworkImageProvider(image.path);
    } else {
      return FileImage(File(image.path));
    }
  }

  void _onTapEditProfileImage() {
    final provider = context.read<MemberProvider>();
    showModalBottomSheet(
        context: context,
        builder: (_) => ImageSelector(
              canSelectMultipleImage: false,
              onImageSelected: (images) {
                provider.updateProfileImage(images[0]);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MemberProvider>();
    final member = provider.member;
    final size = MediaQuery.of(context).size;

    if (!widget.editMode) {
      _nicknameController.text = provider.nickname;
      _descriptionController.text = provider.description ?? '';
    }

    if (_nicknameController.text.isEmpty) {
      _nicknameController.text = provider.nickname;
    }

    if (_descriptionController.text.isEmpty) {
      _descriptionController.text = provider.description ?? '';
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        height: size.height * .5,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: _backgroundImage(provider.backgroundImage),
                fit: BoxFit.cover,
                opacity: 0.5)),
        child: Container(
          padding: EdgeInsets.only(
            top: size.height * .13,
            left: PaddingVertical.normal,
            right: PaddingVertical.normal,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  widget.editMode
                      ? Stack(
                          children: [
                            ProfileImage(
                              size: ProfileSize.title,
                              url: provider.profileImage?.path,
                              type: provider.profileImage?.type ??
                                  ImageType.network,
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    _onTapEditProfileImage();
                                  },
                                  child: RoundButton(
                                    icon: Icons.create,
                                    backgroundOpacity: 1,
                                  ),
                                ))
                          ],
                        )
                      : ProfileImage(
                          size: ProfileSize.title,
                          url: member?.profileImageUrl),
                  Container(height: PaddingVertical.normal),
                  SizedBox(
                    width: size.width * .5,
                    child: TextField(
                      textAlign: TextAlign.center,
                      key: _nicknameKey,
                      maxLength: 12,
                      controller: _nicknameController,
                      onChanged: provider.updateNickname,
                      decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          contentPadding: EdgeInsets.all(4.h)),
                      enabled: widget.editMode,
                      style: TextStyle(
                          fontSize: FontSize.regular,
                          color: Colors.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                    left: PaddingHorizontal.normal,
                    right: PaddingHorizontal.normal),
                child: TextField(
                  textAlign: TextAlign.center,
                  key: _descriptionKey,
                  controller: _descriptionController,
                  onChanged: provider.updateDescription,
                  decoration: InputDecoration(
                      filled: widget.editMode,
                      fillColor: Colors.grey.withOpacity(0.3),
                      isDense: true,
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      contentPadding: EdgeInsets.all(4.h)),
                  enabled: widget.editMode,
                  maxLength: 80,
                  maxLines: 3,
                  style: TextStyle(
                      fontFamilyFallback: Constant.fontFamilyCallback,
                      fontSize: FontSize.regular,
                      color: Colors.white,
                      fontWeight: FontWeight.w100),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
