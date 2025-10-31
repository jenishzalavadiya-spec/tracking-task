class Utils {
  String trackerTime(int seconds) {
    final hours = seconds ~/ 3600;

    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    final h = hours.toString().padLeft(2, '0');
    final m = minutes.toString().padLeft(2, '0');
    final s = secs.toString().padLeft(2, '0');

    return '$h:$m:$s';
  }
}
