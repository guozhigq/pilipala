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
    localCache = await Hive.openBox(
      'localCache',
      compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 4;
      },
    );
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
  /// 播放器
  static const btmProgressBehavior = 'btmProgressBehavior',
      defaultVideoSpeed = 'defaultVideoSpeed',
      autoUpgradeEnable = 'autoUpgradeEnable',
      feedBackEnable = 'feedBackEnable',
      defaultVideoQa = 'defaultVideoQa',
      defaultAudioQa = 'defaultAudioQa',
      autoPlayEnable = 'autoPlayEnable',
      fullScreenMode = 'fullScreenMode',
      defaultDecode = 'defaultDecode',
      danmakuEnable = 'danmakuEnable',
      defaultPicQa = 'defaultPicQa',
      enableHA = 'enableHA',
      enableOnlineTotal = 'enableOnlineTotal',
      enableAutoBrightness = 'enableAutoBrightness',
      enableAutoEnter = 'enableAutoEnter',
      enableAutoExit = 'enableAutoExit',
      p1080 = 'p1080',
      enableCDN = 'enableCDN',
      autoPiP = 'autoPiP',
      enableAutoLongPressSpeed = 'enableAutoLongPressSpeed',

      // youtube 双击快进快退
      enableQuickDouble = 'enableQuickDouble',
      enableShowDanmaku = 'enableShowDanmaku',
      enableBackgroundPlay = 'enableBackgroundPlay',

      /// 隐私
      blackMidsList = 'blackMidsList',

      /// 其他
      autoUpdate = 'autoUpdate',
      defaultRcmdType = 'defaultRcmdType',
      replySortType = 'replySortType',
      defaultDynamicType = 'defaultDynamicType',
      enableHotKey = 'enableHotKey',
      enableQuickFav = 'enableQuickFav',
      enableWordRe = 'enableWordRe',
      enableSearchWord = 'enableSearchWord',
      enableRcmdDynamic = 'enableRcmdDynamic',
      enableSaveLastData = 'enableSaveLastData',
      enableSystemProxy = 'enableSystemProxy',
      enableAi = 'enableAi';

  /// 外观
  static const String themeMode = 'themeMode',
      defaultTextScale = 'textScale',
      dynamicColor = 'dynamicColor', // bool
      customColor = 'customColor', // 自定义主题色
      enableSingleRow = 'enableSingleRow', // 首页单列
      displayMode = 'displayMode',
      customRows = 'customRows', // 自定义列
      enableMYBar = 'enableMYBar',
      hideSearchBar = 'hideSearchBar', // 收起顶栏
      hideTabBar = 'hideTabBar'; // 收起底栏
}

class LocalCacheKey {
  // 历史记录暂停状态 默认false 记录
  static const String historyPause = 'historyPause',
      // access_key
      accessKey = 'accessKey',

      //
      wbiKeys = 'wbiKeys',
      timeStamp = 'timeStamp',

      // 弹幕相关设置 屏蔽类型 显示区域 透明度 字体大小 弹幕时间
      danmakuBlockType = 'danmakuBlockType',
      danmakuShowArea = 'danmakuShowArea',
      danmakuOpacity = 'danmakuOpacity',
      danmakuFontScale = 'danmakuFontScale',
      danmakuDuration = 'danmakuDuration',

      // 代理host port
      systemProxyHost = 'systemProxyHost',
      systemProxyPort = 'systemProxyPort';
}

class VideoBoxKey {
  // 视频比例
  static const String videoFit = 'videoFit',
      // 亮度
      videoBrightness = 'videoBrightness',
      // 倍速
      videoSpeed = 'videoSpeed',
      // 播放顺序
      playRepeat = 'playRepeat',
      // 默认倍速
      playSpeedDefault = 'playSpeedDefault',
      // 默认长按倍速
      longPressSpeedDefault = 'longPressSpeedDefault',
      // 自定义倍速集合
      customSpeedsList = 'customSpeedsList',
      // 画面填充比例
      cacheVideoFit = 'cacheVideoFit';
}
