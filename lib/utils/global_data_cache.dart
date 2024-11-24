import 'package:hive/hive.dart';
import 'package:pilipala/models/user/info.dart';
import 'package:pilipala/plugin/pl_player/models/play_repeat.dart';
import 'package:pilipala/plugin/pl_player/models/play_speed.dart';
import 'package:pilipala/utils/storage.dart';
import '../models/common/index.dart';

Box settingBox = GStorage.setting;
Box localCache = GStorage.localCache;
Box videoStorage = GStorage.video;
Box userInfoCache = GStorage.userInfo;

class GlobalDataCache {
  static late int imgQuality;
  static late FullScreenGestureMode fullScreenGestureMode;
  static late bool enablePlayerControlAnimation;
  static late List<String> actionTypeSort;
  static late double sheetHeight;
  static String? wWebid;

  /// 播放器相关
  // 弹幕开关
  static late bool isOpenDanmu;
  // 弹幕屏蔽类型
  static late List<dynamic> blockTypes;
  // 弹幕展示区域
  static late double showArea;
  // 弹幕透明度
  static late double opacityVal;
  // 弹幕字体大小
  static late double fontSizeVal;
  // 弹幕显示时间
  static late double danmakuDurationVal;
  // 弹幕描边宽度
  static late double strokeWidth;
  // 播放器循环模式
  static late PlayRepeat playRepeat;
  // 播放器默认播放速度
  static late double playbackSpeed;
  // 播放器自动长按速度
  static late bool enableAutoLongPressSpeed;
  // 播放器长按速度
  static late double longPressSpeed;
  // 播放器速度列表
  static late List<double> speedsList;
  // 用户信息
  static UserInfoData? userInfo;
  // 搜索历史
  static late List historyCacheList;
  // 搜索建议
  static late bool enableSearchSuggest;
  // 简介默认展开
  static late bool enableAutoExpand;
  // 动态切换
  static late bool enableDynamicSwitch;
  // 投屏开关
  static bool enableDlna = false;
  // sponsorBlock开关
  static bool enableSponsorBlock = false;
  // 视频评论开关
  static List<String> enableComment = ['video', 'bangumi'];

  // 私有构造函数
  GlobalDataCache._();

  // 单例实例
  static final GlobalDataCache _instance = GlobalDataCache._();

  // 获取全局实例
  factory GlobalDataCache() => _instance;

  // 异步初始化方法
  static Future<void> initialize() async {
    imgQuality = await settingBox.get(SettingBoxKey.defaultPicQa,
        defaultValue: 10); // 设置全局变量
    fullScreenGestureMode = FullScreenGestureMode.values[settingBox.get(
        SettingBoxKey.fullScreenGestureMode,
        defaultValue: FullScreenGestureMode.fromBottomtoTop.index)];
    enablePlayerControlAnimation = settingBox
        .get(SettingBoxKey.enablePlayerControlAnimation, defaultValue: true);
    actionTypeSort = await settingBox.get(SettingBoxKey.actionTypeSort,
        defaultValue: ['like', 'coin', 'collect', 'watchLater', 'share']);

    isOpenDanmu = await settingBox.get(SettingBoxKey.enableShowDanmaku,
        defaultValue: false);
    blockTypes =
        await localCache.get(LocalCacheKey.danmakuBlockType, defaultValue: []);
    showArea =
        await localCache.get(LocalCacheKey.danmakuShowArea, defaultValue: 0.5);
    opacityVal =
        await localCache.get(LocalCacheKey.danmakuOpacity, defaultValue: 1.0);
    fontSizeVal =
        await localCache.get(LocalCacheKey.danmakuFontScale, defaultValue: 1.0);
    danmakuDurationVal =
        await localCache.get(LocalCacheKey.danmakuDuration, defaultValue: 4.0);
    strokeWidth =
        await localCache.get(LocalCacheKey.strokeWidth, defaultValue: 1.5);

    var defaultPlayRepeat = await videoStorage.get(VideoBoxKey.playRepeat,
        defaultValue: PlayRepeat.pause.value);
    playRepeat = PlayRepeat.values
        .toList()
        .firstWhere((e) => e.value == defaultPlayRepeat);
    playbackSpeed =
        await videoStorage.get(VideoBoxKey.playSpeedDefault, defaultValue: 1.0);
    enableAutoLongPressSpeed = await settingBox
        .get(SettingBoxKey.enableAutoLongPressSpeed, defaultValue: false);
    if (!enableAutoLongPressSpeed) {
      longPressSpeed = await videoStorage.get(VideoBoxKey.longPressSpeedDefault,
          defaultValue: 2.0);
    } else {
      longPressSpeed = 2.0;
    }
    speedsList = List<double>.from(await videoStorage
        .get(VideoBoxKey.customSpeedsList, defaultValue: <double>[]));
    final List<double> playSpeedSystem = await videoStorage
        .get(VideoBoxKey.playSpeedSystem, defaultValue: playSpeed);
    speedsList.addAll(playSpeedSystem);

    userInfo = userInfoCache.get('userInfoCache');
    sheetHeight = localCache.get('sheetHeight', defaultValue: 0.0);
    historyCacheList = localCache.get('cacheList', defaultValue: []);
    enableSearchSuggest =
        settingBox.get(SettingBoxKey.enableSearchSuggest, defaultValue: true);
    enableAutoExpand =
        settingBox.get(SettingBoxKey.enableAutoExpand, defaultValue: false);
    enableDynamicSwitch =
        settingBox.get(SettingBoxKey.enableDynamicSwitch, defaultValue: true);
    enableDlna = settingBox.get(SettingBoxKey.enableDlna, defaultValue: false);
    enableSponsorBlock =
        settingBox.get(SettingBoxKey.enableSponsorBlock, defaultValue: false);
    settingBox.get(SettingBoxKey.enableDynamicSwitch, defaultValue: true);
    enableDlna = settingBox.get(SettingBoxKey.enableDlna, defaultValue: false);
    enableComment = settingBox
        .get(SettingBoxKey.enableComment, defaultValue: ['video', 'bangumi']);
  }
}
