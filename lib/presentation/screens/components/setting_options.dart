import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wehere_client/presentation/providers/authentication_provider.dart';
import 'package:wehere_client/presentation/screens/components/term_bottom_sheet.dart';
import 'package:wehere_client/presentation/widgets/alert.dart';
import 'package:wehere_client/presentation/widgets/bottom_sheet.dart';

class SettingOptions {
  final BuildContext context;
  final Function() onTapEditProfile;

  SettingOptions(this.context, this.onTapEditProfile);

  List<BottomSheetItem> get options =>
      [
        BottomSheetItem(title: '프로필 편집', onPress: onTapEditProfile),
        BottomSheetItem(title: '서비스 이용약관', onPress: () {
          TermBottomSheet.show(context);
        }),
        BottomSheetItem(title: '로그아웃', onPress: _logout),
        BottomSheetItem(title: '회원탈퇴', color: Colors.red, onPress: _resign),
      ];

  Future<void> _logout() async {
    await context.read<AuthenticationProvider>().logout();
  }

  Future<void> _resign() async {
    final provider = context.read<AuthenticationProvider>();
    await Alert.build(context,
        title: '정말.. 떠나시겠어요?',
        description: '지금까지 쌓아온 추억들이 모두 사라져요',
        showCancelButton: true, confirmCallback: () async {
          await provider.resign();
        });
  }
}
