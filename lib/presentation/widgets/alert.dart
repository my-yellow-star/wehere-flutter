import 'package:flutter/material.dart';
import 'package:wehere_client/core/resources/constant.dart';
import 'package:wehere_client/presentation/widgets/text.dart';

class Alert {
  static Future<void> build(
    BuildContext context, {
    required String title,
    String? description,
    VoidCallback? cancelCallback,
    VoidCallback? confirmCallback,
    bool showCancelButton = false,
  }) =>
      showDialog<void>(
          context: context,
          builder: (context) => _AlertWidget(
                title: title,
                description: description,
                onCancel: () {
                  cancelCallback?.call();
                  Navigator.pop(context);
                },
                onConfirm: () {
                  confirmCallback?.call();
                  Navigator.pop(context);
                },
                showCancelButton: showCancelButton,
                cancelButtonTitle: '취소',
                confirmButtonTitle: '확인',
              ));
}

class _AlertWidget extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final String cancelButtonTitle;
  final String confirmButtonTitle;
  final bool showCancelButton;

  const _AlertWidget(
      {required this.title,
      this.description,
      this.onCancel,
      this.onConfirm,
      required this.showCancelButton,
      required this.cancelButtonTitle,
      required this.confirmButtonTitle});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorTheme.primary,
      title: IText(title),
      content: description != null
          ? IText(description!, size: FontSize.small)
          : null,
      actions: [
        showCancelButton
            ? TextButton(onPressed: onCancel, child: IText(cancelButtonTitle))
            : Container(),
        TextButton(
            onPressed: onConfirm,
            child: IText(
              confirmButtonTitle,
              color: Colors.blue,
            ))
      ],
    );
  }
}
