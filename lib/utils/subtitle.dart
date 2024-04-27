class SubTitleUtils {
  // 格式整理
  static String convertToWebVTT(List jsonData) {
    String webVTTContent = 'WEBVTT FILE\n\n';

    for (int i = 0; i < jsonData.length; i++) {
      final item = jsonData[i];
      double from = double.parse(item['from'].toString());
      double to = double.parse(item['to'].toString());
      int sid = (item['sid'] ?? 0) as int;
      String content = item['content'] as String;

      webVTTContent += '$sid\n';
      webVTTContent += '${formatTime(from)} --> ${formatTime(to)}\n';
      webVTTContent += '$content\n\n';
    }

    return webVTTContent;
  }

  static String formatTime(num seconds) {
    final String h = (seconds / 3600).floor().toString().padLeft(2, '0');
    final String m = (seconds % 3600 / 60).floor().toString().padLeft(2, '0');
    final String s = (seconds % 60).floor().toString().padLeft(2, '0');
    final String ms =
        (seconds * 1000 % 1000).floor().toString().padLeft(3, '0');
    if (h == '00') {
      return "$m:$s.$ms";
    }
    return "$h:$m:$s.$ms";
  }
}
