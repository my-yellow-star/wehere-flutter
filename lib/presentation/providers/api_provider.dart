import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

abstract class ApiProvider extends ChangeNotifier {
  bool _isLoading = false;
  DioError? _error;

  void initialize();

  bool get isLoading => _isLoading;

  @protected
  set isLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  DioError? get error => _error;

  @protected
  set error(DioError? error) {
    _error = error;
  }
}
