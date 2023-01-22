import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:wehere_client/core/resources/data_state.dart';
import 'package:wehere_client/domain/entities/member.dart';
import 'package:wehere_client/domain/usecases/get_profile_usecase.dart';

class MemberProvider extends ChangeNotifier {
  final GetProfileUseCase _getProfileUseCase;

  MemberProvider(this._getProfileUseCase);

  bool _isLoading = false;
  Member? _member;
  DioError? _error;

  bool get isLoading => _isLoading;

  Member? get member => _member;

  DioError? get error => _error;

  Future<void> getMember() async {
    _isLoading = true;
    notifyListeners();

    final response = await _getProfileUseCase();
    if (response is DataSuccess) {
      _member = response.data;
    } else {
      _error = response.error;
    }
    _isLoading = false;
    notifyListeners();
  }
}
