// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pilipala/models/home/rcmd/result.dart';
import 'package:pilipala/models/model_owner.dart';
import 'package:pilipala/models/search/hot.dart';
import 'package:pilipala/models/user/info.dart';

class GStrorage {
  static late final Box recVideo;
  static late final Box userInfo;
  static late final Box historyword;
  static late final Box localCache;
  static late final Box setting;
  static late final Box video;

  static Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    final path = dir.path;
    await Hive.initFlutter('$path/hive');
    regAdapter();
    // 首页推荐视频
    recVideo = await Hive.openBox(
      'recVideo',
      compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 12;
      },
    );
    // 登录用户信息
    userInfo = await Hive.openBox(
      'userInfo',
      compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 2;
      },
    );
    // 本地缓存
    localCache = await Hive.openBox('localCache');
    // 设置
    setting = await Hive.openBox('setting');
    // 搜索历史
    historyword = await Hive.openBox(
      'historyWord',
      compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 10;
      },
    );
  }

  static regAdapter() {
    Hive.registerAdapter(RecVideoItemAppModelAdapter());
    Hive.registerAdapter(RcmdReasonAdapter());
    Hive.registerAdapter(RcmdStatAdapter());
    Hive.registerAdapter(RcmdOwnerAdapter());
    Hive.registerAdapter(OwnerAdapter());
    Hive.registerAdapter(UserInfoDataAdapter());
    Hive.registerAdapter(LevelInfoAdapter());
    Hive.registerAdapter(HotSearchModelAdapter());
    Hive.registerAdapter(HotSearchItemAdapter());
  }

  static Future<void> lazyInit() async {
    // 视频设置
    video = await Hive.openBox('video');
  }

  static Future<void> close() async {
    // user.compact();
    // user.close();
    recVideo.compact();
    recVideo.close();
    userInfo.compact();
    userInfo.close();
    historyword.compact();
    historyword.close();
    localCache.compact();
    localCache.close();
    setting.compact();
    setting.close();
    video.compact();
    video.close();
  }
}

class SettingBoxKey {
  static const String btmProgressBehavior = 'btmProgressBehavior';
  static const String defaultVideoSpeed = 'defaultVideoSpeed';
  static const String autoUpgradeEnable = 'autoUpgradeEnable';
  static const String feedBackEnable = 'feedBackEnable';
  static const String defaultVideoQa = 'defaultVideoQa';
  static const String defaultAudioQa = 'defaultAudioQa';
  static const String autoPlayEnable = 'autoPlayEnable';
  static const String fullScreenMode = 'fullScreenMode';
  static const String defaultDecode = 'defaultDecode';
  static const String danmakuEnable = 'danmakuEnable';
  static const String defaultPicQa = 'defaultPicQa';
  static const String enableHA = 'enableHA';
  static const String enableOnlineTotal = 'enableOnlineTotal';

  static const String blackMidsList = 'blackMidsList';

  static const String autoUpdate = 'autoUpdate';

  static const String themeMode = 'themeMode';
  static const String defaultTextScale = 'textScale';
  static const String dynamicColor = 'dynamicColor'; // bool
  static const String customColor = 'customColor'; // 自定义主题色
}

class LocalCacheKey {
  // 历史记录暂停状态 默认false 记录
  static const String historyPause = 'historyPause';
  // access_key
  static const String accessKey = 'accessKey';

  //
  static const String wbiKeys = 'wbiKeys';
  static const String timeStamp = 'timeStamp';
}

class VideoBoxKey {
  // 视频比例
  static const String videoFit = 'videoFit';
  // 亮度
  static const String videoBrightness = 'videoBrightness';
  // 倍速
  static const String videoSpeed = 'videoSpeed';
}
