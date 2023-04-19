// 工具函数
import 'dart:io';
import 'package:get/get_utils/get_utils.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  static Future<String> getCookiePath() async {
    Directory tempDir = await getApplicationSupportDirectory();
    String tempPath = "${tempDir.path}/.plpl/";
    Directory dir = Directory(tempPath);
    bool b = await dir.exists();
    if (!b) {
      dir.createSync(recursive: true);
    }
    return tempPath;
  }

  static String numFormat(int number) {
    String res = (number / 10000).toString();
    if (int.parse(res.split('.')[0]) >= 1) {
      return '${(number / 10000).toPrecision(1)}万';
    } else {
      return number.toString();
    }
  }

  static String timeFormat(int time) {
    // 1小时内
    if (time < 3600) {
      int minute = time ~/ 60;
      double res = time / 60;
      if (minute != res) {
        return '$minute:${(time - minute * 60) < 10 ? '0${(time - minute * 60)}' : (time - minute * 60)}';
      } else {
        return minute.toString();
      }
    } else {
      return '';
    }
  }
}
