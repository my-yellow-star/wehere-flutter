import 'package:flutter/cupertino.dart';
import 'package:new_version/new_version.dart';

class AppVersionManager {
  static void manage(BuildContext context) async {
    final newVersion = NewVersion();
    final status = await newVersion.getVersionStatus();
    final type = _resolveUpdateType(status!);

    if (context.mounted && status.canUpdate) {
      final isForced = type == UpdateType.force;
      newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          allowDismissal: !isForced,
          dialogTitle: isForced ? '앱이 새롭게 업데이트 되었어요!' : '새로운 버전이 업데이트 되었어요!',
          dialogText:
              '유저분들의 의견을 반영하여\n핀플이 더 나아진 모습으로 찾아왔어요.\n지금 업데이트로 확인해보세요 :)',
          updateButtonText: '업데이트!',
          dismissButtonText: '나중에 :(');
    }
  }

  static UpdateType _resolveUpdateType(VersionStatus status) {
    final current = status.localVersion;
    final currentMajor = int.parse(current.split('.')[0]);
    final currentMiddle = int.parse(current.split('.')[1]);
    final latest = status.storeVersion;
    final latestMajor = int.parse(latest.split('.')[0]);
    final latestMiddle = int.parse(latest.split('.')[1]);
    if (!status.canUpdate) return UpdateType.none;

    if (latestMajor > currentMajor) return UpdateType.force;

    if (latestMiddle > currentMiddle) {
      return UpdateType.force;
    } else {
      return UpdateType.recommend;
    }
  }
}

enum UpdateType { recommend, force, none }
