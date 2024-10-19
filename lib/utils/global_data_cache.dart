import 'package:hive/hive.dart';
import 'package:pilipala/models/user/info.dart';
import 'package:pilipala/plugin/pl_player/models/play_repeat.dart';
import 'package:pilipala/plugin/pl_player/models/play_speed.dart';
import 'package:pilipala/utils/storage.dart';
import '../models/common/index.dart';

Box setting = GStrorage.setting;
Box localCache = GStrorage.localCache;
Box videoStorage = GStrorage.video;
Box userInfoCache = GStrorage.userInfo;

class GlobalDataCache {
  late int imgQuality;
  late FullScreenGestureMode fullScreenGestureMode;
  late bool enablePlayerControlAnimation;
  late List<String> actionTypeSort;
  late double sheetHeight;
  String? wWebid;

  /// 播放器相关
  // 弹幕开关
  late bool isOpenDanmu;
  // 弹幕屏蔽类型
  late List<dynamic> blockTypes;
  // 弹幕展示区域
  late double showArea;
  // 弹幕透明度
  late double opacityVal;
  // 弹幕字体大小
  late double fontSizeVal;
  // 弹幕显示时间
  late double danmakuDurationVal;
  // 弹幕描边宽度
  late double strokeWidth;
  // 播放器循环模式
  late PlayRepeat playRepeat;
  // 播放器默认播放速度
  late double playbackSpeed;
  // 播放器自动长按速度
  late bool enableAutoLongPressSpeed;
  // 播放器长按速度
  late double longPressSpeed;
  // 播放器速度列表
  late List<double> speedsList;
  // 用户信息
  UserInfoData? userInfo;
  // 搜索历史
  late List historyCacheList;
  //
  late bool enableSearchSuggest = true;

  // 私有构造函数
  GlobalDataCache._();

  // 单例实例
  static final GlobalDataCache _instance = GlobalDataCache._();

  // 获取全局实例
  factory GlobalDataCache() => _instance;

  // 异步初始化方法
  Future<void> initialize() async {
    imgQuality = await setting.get(SettingBoxKey.defaultPicQa,
        defaultValue: 10); // 设置全局变量
    fullScreenGestureMode = FullScreenGestureMode.values[setting.get(
        SettingBoxKey.fullScreenGestureMode,
        defaultValue: FullScreenGestureMode.fromBottomtoTop.index)];
    enablePlayerControlAnimation = setting
        .get(SettingBoxKey.enablePlayerControlAnimation, defaultValue: true);
    actionTypeSort = await setting.get(SettingBoxKey.actionTypeSort,
        defaultValue: ['like', 'coin', 'collect', 'watchLater', 'share']);

    isOpenDanmu =
        await setting.get(SettingBoxKey.enableShowDanmaku, defaultValue: false);
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
    enableAutoLongPressSpeed = await setting
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
        setting.get(SettingBoxKey.enableSearchSuggest, defaultValue: true);
  }
}
