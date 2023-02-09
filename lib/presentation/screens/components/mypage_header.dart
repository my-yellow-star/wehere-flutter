import 'package:flutter/material.dart';
import 'package:wehere_client/domain/entities/authentication.dart';
import 'package:wehere_client/domain/entities/member.dart';

import '../../widgets/button.dart';
import '../../widgets/text.dart';

class MyPageHeader extends StatelessWidget {
  final Authentication auth;
  final Member? member;
  final bool editMode;
  final Function() onTapEditBackground;
  final Function() onTapEditCancel;
  final Function() onTapEditSave;
  final Function() createNostalgia;
  final Function() onTapSettingButton;

  const MyPageHeader(
      {super.key,
      required this.auth,
      required this.member,
      this.editMode = false,
      required this.onTapEditBackground,
      required this.onTapEditCancel,
      required this.onTapEditSave,
      required this.createNostalgia,
      required this.onTapSettingButton});

  @override
  Widget build(BuildContext context) {
    return auth.member.id == member?.id
        ? editMode
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: onTapEditBackground,
                    child: IText('배경 편집'),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: onTapEditCancel,
                        child: IText('취소'),
                      ),
                      Container(width: 12),
                      InkWell(
                        onTap: onTapEditSave,
                        child: IText('저장'),
                      ),
                    ],
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RoundButton(
                    icon: Icons.add_circle,
                    iconSize: 24,
                    color: Colors.white,
                    shadowOpacity: 0,
                    onPress: createNostalgia,
                  ),
                  RoundButton(
                    icon: Icons.settings,
                    iconSize: 24,
                    color: Colors.white,
                    shadowOpacity: 0,
                    onPress: onTapSettingButton,
                  )
                ],
              )
        : Container();
  }
}
