// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:universal_platform/universal_platform.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';

Box videoStorage = GStrorage.video;
Box setting = GStrorage.setting;

class PlPlayerController {
  Player? _videoPlayerController;
  VideoController? _videoController;

  // 添加一个私有静态变量来保存实例
  static PlPlayerController? _instance;

  // 流事件  监听播放状态变化
  StreamSubscription? _playerEventSubs;

  /// [playerStatus] has a [status] observable
  final PlPlayerStatus playerStatus = PlPlayerStatus();

  ///
  final PlPlayerDataStatus dataStatus = PlPlayerDataStatus();

  // bool controlsEnabled = false;

  /// 响应数据
  // 播放位置
  final Rx<Duration> _position = Rx(Duration.zero);
  final Rx<Duration> _sliderPosition = Rx(Duration.zero);
  // 展示使用
  final Rx<Duration> _sliderTempPosition = Rx(Duration.zero);
  final Rx<Duration> _duration = Rx(Duration.zero);
  final Rx<Duration> _buffered = Rx(Duration.zero);

  final Rx<int> _playerCount = Rx(0);

  final Rx<double> _playbackSpeed = 1.0.obs;
  final Rx<double> _currentVolume = 1.0.obs;
  final Rx<double> _currentBrightness = 0.0.obs;

  final Rx<bool> _mute = false.obs;
  final Rx<bool> _showControls = false.obs;
  final Rx<bool> _showVolumeStatus = false.obs;
  final Rx<bool> _showBrightnessStatus = false.obs;
  final Rx<bool> _doubleSpeedStatus = false.obs;
  final Rx<bool> _controlsLock = false.obs;
  final Rx<bool> _isFullScreen = false.obs;
  // 默认投稿视频格式
  static Rx<String> _videoType = 'archive'.obs;

  final Rx<String> _direction = 'horizontal'.obs;

  Rx<bool> videoFitChanged = false.obs;
  final Rx<BoxFit> _videoFit = Rx(BoxFit.contain);

  ///
  // ignore: prefer_final_fields
  Rx<bool> _isSliderMoving = false.obs;
  PlaylistMode _looping = PlaylistMode.none;
  bool _autoPlay = false;
  final bool _listenersInitialized = false;

  // 记录历史记录
  String _bvid = '';
  int _cid = 0;
  int _heartDuration = 0;
  bool _enableHeart = true;
  bool _isFirstTime = true;

  Timer? _timer;
  Timer? _timerForSeek;
  Timer? _timerForVolume;
  Timer? _timerForShowingVolume;
  Timer? _timerForGettingVolume;
  Timer? timerForTrackingMouse;
  Timer? videoFitChangedTimer;

  // final Durations durations;

  List<Map<String, dynamic>> videoFitType = [
    {'attr': BoxFit.contain, 'desc': '包含'},
    {'attr': BoxFit.cover, 'desc': '覆盖'},
    {'attr': BoxFit.fill, 'desc': '填充'},
    {'attr': BoxFit.fitHeight, 'desc': '高度适应'},
    {'attr': BoxFit.fitWidth, 'desc': '宽度适应'},
    {'attr': BoxFit.scaleDown, 'desc': '缩小适应'},
  ];

  PreferredSizeWidget? headerControl;

  /// 数据加载监听
  Stream<DataStatus> get onDataStatusChanged => dataStatus.status.stream;

  /// 播放状态监听
  Stream<PlayerStatus> get onPlayerStatusChanged => playerStatus.status.stream;

  /// 视频时长
  Rx<Duration> get duration => _duration;
  Stream<Duration> get onDurationChanged => _duration.stream;

  /// 视频当前播放位置
  Rx<Duration> get position => _position;
  Stream<Duration> get onPositionChanged => _position.stream;

  /// 视频播放速度
  double get playbackSpeed => _playbackSpeed.value;

  /// 视频缓冲
  Rx<Duration> get buffered => _buffered;
  Stream<Duration> get onBufferedChanged => _buffered.stream;

  // 视频静音
  Rx<bool> get mute => _mute;
  Stream<bool> get onMuteChanged => _mute.stream;

  /// [videoPlayerController] instace of Player
  Player? get videoPlayerController => _videoPlayerController;

  /// [videoController] instace of Player
  VideoController? get videoController => _videoController;

  Rx<bool> get isSliderMoving => _isSliderMoving;

  /// 进度条位置及监听
  Rx<Duration> get sliderPosition => _sliderPosition;
  Stream<Duration> get onSliderPositionChanged => _sliderPosition.stream;

  Rx<Duration> get sliderTempPosition => _sliderTempPosition;
  // Stream<Duration> get onSliderPositionChanged => _sliderPosition.stream;

  /// 是否展示控制条及监听
  Rx<bool> get showControls => _showControls;
  Stream<bool> get onShowControlsChanged => _showControls.stream;

  /// 音量控制条展示/隐藏
  Rx<bool> get showVolumeStatus => _showVolumeStatus;
  Stream<bool> get onShowVolumeStatusChanged => _showVolumeStatus.stream;

  /// 亮度控制条展示/隐藏
  Rx<bool> get showBrightnessStatus => _showBrightnessStatus;
  Stream<bool> get onShowBrightnessStatusChanged =>
      _showBrightnessStatus.stream;

  /// 音量控制条
  Rx<double> get volume => _currentVolume;
  Stream<double> get onVolumeChanged => _currentVolume.stream;

  /// 亮度控制条
  Rx<double> get brightness => _currentBrightness;
  Stream<double> get onBrightnessChanged => _currentBrightness.stream;

  /// 是否循环
  PlaylistMode get looping => _looping;

  /// 是否自动播放
  bool get autoplay => _autoPlay;

  /// 视频比例
  Rx<BoxFit> get videoFit => _videoFit;

  /// 是否长按倍速
  Rx<bool> get doubleSpeedStatus => _doubleSpeedStatus;

  Rx<bool> isBuffering = true.obs;

  /// 屏幕锁 为true时，关闭控制栏
  Rx<bool> get controlsLock => _controlsLock;

  /// 全屏状态
  Rx<bool> get isFullScreen => _isFullScreen;

  /// 全屏方向
  Rx<String> get direction => _direction;

  Rx<int> get playerCount => _playerCount;

  ///
  Rx<String> get videoType => _videoType;

  // 添加一个私有构造函数
  PlPlayerController._() {
    _videoType = videoType;
    // _playerEventSubs = onPlayerStatusChanged.listen((PlayerStatus status) {
    //   if (status == PlayerStatus.playing) {
    //     WakelockPlus.enable();
    //   } else {
    //     WakelockPlus.disable();
    //   }
    // });
  }

  // 获取实例 传参
  static PlPlayerController getInstance({
    String videoType = 'archive',
    List<BoxFit> fits = const [
      BoxFit.contain,
      BoxFit.cover,
      BoxFit.fill,
      BoxFit.fitHeight,
      BoxFit.fitWidth,
      BoxFit.scaleDown
    ],
  }) {
    // 如果实例尚未创建，则创建一个新实例
    _instance ??= PlPlayerController._();
    _instance!._playerCount.value += 1;
    _videoType.value = videoType;
    return _instance!;
  }

  // 初始化资源
  Future<void> setDataSource(
    DataSource dataSource, {
    bool autoplay = true,
    // 默认不循环
    PlaylistMode looping = PlaylistMode.none,
    // 初始化播放位置
    Duration seekTo = Duration.zero,
    // 初始化播放速度
    double speed = 1.0,
    // 硬件加速
    bool enableHA = true,
    double? width,
    double? height,
    Duration? duration,
    // 方向
    String? direction,
    // 记录历史记录
    String bvid = '',
    int cid = 0,
    // 历史记录开关
    bool enableHeart = true,
    // 是否首次加载
    bool isFirstTime = true,
  }) async {
    try {
      _autoPlay = autoplay;
      _looping = looping;
      // 初始化视频倍速
      _playbackSpeed.value = speed;
      // 初始化数据加载状态
      dataStatus.status.value = DataStatus.loading;
      // 初始化全屏方向
      _direction.value = direction ?? 'horizontal';
      _bvid = bvid;
      _cid = cid;
      _enableHeart = enableHeart;
      _isFirstTime = isFirstTime;

      if (_videoPlayerController != null &&
          _videoPlayerController!.state.playing) {
        await pause(notify: false);
      }

      // 配置Player 音轨、字幕等等
      _videoPlayerController = await _createVideoController(
          dataSource, _looping, enableHA, width, height);
      // 获取视频时长 00:00
      _duration.value = duration ?? _videoPlayerController!.state.duration;
      // 数据加载完成
      dataStatus.status.value = DataStatus.loaded;

      await _initializePlayer(seekTo: seekTo);

      // listen the video player events
      if (!_listenersInitialized) {
        startListeners();
      }
      bool autoEnterFullcreen =
          setting.get(SettingBoxKey.enableAutoEnter, defaultValue: false);
      if (autoEnterFullcreen && _isFirstTime) {
        await Future.delayed(const Duration(milliseconds: 100));
        triggerFullScreen();
      }
    } catch (err) {
      dataStatus.status.value = DataStatus.error;
      print('plPlayer err:  $err');
    }
  }

  // 配置播放器
  Future<Player> _createVideoController(
    DataSource dataSource,
    PlaylistMode looping,
    bool enableHA,
    double? width,
    double? height,
  ) async {
    // 每次配置时先移除监听
    removeListeners();
    isBuffering.value = false;
    buffered.value = Duration.zero;
    _heartDuration = 0;
    _position.value = Duration.zero;

    Player player = _videoPlayerController ??
        Player(
          configuration: const PlayerConfiguration(
            // 默认缓存 5M 大小
            bufferSize: 5 * 1024 * 1024,
          ),
        );

    var pp = player.platform as NativePlayer;

    // 音轨
    if (dataSource.audioSource != '' && dataSource.audioSource != null) {
      await pp.setProperty(
        'audio-files',
        UniversalPlatform.isWindows
            ? dataSource.audioSource!.replaceAll(';', '\\;')
            : dataSource.audioSource!.replaceAll(':', '\\:'),
      );
    }

    // 字幕
    if (dataSource.subFiles != '' && dataSource.subFiles != null) {
      await pp.setProperty(
        'sub-files',
        UniversalPlatform.isWindows
            ? dataSource.subFiles!.replaceAll(';', '\\;')
            : dataSource.subFiles!.replaceAll(':', '\\:'),
      );
      await pp.setProperty("subs-with-matching-audio", "no");
      await pp.setProperty("sub-forced-only", "yes");
      await pp.setProperty("blend-subtitles", "video");
    }

    _videoController = _videoController ??
        VideoController(
          player,
          configuration: VideoControllerConfiguration(
            enableHardwareAcceleration: enableHA,
          ),
        );

    player.setPlaylistMode(looping);

    if (dataSource.type == DataSourceType.asset) {
      final assetUrl = dataSource.videoSource!.startsWith("asset://")
          ? dataSource.videoSource!
          : "asset://${dataSource.videoSource!}";
      player.open(
        Media(assetUrl, httpHeaders: dataSource.httpHeaders),
        play: false,
      );
    } else if (dataSource.type == DataSourceType.network) {
      player.open(
        Media(dataSource.videoSource!, httpHeaders: dataSource.httpHeaders),
        play: false,
      );
      // 音轨
      // player.setAudioTrack(
      //   AudioTrack.uri(dataSource.audioSource!),
      // );
    } else {
      player.open(
        Media(dataSource.file!.path, httpHeaders: dataSource.httpHeaders),
        play: false,
      );
    }

    return player;
  }

  // 开始播放
  Future _initializePlayer({
    Duration seekTo = Duration.zero,
  }) async {
    // 跳转播放
    if (seekTo != Duration.zero) {
      await this.seekTo(seekTo);
    }

    // 设置倍速
    if (_playbackSpeed.value != 1.0) {
      await setPlaybackSpeed(_playbackSpeed.value);
    }

    // if (_looping) {
    //   await setLooping(_looping);
    // }

    // 自动播放
    if (_autoPlay) {
      await play();
    }
  }

  List<StreamSubscription> subscriptions = [];
  final List<VoidCallback> _positionListeners = [];
  final List<Function(PlayerStatus status)> _statusListeners = [];

  /// 播放事件监听
  void startListeners() {
    subscriptions.addAll(
      [
        videoPlayerController!.stream.playing.listen((event) {
          if (event) {
            playerStatus.status.value = PlayerStatus.playing;
          } else {
            // playerStatus.status.value = PlayerStatus.paused;
          }

          /// 触发回调事件
          for (var element in _statusListeners) {
            element(event ? PlayerStatus.playing : PlayerStatus.paused);
          }
          makeHeartBeat(_position.value.inSeconds, type: 'status');
        }),
        videoPlayerController!.stream.completed.listen((event) {
          if (event) {
            playerStatus.status.value = PlayerStatus.completed;

            /// 触发回调事件
            for (var element in _statusListeners) {
              element(PlayerStatus.completed);
            }
          } else {
            // playerStatus.status.value = PlayerStatus.playing;
          }
          makeHeartBeat(_position.value.inSeconds, type: 'status');
        }),
        videoPlayerController!.stream.position.listen((event) {
          _position.value = event;
          if (!isSliderMoving.value) {
            _sliderPosition.value = event;
          }

          /// 触发回调事件
          for (var element in _positionListeners) {
            element();
          }
          makeHeartBeat(event.inSeconds);
        }),
        videoPlayerController!.stream.duration.listen((event) {
          duration.value = event;
        }),
        videoPlayerController!.stream.buffer.listen((event) {
          _buffered.value = event;
        }),
        videoPlayerController!.stream.buffering.listen((event) {
          isBuffering.value = event;
        }),
        // videoPlayerController!.stream.volume.listen((event) {
        //   if (!mute.value && _volumeBeforeMute != event) {
        //     _volumeBeforeMute = event / 100;
        //   }
        // }),
      ],
    );
  }

  /// 移除事件监听
  void removeListeners() {
    for (final s in subscriptions) {
      s.cancel();
    }
  }

  /// 跳转至指定位置
  Future<void> seekTo(Duration position, {type = 'seek'}) async {
    // if (position >= duration.value) {
    //   position = duration.value - const Duration(milliseconds: 100);
    // }
    if (position < Duration.zero) {
      position = Duration.zero;
    }
    _position.value = position;
    if (duration.value.inSeconds != 0) {
      if (type != 'slider') {
        /// 拖动进度条调节时，不等待第一帧，防止抖动
        await _videoPlayerController!.stream.buffer.first;
      }
      await _videoPlayerController?.seek(position);
      // if (playerStatus.stopped) {
      //   play();
      // }
    } else {
      _timerForSeek?.cancel();
      _timerForSeek =
          Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
        //_timerForSeek = null;
        if (duration.value.inSeconds != 0) {
          await _videoPlayerController?.seek(position);
          // if (playerStatus.stopped) {
          //   play();
          // }
          t.cancel();
          //_timerForSeek = null;
        }
      });
    }
  }

  /// 设置倍速
  Future<void> setPlaybackSpeed(double speed) async {
    await _videoPlayerController?.setRate(speed);
    _playbackSpeed.value = speed;
  }

  /// 设置倍速
  Future<void> togglePlaybackSpeed() async {
    List<double> allowedSpeeds =
        PlaySpeed.values.map<double>((e) => e.value).toList();
    int index = allowedSpeeds.indexOf(_playbackSpeed.value);
    if (index < allowedSpeeds.length - 1) {
      setPlaybackSpeed(allowedSpeeds[index + 1]);
    } else {
      setPlaybackSpeed(allowedSpeeds[0]);
    }
  }

  /// 播放视频
  Future<void> play({bool repeat = false, bool hideControls = true}) async {
    // repeat为true，将从头播放
    if (repeat) {
      await seekTo(Duration.zero);
    }
    await _videoPlayerController?.play();

    await getCurrentVolume();
    await getCurrentBrightness();

    playerStatus.status.value = PlayerStatus.playing;
    // screenManager.setOverlays(false);

    // 播放时自动隐藏控制条
    if (hideControls) {
      _hideTaskControls();
    }
  }

  /// 暂停播放
  Future<void> pause({bool notify = true}) async {
    await _videoPlayerController?.pause();
    playerStatus.status.value = PlayerStatus.paused;
  }

  /// 更改播放状态
  Future<void> togglePlay() async {
    feedBack();
    if (playerStatus.playing) {
      pause();
    } else {
      play();
    }
  }

  /// 隐藏控制条
  void _hideTaskControls() {
    _timer = Timer(const Duration(milliseconds: 3000), () {
      if (!isSliderMoving.value) {
        controls = false;
      }
      _timer = null;
    });
  }

  /// 调整播放时间
  onChangedSlider(double v) {
    _sliderPosition.value = Duration(seconds: v.floor());
  }

  void onChangedSliderStart() {
    _isSliderMoving.value = true;
  }

  void onUodatedSliderProgress(Duration value) {
    _sliderTempPosition.value = value;
    _sliderPosition.value = value;
  }

  void onChangedSliderEnd() {
    feedBack();
    _isSliderMoving.value = false;
    _hideTaskControls();
  }

  /// 音量
  Future<void> getCurrentVolume() async {
    // mac try...catch
    try {
      _currentVolume.value = (await FlutterVolumeController.getVolume())!;
    } catch (_) {}
  }

  Future<void> setVolume(double volumeNew,
      {bool videoPlayerVolume = false}) async {
    if (volumeNew < 0.0) {
      volumeNew = 0.0;
    } else if (volumeNew > 1.0) {
      volumeNew = 1.0;
    }
    if (volume.value == volumeNew) {
      return;
    }
    volume.value = volumeNew;

    try {
      FlutterVolumeController.showSystemUI = false;
      await FlutterVolumeController.setVolume(volumeNew);
    } catch (err) {
      print(err);
    }
  }

  void volumeUpdated() {
    showVolumeStatus.value = true;
    _timerForShowingVolume?.cancel();
    _timerForShowingVolume = Timer(const Duration(seconds: 1), () {
      showVolumeStatus.value = false;
    });
  }

  /// 亮度
  Future<void> getCurrentBrightness() async {
    try {
      _currentBrightness.value = await ScreenBrightness().current;
    } catch (e) {
      throw 'Failed to get current brightness';
      //return 0;
    }
  }

  Future<void> setBrightness(double brightnes) async {
    try {
      brightness.value = brightnes;
      ScreenBrightness().setScreenBrightness(brightnes);
      // setVideoBrightness();
    } catch (e) {
      throw 'Failed to set brightness';
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      throw 'Failed to reset brightness';
    }
  }

  /// Toggle Change the videofit accordingly
  void toggleVideoFit() {
    videoFitChangedTimer?.cancel();
    videoFitChanged.value = true;
    // 范围内
    List attrs = videoFitType.map((e) => e['attr']).toList();
    if (attrs.indexOf(_videoFit.value) < attrs.length - 1) {
      int index = attrs.indexOf(_videoFit.value);
      _videoFit.value = attrs[index + 1];
      print(videoFitType[index + 1]['desc']);
      SmartDialog.showToast(videoFitType[index + 1]['desc']);
    } else {
      // 默认 contain
      _videoFit.value = videoFitType.first['attr'];
      SmartDialog.showToast(videoFitType.first['desc']);
    }
    videoFitChangedTimer = Timer(const Duration(seconds: 1), () {
      videoFitChangedTimer = null;
      videoFitChanged.value = false;
    });
    print(_videoFit.value);
  }

  /// Change Video Fit accordingly
  void onVideoFitChange(BoxFit fit) {
    _videoFit.value = fit;
  }

  /// 缓存fit
  // Future<void> setVideoFit() async {
  //   videoStorage.put(VideoBoxKey.videoBrightness, _videoFit.value.name);
  // }

  /// 读取fit
  // Future<void> getVideoFit() async {
  //   String fitValue =
  //       videoStorage.get(VideoBoxKey.videoBrightness, defaultValue: 'contain');
  //   _videoFit.value = videoFitType
  //       .firstWhere((element) => element['attr'] == fitValue)['attr'];
  // }

  /// 读取亮度
  // Future<void> getVideoBrightness() async {
  //   double brightnessValue =
  //       videoStorage.get(VideoBoxKey.videoBrightness, defaultValue: 0.5);
  //   setBrightness(brightnessValue);
  // }

  set controls(bool visible) {
    _showControls.value = visible;
    _timer?.cancel();
    if (visible) {
      _hideTaskControls();
    }
  }

  /// 设置长按倍速状态 live模式下禁用
  void setDoubleSpeedStatus(bool val) {
    if (videoType.value == 'live') {
      return;
    }
    _doubleSpeedStatus.value = val;
    double currentSpeed = playbackSpeed;
    if (val) {
      setPlaybackSpeed(currentSpeed * 2);
    } else {
      setPlaybackSpeed(currentSpeed / 2);
    }
  }

  /// 关闭控制栏
  void onLockControl(bool val) {
    feedBack();
    _controlsLock.value = val;
    showControls.value = !val;
  }

  void toggleFullScreen(bool val) {
    _isFullScreen.value = val;
  }

  // 全屏
  Future<void> triggerFullScreen({bool status = true}) async {
    FullScreenMode mode = FullScreenModeCode.fromCode(
        setting.get(SettingBoxKey.fullScreenMode, defaultValue: 0))!;

    if (!isFullScreen.value && status) {
      /// 按照视频宽高比决定全屏方向
      switch (mode) {
        case FullScreenMode.auto:
          if (direction.value == 'horizontal') {
            /// 进入全屏
            await enterFullScreen();
            // 横屏
            await landScape();
          } else {
            // 竖屏
            await verticalScreen();
          }
          break;
        case FullScreenMode.vertical:

          /// 进入全屏
          await enterFullScreen();
          // 横屏
          await verticalScreen();
          break;
        case FullScreenMode.horizontal:

          /// 进入全屏
          await enterFullScreen();
          // 横屏
          await landScape();
          break;
      }

      toggleFullScreen(true);
      var result = await showDialog(
        context: Get.context!,
        useSafeArea: false,
        builder: (context) => Dialog.fullscreen(
          backgroundColor: Colors.black,
          child: PLVideoPlayer(
            controller: this,
            headerControl: headerControl,
          ),
        ),
      );
      if (result == null) {
        // 退出全屏
        exitFullScreen();
        await verticalScreen();
        toggleFullScreen(false);
      }
    } else if (isFullScreen.value) {
      Get.back();
      exitFullScreen();
      await verticalScreen();
      toggleFullScreen(false);
    }
  }

  void addPositionListener(VoidCallback listener) =>
      _positionListeners.add(listener);
  void removePositionListener(VoidCallback listener) =>
      _positionListeners.remove(listener);
  void addStatusLister(Function(PlayerStatus status) listener) {
    _statusListeners.add(listener);
  }

  void removeStatusLister(Function(PlayerStatus status) listener) =>
      _statusListeners.remove(listener);

  /// 截屏
  Future screenshot() async {
    final Uint8List? screenshot =
        await _videoPlayerController!.screenshot(format: 'image/png');
    return screenshot;
  }

  Future<void> videoPlayerClosed() async {
    _timer?.cancel();
    _timerForVolume?.cancel();
    _timerForGettingVolume?.cancel();
    timerForTrackingMouse?.cancel();
    _timerForSeek?.cancel();
    videoFitChangedTimer?.cancel();
  }

  // 记录播放记录
  Future makeHeartBeat(progress, {type = 'playing'}) async {
    if (!_enableHeart) {
      return false;
    }
    // 播放状态变化时，更新
    if (type == 'status') {
      await VideoHttp.heartBeat(
        bvid: _bvid,
        cid: _cid,
        progress:
            playerStatus.status.value == PlayerStatus.completed ? -1 : progress,
      );
    } else
    // 正常播放时，间隔5秒更新一次
    if (progress - _heartDuration >= 5) {
      _heartDuration = progress;
      await VideoHttp.heartBeat(
        bvid: _bvid,
        cid: _cid,
        progress: progress,
      );
    }
  }

  Future<void> dispose({String type = 'single'}) async {
    // 每次减1，最后销毁
    if (type == 'single' && playerCount.value > 1) {
      _playerCount.value -= 1;
      _heartDuration = 0;
      pause();
      return;
    }
    _playerCount.value = 0;
    try {
      _timer?.cancel();
      _timerForVolume?.cancel();
      _timerForGettingVolume?.cancel();
      timerForTrackingMouse?.cancel();
      _timerForSeek?.cancel();
      videoFitChangedTimer?.cancel();
      // _position.close();
      _playerEventSubs?.cancel();
      // _sliderPosition.close();
      // _sliderTempPosition.close();
      // _isSliderMoving.close();
      // _duration.close();
      // _buffered.close();
      // _showControls.close();
      // _controlsLock.close();

      // playerStatus.status.close();
      // dataStatus.status.close();

      removeListeners();
      await _videoPlayerController?.dispose();
      _videoPlayerController = null;
      _instance = null;
      // 关闭所有视频页面恢复亮度
      resetBrightness();
    } catch (err) {
      print(err);
    }
  }
}
