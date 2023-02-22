import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/domain/entities/nostalgia.dart';
import 'package:wehere_client/presentation/components/report_manager.dart';
import 'package:wehere_client/presentation/screens/widgets/alert.dart';
import 'package:wehere_client/presentation/screens/widgets/text.dart';

class ReportModal extends StatefulWidget {
  final Nostalgia? nostalgia;
  final Member? member;
  final bool reportMember;

  const ReportModal(
      {Key? key, this.nostalgia, this.member, this.reportMember = false})
      : super(key: key);

  @override
  State<ReportModal> createState() => _ReportModalState();
}

class _ReportModalState extends State<ReportModal> {
  String _reason = "";

  String get target => widget.reportMember ? '유저' : '게시글';

  void _onReasonChanged(String value) {
    setState(() {
      _reason = value;
    });
  }

  void _onSubmitted() {
    Alert.build(
      context,
      title: '$target 신고',
      description: '신고를 제출하시겠어요?',
      showCancelButton: true,
      confirmCallback: () {
        widget.reportMember
            ? ReportManager.reportMember(
                memberId: widget.member!.id,
                reason: _reason,
                successCallback: _onSuccess,
              )
            : ReportManager.reportNostalgia(
                nostalgiaId: widget.nostalgia!.id,
                reason: _reason,
                successCallback: _onSuccess,
              );
      },
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
    Alert.build(
      context,
      title: '$target 신고 완료',
      description: '작성하신 $target 신고가 완료되었어요.\n핀플이 신고해주신 내용을 면밀히 검토해볼게요.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(
          left: PaddingHorizontal.normal,
          right: PaddingHorizontal.normal,
          top: PaddingVertical.big,
          bottom: PaddingVertical.big),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IText(
            '$target 신고',
            color: Colors.black,
            weight: FontWeight.bold,
          ),
          Container(height: PaddingVertical.normal),
          TextField(
              onChanged: _onReasonChanged,
              style: TextStyle(color: Colors.black, fontSize: FontSize.regular),
              decoration: InputDecoration(
                isDense: false,
                hintText: 'ex) 부적절한 콘텐츠, 욕설 및 비방',
                hintStyle:
                    TextStyle(color: Colors.grey, fontSize: FontSize.small),
                label: IText('신고 사유', color: Colors.black),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black)),
                contentPadding: EdgeInsets.only(
                    left: PaddingHorizontal.small,
                    right: PaddingHorizontal.small),
              )),
          Container(height: PaddingVertical.big),
          InkWell(
            onTap: _onSubmitted,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: PaddingVertical.normal,
                bottom: PaddingVertical.normal,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.blue),
              child: Center(child: IText('신고 제출하기')),
            ),
          )
        ],
      ),
    );
  }
}
