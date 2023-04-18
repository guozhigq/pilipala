// 工具函数
import 'dart:io';
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
}
