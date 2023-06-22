// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pilipala/models/model_owner.dart';
import 'package:pilipala/models/model_rec_video_item.dart';
import 'package:pilipala/models/search/hot.dart';
import 'package:pilipala/models/user/info.dart';

class GStrorage {
  static late final Box user;
  static late final Box recVideo;
  static late final Box userInfo;
  static late final Box hotKeyword;
  static late final Box historyword;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = dir.path;
    await Hive.initFlutter('$path/hive');
    regAdapter();
    // 用户信息
    user = await Hive.openBox('user');
    // 首页推荐视频
    recVideo = await Hive.openBox('recVideo');
    // 登录用户信息
    userInfo = await Hive.openBox('userInfo');
    // 热搜关键词
    hotKeyword = await Hive.openBox('hotKeyword');
    // 搜索历史
    historyword = await Hive.openBox('historyWord');
  }

  static regAdapter() {
    Hive.registerAdapter(RecVideoItemModelAdapter());
    Hive.registerAdapter(RcmdReasonAdapter());
    Hive.registerAdapter(StatAdapter());
    Hive.registerAdapter(OwnerAdapter());
    Hive.registerAdapter(UserInfoDataAdapter());
    Hive.registerAdapter(LevelInfoAdapter());
    Hive.registerAdapter(HotSearchModelAdapter());
    Hive.registerAdapter(HotSearchItemAdapter());
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

class SettingBoxKey {
  static const String themeMode = 'themeMode';
}
