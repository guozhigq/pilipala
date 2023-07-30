String printDuration(Duration? duration) {
  if (duration == null) return "--:--";

  /*String twoDigits(int n) {
    if (n >= 10||n < 0) return "$n";
    return "0$n";
  }*/
  String twoDigits(int n) => n.toString().padLeft(2, "0");

  String twoDigitMinutes = twoDigits(duration.inMinutes).replaceAll("-", "");
  String twoDigitSeconds =
      twoDigits(duration.inSeconds.remainder(60)).replaceAll("-", "");
  //customDebugPrint(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}

String printDurationWithHours(Duration? duration) {
  if (duration == null) return "--:--:--";

  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitHours = twoDigits(duration.inHours);
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
}
