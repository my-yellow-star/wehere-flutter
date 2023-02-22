import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/authentication.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/presentation/providers/refresh_propagator.dart';
import 'package:wehere_client/presentation/components/report_manager.dart';
import 'package:wehere_client/presentation/screens/widgets/alert.dart';
import 'package:wehere_client/presentation/screens/widgets/back_button.dart';
import 'package:wehere_client/presentation/screens/widgets/bottom_sheet.dart';
import 'package:wehere_client/presentation/screens/widgets/detail/report_modal.dart';

import 'package:wehere_client/presentation/screens/widgets/button.dart';
import 'package:wehere_client/presentation/screens/widgets/text.dart';

class MyPageHeader extends StatefulWidget {
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
  State<MyPageHeader> createState() => _MyPageHeaderState();
}

class _MyPageHeaderState extends State<MyPageHeader> {
  void _onTapReport() {
    showModalBottomSheet(
        context: context,
        builder: (_) => widget.member?.blocked ?? false
            ? IBottomSheet(items: [
                BottomSheetItem(
                  title: '차단 해제',
                  onPress: _showCancelBlacklistDialog,
                )
              ])
            : IBottomSheet(items: [
                BottomSheetItem(
                  title: '사용자 신고',
                  onPress: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => ReportModal(
                              member: widget.member,
                              reportMember: true,
                            ));
                  },
                ),
                BottomSheetItem(
                    title: '사용자 차단',
                    onPress: _showBlacklistDialog,
                    color: Colors.red)
              ]));
  }

  Future<void> _showBlacklistDialog() async {
    Alert.build(context,
        title: '사용자 차단',
        description: '해당 사용자를 차단하시겠어요?',
        showCancelButton: true,
        confirmCallback: _blacklist);
  }

  Future<void> _showCancelBlacklistDialog() async {
    Alert.build(context,
        title: '사용자 차단',
        description: '사용자 차단을 해제하시겠어요?',
        showCancelButton: true,
        confirmCallback: _cancelBlacklist);
  }

  Future<void> _blacklist() async {
    ReportManager.blacklistMember(
        memberId: widget.member!.id,
        successCallback: () {
          if (mounted) {
            context.read<RefreshPropagator>().propagate('member');
          }
          Alert.build(context,
              title: '사용자 차단 완료', description: '해당 사용자 차단을 완료했어요');
        },
        failedCallback: () {
          Alert.build(context,
              title: '사용자 차단 실패', description: '문제가 발생했어요. 잠시 후 다시 시도해주세요.');
        });
  }

  Future<void> _cancelBlacklist() async {
    ReportManager.cancelBlacklistMember(
        memberId: widget.member!.id,
        successCallback: () {
          if (mounted) {
            context.read<RefreshPropagator>().propagate('member');
          }
          Alert.build(context,
              title: '사용자 차단 해제', description: '해당 사용자 차단을 해제했어요.');
        },
        failedCallback: () {
          Alert.build(context,
              title: '사용자 차단 해제 실패', description: '문제가 발생했어요. 잠시 후 다시 시도해주세요.');
        });
  }

  @override
  Widget build(BuildContext context) {
    return widget.auth.member.id == widget.member?.id
        ? widget.editMode
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: widget.onTapEditBackground,
                    child: IText('배경 편집'),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: widget.onTapEditCancel,
                        child: IText('취소'),
                      ),
                      Container(width: PaddingHorizontal.normal),
                      InkWell(
                        onTap: widget.onTapEditSave,
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
                    iconSize: IconSize.normal,
                    color: Colors.white,
                    backgroundOpacity: 0,
                    onPress: widget.createNostalgia,
                  ),
                  RoundButton(
                    icon: Icons.settings,
                    iconSize: IconSize.normal,
                    color: Colors.white,
                    backgroundOpacity: 0,
                    onPress: widget.onTapSettingButton,
                  )
                ],
              )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundBackButton(),
              RoundButton(
                icon: Icons.report_problem_outlined,
                color: Colors.red,
                onPress: _onTapReport,
              )
            ],
          );
  }
}
