extension DistanceParser on int {
  String parseDistance() {
    if (this < 1000) {
      return '${this}m';
    }

    return '${this ~/ 1000}km';
  }
}

extension DateParser on DateTime {
  String parseDate() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final deltaInSeconds = (now - millisecondsSinceEpoch) ~/ 1000;

    if (deltaInSeconds < 60) {
      return '방금'; // just now
    }

    final deltaInMinutes = deltaInSeconds ~/ 60;
    if (deltaInMinutes < 60) {
      return '$deltaInMinutes분 전'; // minutes ago
    }

    final deltaInHours = deltaInMinutes ~/ 60;
    if (deltaInHours < 24) {
      return '$deltaInHours시간 전'; // hours ago
    }

    final deltaInDays = deltaInHours ~/ 24;
    if (deltaInDays < 30) {
      return '$deltaInDays일 전'; // days ago
    }

    final deltaInMonths = deltaInDays ~/ 30;
    if (deltaInMonths < 12) {
      return '$deltaInMonths개월 전'; // months ago
    }

    return '${deltaInMonths ~/ 12}년 전'; // yrs ago
  }
}
