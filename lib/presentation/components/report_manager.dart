import 'package:flutter/foundation.dart';
import 'package:wehere_client/core/params/blacklist.dart';
import 'package:wehere_client/core/params/report.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/usecases/create_blacklist_usecase.dart';
import 'package:wehere_client/domain/usecases/delete_blacklist.usecase.dart';
import 'package:wehere_client/domain/usecases/report_usecase.dart';
import 'package:wehere_client/injector.dart';

class ReportManager {
  static final ReportUseCase _reportUseCase = injector<ReportUseCase>();
  static final CreateBlacklistUseCase _createBlacklistUseCase =
      injector<CreateBlacklistUseCase>();
  static final DeleteBlacklistUseCase _deleteBlacklistUseCase =
      injector<DeleteBlacklistUseCase>();

  static void reportNostalgia(
      {required String nostalgiaId,
      required String reason,
      VoidCallback? successCallback,
      VoidCallback? failedCallback}) async {
    final response = await _reportUseCase(
        ReportParams(reason: reason, nostalgiaId: nostalgiaId));
    if (response is DataSuccess) {
      successCallback?.call();
    } else {
      failedCallback?.call();
    }
  }

  static void reportMember(
      {required String memberId,
      required String reason,
      VoidCallback? successCallback,
      VoidCallback? failedCallback}) async {
    final response =
        await _reportUseCase(ReportParams(reason: reason, memberId: memberId));
    if (response is DataSuccess) {
      successCallback?.call();
    } else {
      failedCallback?.call();
    }
  }

  static void blacklistNostalgia(
      {required String nostalgiaId,
      VoidCallback? successCallback,
      VoidCallback? failedCallback}) async {
    final response = await _createBlacklistUseCase(
        BlacklistParams(nostalgiaId: nostalgiaId));
    if (response is DataSuccess) {
      successCallback?.call();
    } else {
      failedCallback?.call();
    }
  }

  static void blacklistMember(
      {required String memberId,
      VoidCallback? successCallback,
      VoidCallback? failedCallback}) async {
    final response =
        await _createBlacklistUseCase(BlacklistParams(memberId: memberId));
    if (response is DataSuccess) {
      successCallback?.call();
    } else {
      failedCallback?.call();
    }
  }

  static void cancelBlacklistMember(
      {required String memberId,
      VoidCallback? successCallback,
      VoidCallback? failedCallback}) async {
    final response =
        await _deleteBlacklistUseCase(BlacklistParams(memberId: memberId));
    if (response is DataSuccess) {
      successCallback?.call();
    } else {
      failedCallback?.call();
    }
  }
}
