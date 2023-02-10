import 'package:flutter/cupertino.dart';

class RefreshPropagator extends ChangeNotifier {
  final Map<String, bool> _refreshIndicatorContainer = {};

  void propagate(String channel) {
    _refreshIndicatorContainer[channel] = true;
    notifyListeners();
  }

  bool consume(String channel) {
    final shouldRefresh = _refreshIndicatorContainer[channel] ?? false;
    if (_refreshIndicatorContainer[channel] == true) {
      _refreshIndicatorContainer[channel] = false;
    }
    return shouldRefresh;
  }
}
