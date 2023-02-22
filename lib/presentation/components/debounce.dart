import 'dart:async';
import 'dart:ui';

class Debounce {
  final int durationMilliseconds;
  Timer? _timer;

  Debounce(this.durationMilliseconds);

  void run(VoidCallback callback) {
    if (_timer?.isActive ?? false) _timer?.cancel();

    _timer = Timer(Duration(milliseconds: durationMilliseconds), () {
      callback();
    });
  }
}
