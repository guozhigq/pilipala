import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class GStrorage {
  static late final Box user;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = dir.path;
    Hive.init('$path/hive');
    user = await Hive.openBox('user');
  }
}

// 约定 key
class UserBoxKey {
  static const String userName = 'userName';
  // 头像
  static const String userFace = 'userFace';
  // mid
  static const String userMid = 'userMid';
  // 登录状态
  static const String userLogin = 'userLogin';
}
