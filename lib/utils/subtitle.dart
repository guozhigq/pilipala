import 'dart:async';
import 'dart:isolate';

class SubTitleUtils {
  // 格式整理
  static Future<String> convertToWebVTT(List jsonData) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_convertToWebVTTIsolate, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;
    final response = ReceivePort();
    sendPort.send([jsonData, response.sendPort]);

    return await response.first as String;
  }

  static void _convertToWebVTTIsolate(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final message in port) {
      final List jsonData = message[0];
      final SendPort replyTo = message[1];

      String webVTTContent = 'WEBVTT FILE\n\n';
      int chunkSize = 100; // 每次处理100条数据
      int totalChunks = (jsonData.length / chunkSize).ceil();

      for (int chunk = 0; chunk < totalChunks; chunk++) {
        int start = chunk * chunkSize;
        int end = start + chunkSize;
        if (end > jsonData.length) end = jsonData.length;

        for (int i = start; i < end; i++) {
          final item = jsonData[i];
          double from = double.parse(item['from'].toString());
          double to = double.parse(item['to'].toString());
          int sid = (item['sid'] ?? 0) as int;
          String content = item['content'] as String;

          webVTTContent += '$sid\n';
          webVTTContent += '${formatTime(from)} --> ${formatTime(to)}\n';
          webVTTContent += '$content\n\n';
        }
      }

      replyTo.send(webVTTContent);
    }
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
