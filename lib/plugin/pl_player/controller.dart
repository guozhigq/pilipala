import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:pilipala/plugin/pl_player/models/data_source.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'models/data_status.dart';
import 'models/play_speed.dart';
import 'models/play_status.dart';

Box videoStorage = GStrorage.video;

class PlPlayerController {
  Player? _videoPlayerController;
  VideoController? _videoController;

  // 流事件  监听播放状态变化
  StreamSubscription? _playerEventSubs;

  /// [playerStatus] has a [status] observable
  final PlPlayerStatus playerStatus = PlPlayerStatus();

  ///
  final PlPlayerDataStatus dataStatus = PlPlayerDataStatus();

  bool controlsEnabled = true;

  /// 响应数据
  // 播放位置
  final Rx<Duration> _position = Rx(Duration.zero);
  final Rx<Duration> _sliderPosition = Rx(Duration.zero);
  final Rx<Duration> _duration = Rx(Duration.zero);
  final Rx<Duration> _buffered = Rx(Duration.zero);

  final Rx<double> _playbackSpeed = 1.0.obs;
  final Rx<double> _currentVolume = 1.0.obs;
  final Rx<double> _currentBrightness = 0.0.obs;

  final Rx<bool> _mute = false.obs;
  final Rx<bool> _showControls = false.obs;
  final Rx<bool> _showVolumeStatus = false.obs;
  final Rx<bool> _showBrightnessStatus = false.obs;
  final Rx<bool> _doubleSpeedStatus = false.obs;
  final Rx<bool> _controlsClose = false.obs;

  Rx<bool> videoFitChanged = false.obs;
  final Rx<BoxFit> _videoFit = Rx(BoxFit.fill);

  ///
  bool _isSliderMoving = false;
  PlaylistMode _looping = PlaylistMode.none;
  bool _autoPlay = false;
  final bool _listenersInitialized = false;

  Timer? _timer;
  Timer? _timerForSeek;
  Timer? _timerForVolume;
  Timer? _timerForShowingVolume;
  Timer? _timerForGettingVolume;
  Timer? timerForTrackingMouse;
  Timer? videoFitChangedTimer;

  // final Durations durations;

  List<BoxFit> fits = [
    BoxFit.contain,
    BoxFit.cover,
    BoxFit.fill,
    BoxFit.fitHeight,
    BoxFit.fitWidth,
    BoxFit.scaleDown
  ];

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

  /// 进度条位置及监听
  Rx<Duration> get sliderPosition => _sliderPosition;
  Stream<Duration> get onSliderPositionChanged => _sliderPosition.stream;

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

  Rx<bool> get controlsClose => _controlsClose;

  PlPlayerController({
    this.controlsEnabled = true,
    this.fits = const [
      BoxFit.contain,
      BoxFit.cover,
      BoxFit.fill,
      BoxFit.fitHeight,
      BoxFit.fitWidth,
      BoxFit.scaleDown
    ],
  }) {
    controlsEnabled = controlsEnabled;
    _playerEventSubs = onPlayerStatusChanged.listen((PlayerStatus status) {
      if (status == PlayerStatus.playing) {
        WakelockPlus.enable();
      } else {
        WakelockPlus.enable();
      }
    });
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
  }) async {
    try {
      _autoPlay = autoplay;
      _looping = looping;
      // 初始化视频时长
      _duration.value = duration ?? Duration.zero;
      // 初始化视频倍速
      _playbackSpeed.value = speed;
      // 初始化数据加载状态
      dataStatus.status.value = DataStatus.loading;

      if (_videoPlayerController != null &&
          _videoPlayerController!.state.playing) {
        await pause(notify: false);
      }

      // 配置Player 音轨、字幕等等
      _videoPlayerController = await _createVideoController(
          dataSource, _looping, enableHA, width, height);
      // 获取视频时长 00:00
      _duration.value = _videoPlayerController!.state.duration;
      // 数据加载完成
      dataStatus.status.value = DataStatus.loaded;

      await _initializePlayer(seekTo: seekTo);

      // listen the video player events
      if (!_listenersInitialized) {
        startListeners();
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
        }),
        videoPlayerController!.stream.completed.listen((event) {
          if (event) {
            playerStatus.status.value = PlayerStatus.completed;
          } else {
            // playerStatus.status.value = PlayerStatus.playing;
          }
        }),
        videoPlayerController!.stream.position.listen((event) {
          _position.value = event;
          if (!_isSliderMoving) {
            _sliderPosition.value = event;
          }
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
  Future<void> seekTo(Duration position) async {
    // if (position >= duration.value) {
    //   position = duration.value - const Duration(milliseconds: 100);
    // }
    if (position < Duration.zero) {
      position = Duration.zero;
    }
    _position.value = position;
    print('seek 🌹duration : ${duration.value.inSeconds}');

    if (duration.value.inSeconds != 0) {
      // await _videoPlayerController!.stream.buffer.first;
      await _videoPlayerController?.seek(position);
      // if (playerStatus.stopped) {
      //   play();
      // }
    } else {
      print('🌹🌹');
      _timerForSeek?.cancel();
      _timerForSeek =
          Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
        //_timerForSeek = null;
        if (duration.value.inSeconds != 0) {
          print('🌹🌹🌹');
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
      if (!_isSliderMoving) {
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
    feedBack();
    _isSliderMoving = true;
  }

  void onChangedSliderEnd() {
    _isSliderMoving = false;
    _hideTaskControls();
  }

  /// 音量
  Future<void> getCurrentVolume() async {
    _currentVolume.value = await VolumeController().getVolume();
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
      VolumeController().setVolume(volumeNew, showSystemUI: false);
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
      setVideoBrightness();
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
    if (fits.indexOf(_videoFit.value) < fits.length - 1) {
      _videoFit.value = fits[fits.indexOf(_videoFit.value) + 1];
    } else {
      _videoFit.value = fits[0];
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
  Future<void> setVideoFit() async {
    videoStorage.put(VideoBoxKey.videoBrightness, _videoFit.value.name);
  }

  /// 读取fit
  Future<void> getVideoFit() async {
    String fitValue = videoStorage.get(VideoBoxKey.videoBrightness,
        defaultValue: 'fitHeight');
    _videoFit.value = fits.firstWhere((element) => element.name == fitValue);
  }

  /// 缓存亮度
  Future<void> setVideoBrightness() async {}

  /// 读取亮度
  Future<void> getVideoBrightness() async {
    double brightnessValue =
        videoStorage.get(VideoBoxKey.videoBrightness, defaultValue: 0.5);
    setBrightness(brightnessValue);
  }

  set controls(bool visible) {
    _showControls.value = visible;
    _timer?.cancel();
    if (visible) {
      _hideTaskControls();
    }
  }

  /// 设置长按倍速状态
  void setDoubleSpeedStatus(bool val) {
    _doubleSpeedStatus.value = val;
  }

  /// 关闭控制栏
  void onCloseControl(bool val) {
    feedBack();
    _controlsClose.value = val;
    showControls.value = !val;
  }

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

  Future<void> dispose() async {
    _timer?.cancel();
    _timerForVolume?.cancel();
    _timerForGettingVolume?.cancel();
    timerForTrackingMouse?.cancel();
    _timerForSeek?.cancel();
    videoFitChangedTimer?.cancel();
    _position.close();
    _playerEventSubs?.cancel();
    _sliderPosition.close();
    _duration.close();
    _buffered.close();
    _showControls.close();
    _controlsClose.close();

    playerStatus.status.close();
    dataStatus.status.close();

    removeListeners();
    await _videoPlayerController?.dispose();
    _videoPlayerController = null;
  }
}
