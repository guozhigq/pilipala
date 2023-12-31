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
  static const String enableAutoBrightness = 'enableAutoBrightness';
  static const String enableAutoEnter = 'enableAutoEnter';
  static const String enableAutoExit = 'enableAutoExit';
  static const String p1080 = 'p1080';
  static const String enableCDN = 'enableCDN';
  static const String autoPiP = 'autoPiP';
  static const String enableAutoLongPressSpeed = 'enableAutoLongPressSpeed';

  // youtube 双击快进快退
  static const String enableQuickDouble = 'enableQuickDouble';
  static const String enableShowDanmaku = 'enableShowDanmaku';
  static const String enableBackgroundPlay = 'enableBackgroundPlay';

  /// 隐私
  static const String blackMidsList = 'blackMidsList';

  /// 其他
  static const String autoUpdate = 'autoUpdate';
  static const String replySortType = 'replySortType';
  static const String defaultDynamicType = 'defaultDynamicType';
  static const String enableHotKey = 'enableHotKey';
  static const String enableQuickFav = 'enableQuickFav';
  static const String enableWordRe = 'enableWordRe';
  static const String enableSearchWord = 'enableSearchWord';
  static const String enableRcmdDynamic = 'enableRcmdDynamic';
  static const String enableSaveLastData = 'enableSaveLastData';
  static const String enableSystemProxy = 'enableSystemProxy';
  static const String enableAi = 'enableAi';

  /// 外观
  static const String themeMode = 'themeMode';
  static const String defaultTextScale = 'textScale';
  static const String dynamicColor = 'dynamicColor'; // bool
  static const String customColor = 'customColor'; // 自定义主题色
  static const String enableSingleRow = 'enableSingleRow'; // 首页单列
  static const String displayMode = 'displayMode';
  static const String customRows = 'customRows'; // 自定义列
  static const String enableMYBar = 'enableMYBar';
  static const String hideSearchBar = 'hideSearchBar'; // 收起顶栏
  static const String hideTabBar = 'hideTabBar'; // 收起底栏
}

class LocalCacheKey {
  // 历史记录暂停状态 默认false 记录
  static const String historyPause = 'historyPause';
  // access_key
  static const String accessKey = 'accessKey';

  //
  static const String wbiKeys = 'wbiKeys';
  static const String timeStamp = 'timeStamp';

  // 弹幕相关设置 屏蔽类型 显示区域 透明度 字体大小 弹幕时间
  static const String danmakuBlockType = 'danmakuBlockType';
  static const String danmakuShowArea = 'danmakuShowArea';
  static const String danmakuOpacity = 'danmakuOpacity';
  static const String danmakuFontScale = 'danmakuFontScale';
  static const String danmakuDuration = 'danmakuDuration';

  // 代理host port
  static const String systemProxyHost = 'systemProxyHost';
  static const String systemProxyPort = 'systemProxyPort';
}

class VideoBoxKey {
  // 视频比例
  static const String videoFit = 'videoFit';
  // 亮度
  static const String videoBrightness = 'videoBrightness';
  // 倍速
  static const String videoSpeed = 'videoSpeed';
  // 播放顺序
  static const String playRepeat = 'playRepeat';
  // 默认倍速
  static const String playSpeedDefault = 'playSpeedDefault';
  // 默认长按倍速
  static const String longPressSpeedDefault = 'longPressSpeedDefault';
  // 自定义倍速集合
  static const String customSpeedsList = 'customSpeedsList';
  // 画面填充比例
  static const String cacheVideoFit = 'cacheVideoFit';
}
