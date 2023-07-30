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
  static late final Box localCache;
  static late final Box setting;
  static late final Box video;

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
    // 本地缓存
    localCache = await Hive.openBox('localCache');
    // 设置
    setting = await Hive.openBox('setting');
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

  static Future<void> lazyInit() async {
    // 热搜关键词
    hotKeyword = await Hive.openBox('hotKeyword');
    // 搜索历史
    historyword = await Hive.openBox('historyWord');
    // 视频设置
    video = await Hive.openBox('video');
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
  static const String feedBackEnable = 'feedBackEnable';
}

class LocalCacheKey {
  // 历史记录暂停状态 默认false
  static const String historyStatus = 'historyStatus';
}

class VideoBoxKey {
  // 视频比例
  static const String videoFit = 'videoFit';
  // 亮度
  static const String videoBrightness = 'videoBrightness';
  // 倍速
  static const String videoSpeed = 'videoSpeed';
}
