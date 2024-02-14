import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nil/nil.dart';
import 'package:pilipala/plugin/pl_player/controller.dart';
import 'package:pilipala/plugin/pl_player/models/duration.dart';
import 'package:pilipala/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:pilipala/plugin/pl_player/utils.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:screen_brightness/screen_brightness.dart';

import 'models/bottom_progress_behavior.dart';
import 'widgets/app_bar_ani.dart';
import 'widgets/backward_seek.dart';
import 'widgets/bottom_control.dart';
import 'widgets/common_btn.dart';
import 'widgets/forward_seek.dart';

class PLVideoPlayer extends StatefulWidget {
  const PLVideoPlayer({
    required this.controller,
    this.headerControl,
    this.bottomControl,
    this.danmuWidget,
    super.key,
  });

  final PlPlayerController controller;
  final PreferredSizeWidget? headerControl;
  final PreferredSizeWidget? bottomControl;
  final Widget? danmuWidget;

  @override
  State<PLVideoPlayer> createState() => _PLVideoPlayerState();
}

class _PLVideoPlayerState extends State<PLVideoPlayer>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late VideoController videoController;
  final PLVideoPlayerController _ctr = Get.put(PLVideoPlayerController());

  final GlobalKey _playerKey = GlobalKey();
  // bool _mountSeekBackwardButton = false;
  // bool _mountSeekForwardButton = false;
  // bool _hideSeekBackwardButton = false;
  // bool _hideSeekForwardButton = false;

  // double _brightnessValue = 0.0;
  // bool _brightnessIndicator = false;
  Timer? _brightnessTimer;

  // double _volumeValue = 0.0;
  // bool _volumeIndicator = false;
  Timer? _volumeTimer;

  double _distance = 0.0;
  // 初始手指落下位置
  // double _initTapPositoin = 0.0;

  // bool _volumeInterceptEventStream = false;

  Box setting = GStrorage.setting;
  late FullScreenMode mode;
  late int defaultBtmProgressBehavior;
  late bool enableQuickDouble;
  late bool fullScreenGestureReverse;
  late bool enableBackgroundPlay;

  // 用于记录上一次全屏切换手势触发时间，避免误触
  DateTime? lastFullScreenToggleTime;
  // 记录上一次音量调整值作平均，避免音量调整抖动
  double lastVolume = -1.0;

  void onDoubleTapSeekBackward() {
    _ctr.onDoubleTapSeekBackward();
  }

  void onDoubleTapSeekForward() {
    _ctr.onDoubleTapSeekForward();
  }

  // 双击播放、暂停
  void onDoubleTapCenter() {
    final PlPlayerController _ = widget.controller;
    _.videoPlayerController!.playOrPause();
  }

  void doubleTapFuc(String type) {
    if (!enableQuickDouble) {
      onDoubleTapCenter();
      return;
    }
    switch (type) {
      case 'left':
        // 双击左边区域 👈
        onDoubleTapSeekBackward();
        break;
      case 'center':
        onDoubleTapCenter();
        break;
      case 'right':
        // 双击右边区域 👈
        onDoubleTapSeekForward();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    videoController = widget.controller.videoController!;
    widget.controller.headerControl = widget.headerControl;
    widget.controller.bottomControl = widget.bottomControl;
    widget.controller.danmuWidget = widget.danmuWidget;
    defaultBtmProgressBehavior = setting.get(SettingBoxKey.btmProgressBehavior,
        defaultValue: BtmProgresBehavior.values.first.code);
    enableQuickDouble =
        setting.get(SettingBoxKey.enableQuickDouble, defaultValue: true);
    fullScreenGestureReverse = setting.get(SettingBoxKey.fullScreenGestureReverse,
        defaultValue: false);
    enableBackgroundPlay =
        setting.get(SettingBoxKey.enableBackgroundPlay, defaultValue: false);
    Future.microtask(() async {
      try {
        FlutterVolumeController.updateShowSystemUI(true);
        _ctr.volumeValue.value = (await FlutterVolumeController.getVolume())!;
        FlutterVolumeController.addListener((double value) {
          if (mounted && !_ctr.volumeInterceptEventStream.value) {
            _ctr.volumeValue.value = value;
          }
        });
      } catch (_) {}
    });

    Future.microtask(() async {
      try {
        _ctr.brightnessValue.value = await ScreenBrightness().current;
        ScreenBrightness().onCurrentBrightnessChanged.listen((double value) {
          if (mounted) {
            _ctr.brightnessValue.value = value;
          }
        });
      } catch (_) {}
    });
  }

  Future<void> setVolume(double value) async {
    try {
      FlutterVolumeController.updateShowSystemUI(false);
      await FlutterVolumeController.setVolume(value);
    } catch (_) {}
    _ctr.volumeValue.value = value;
    _ctr.volumeIndicator.value = true;
    _ctr.volumeInterceptEventStream.value = true;
    _volumeTimer?.cancel();
    _volumeTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        _ctr.volumeIndicator.value = false;
        _ctr.volumeInterceptEventStream.value = false;
      }
    });
  }

  Future<void> setBrightness(double value) async {
    try {
      await ScreenBrightness().setScreenBrightness(value);
    } catch (_) {}
    _ctr.brightnessIndicator.value = true;
    _brightnessTimer?.cancel();
    _brightnessTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        _ctr.brightnessIndicator.value = false;
      }
    });
    widget.controller.brightness.value = value;
  }

  @override
  void dispose() {
    animationController.dispose();
    FlutterVolumeController.removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PlPlayerController _ = widget.controller;
    final Color colorTheme = Theme.of(context).colorScheme.primary;
    const TextStyle subTitleStyle = TextStyle(
      height: 1.5,
      fontSize: 40.0,
      letterSpacing: 0.0,
      wordSpacing: 0.0,
      color: Color(0xffffffff),
      fontWeight: FontWeight.normal,
      backgroundColor: Color(0xaa000000),
    );
    const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    return Stack(
      fit: StackFit.passthrough,
      key: _playerKey,
      children: <Widget>[
        Obx(
          () => Video(
            controller: videoController,
            controls: NoVideoControls,
            pauseUponEnteringBackgroundMode: !enableBackgroundPlay,
            resumeUponEnteringForegroundMode: true,
            subtitleViewConfiguration: const SubtitleViewConfiguration(
              style: subTitleStyle,
              padding: EdgeInsets.all(24.0),
            ),
            fit: _.videoFit.value,
          ),
        ),

        /// 长按倍速 toast
        Obx(
          () => Align(
            alignment: Alignment.topCenter,
            child: FractionalTranslation(
              translation: const Offset(0.0, 0.3), // 上下偏移量（负数向上偏移）
              child: AnimatedOpacity(
                curve: Curves.easeInOut,
                opacity: _.doubleSpeedStatus.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0x88000000),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    height: 32.0,
                    width: 70.0,
                    child: const Center(
                      child: Text(
                        '倍速中',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    )),
              ),
            ),
          ),
        ),

        /// 时间进度 toast
        Obx(
          () => Align(
            alignment: Alignment.topCenter,
            child: FractionalTranslation(
              translation: const Offset(0.0, 1.0), // 上下偏移量（负数向上偏移）
              child: AnimatedOpacity(
                curve: Curves.easeInOut,
                opacity: _.isSliderMoving.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: IntrinsicWidth(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0x88000000),
                      borderRadius: BorderRadius.circular(64.0),
                    ),
                    height: 34.0,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          return Text(
                            _.sliderTempPosition.value.inMinutes >= 60
                                ? printDurationWithHours(
                                    _.sliderTempPosition.value)
                                : printDuration(_.sliderTempPosition.value),
                            style: textStyle,
                          );
                        }),
                        const SizedBox(width: 2),
                        const Text('/', style: textStyle),
                        const SizedBox(width: 2),
                        Obx(
                          () => Text(
                            _.duration.value.inMinutes >= 60
                                ? printDurationWithHours(_.duration.value)
                                : printDuration(_.duration.value),
                            style: textStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        /// 音量🔊 控制条展示
        Obx(
          () => Align(
            child: AnimatedOpacity(
              curve: Curves.easeInOut,
              opacity: _ctr.volumeIndicator.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0x88000000),
                  borderRadius: BorderRadius.circular(64.0),
                ),
                height: 34.0,
                width: 70.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 34.0,
                      width: 28.0,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        _ctr.volumeValue.value == 0.0
                            ? Icons.volume_off
                            : _ctr.volumeValue.value < 0.5
                                ? Icons.volume_down
                                : Icons.volume_up,
                        color: const Color(0xFFFFFFFF),
                        size: 20.0,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${(_ctr.volumeValue.value * 100.0).round()}%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6.0),
                  ],
                ),
              ),
            ),
          ),
        ),

        /// 亮度🌞 控制条展示
        Obx(
          () => Align(
            child: AnimatedOpacity(
              curve: Curves.easeInOut,
              opacity: _ctr.brightnessIndicator.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0x88000000),
                  borderRadius: BorderRadius.circular(64.0),
                ),
                height: 34.0,
                width: 70.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 30.0,
                      width: 28.0,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        _ctr.brightnessValue.value < 1.0 / 3.0
                            ? Icons.brightness_low
                            : _ctr.brightnessValue.value < 2.0 / 3.0
                                ? Icons.brightness_medium
                                : Icons.brightness_high,
                        color: const Color(0xFFFFFFFF),
                        size: 18.0,
                      ),
                    ),
                    const SizedBox(width: 2.0),
                    Expanded(
                      child: Text(
                        '${(_ctr.brightnessValue.value * 100.0).round()}%',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6.0),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Obx(() {
        //   if (_.buffered.value == Duration.zero) {
        //     return Positioned.fill(
        //       child: Container(
        //         color: Colors.black,
        //         child: Center(
        //           child: Image.asset(
        //             'assets/images/loading.gif',
        //             height: 25,
        //           ),
        //         ),
        //       ),
        //     );
        //   } else {
        //     return Container();
        //   }
        // }),

        /// 弹幕面板
        if (widget.danmuWidget != null)
          Positioned.fill(top: 4, child: widget.danmuWidget!),

        /// 手势
        Positioned.fill(
          left: 16,
          top: 25,
          right: 15,
          bottom: 15,
          child: GestureDetector(
            onTap: () {
              _.controls = !_.showControls.value;
            },
            onDoubleTapDown: (TapDownDetails details) {
              // live模式下禁用 锁定时🔒禁用
              if (_.videoType.value == 'live' || _.controlsLock.value) {
                return;
              }
              RenderBox renderBox = _playerKey.currentContext!.findRenderObject() as RenderBox;
              final double totalWidth = renderBox.size.width;
              final double tapPosition = details.localPosition.dx;
              final double sectionWidth = totalWidth / 3;
              String type = 'left';
              if (tapPosition < sectionWidth) {
                type = 'left';
              } else if (tapPosition < sectionWidth * 2) {
                type = 'center';
              } else {
                type = 'right';
              }
              doubleTapFuc(type);
            },
            onLongPressStart: (LongPressStartDetails detail) {
              feedBack();
              _.setDoubleSpeedStatus(true);
            },
            onLongPressEnd: (LongPressEndDetails details) {
              _.setDoubleSpeedStatus(false);
            },

            /// 水平位置 快进 live模式下禁用
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              // live模式下禁用 锁定时🔒禁用
              if (_.videoType.value == 'live' || _.controlsLock.value) {
                return;
              }
              // final double tapPosition = details.localPosition.dx;
              final int curSliderPosition =
                  _.sliderPosition.value.inMilliseconds;
              RenderBox renderBox = _playerKey.currentContext!.findRenderObject() as RenderBox;
              final double scale = 90000 / renderBox.size.width;
              final Duration pos = Duration(
                  milliseconds:
                      curSliderPosition + (details.delta.dx * scale).round());
              final Duration result =
                  pos.clamp(Duration.zero, _.duration.value);
              _.onUpdatedSliderProgress(result);
              _.onChangedSliderStart();
              // _initTapPositoin = tapPosition;
            },
            onHorizontalDragEnd: (DragEndDetails details) {
              if (_.videoType.value == 'live' || _.controlsLock.value) {
                return;
              }
              _.onChangedSliderEnd();
              _.seekTo(_.sliderPosition.value, type: 'slider');
            },
            // 垂直方向 音量/亮度调节
            onVerticalDragUpdate: (DragUpdateDetails details) async {
              RenderBox renderBox = _playerKey.currentContext!.findRenderObject() as RenderBox;
              final double totalWidth = renderBox.size.width;
              final double tapPosition = details.localPosition.dx;
              final double sectionWidth = totalWidth / 3;
              final double delta = details.delta.dy;

              /// 锁定时禁用
              if (_.controlsLock.value) {
                return;
              }
              if (lastFullScreenToggleTime != null &&
                  DateTime.now().difference(lastFullScreenToggleTime!) <
                      const Duration(milliseconds: 500)) {
                return;
              }
              if (tapPosition < sectionWidth) {
                // 左边区域 👈
                final double level = renderBox.size.height * 3;
                final double brightness =
                    _ctr.brightnessValue.value - delta / level;
                final double result = brightness.clamp(0.0, 1.0);
                setBrightness(result);
              } else if (tapPosition < sectionWidth * 2) {
                // 全屏
                final double dy = details.delta.dy;
                const double threshold = 7.0; // 滑动阈值
                void fullScreenTrigger(bool status) async {
                  lastFullScreenToggleTime = DateTime.now();
                  await widget.controller.triggerFullScreen(status: status);
                }
                if (dy > _distance && dy > threshold) {
                  // 下滑退出全屏/进入全屏
                  if (_.isFullScreen.value ^ fullScreenGestureReverse) {
                    fullScreenTrigger(fullScreenGestureReverse);
                  }
                  _distance = 0.0;
                } else if (dy < _distance && dy < -threshold) {
                  // 上划进入全屏/退出全屏
                  if (!_.isFullScreen.value ^ fullScreenGestureReverse) {
                    fullScreenTrigger(!fullScreenGestureReverse);
                  }
                  _distance = 0.0;
                }
                _distance = dy;
              } else {
                // 右边区域 👈
                final double level = renderBox.size.height * 0.5;
                if(lastVolume < 0) {
                  lastVolume = _ctr.volumeValue.value;
                }
                final double volume = (lastVolume + _ctr.volumeValue.value - delta / level)/2;
                final double result = volume.clamp(0.0, 1.0);
                lastVolume = result;
                setVolume(result);
              }
            },
            onVerticalDragEnd: (DragEndDetails details) {},
          ),
        ),

        // 头部、底部控制条
        SafeArea(
          top: false,
          bottom: false,
          child: Obx(
            () => Column(
              children: [
                if (widget.headerControl != null || _.headerControl != null)
                  ClipRect(
                    child: AppBarAni(
                      controller: animationController,
                      visible: !_.controlsLock.value && _.showControls.value,
                      position: 'top',
                      child: widget.headerControl ?? _.headerControl!,
                    ),
                  ),
                const Spacer(),
                ClipRect(
                  child: AppBarAni(
                    controller: animationController,
                    visible: !_.controlsLock.value && _.showControls.value,
                    position: 'bottom',
                    child: widget.bottomControl ??
                        BottomControl(
                            controller: widget.controller,
                            triggerFullScreen:
                                widget.controller.triggerFullScreen),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// 进度条 live模式下禁用

        Obx(
          () {
            final int value = _.sliderPositionSeconds.value;
            final int max = _.durationSeconds.value;
            final int buffer = _.bufferedSeconds.value;
            if (_.showControls.value) {
              return Container();
            }
            if (defaultBtmProgressBehavior ==
                BtmProgresBehavior.alwaysHide.code) {
              return nil;
            }
            if (defaultBtmProgressBehavior ==
                    BtmProgresBehavior.onlyShowFullScreen.code &&
                !_.isFullScreen.value) {
              return nil;
            } else if (defaultBtmProgressBehavior ==
                    BtmProgresBehavior.onlyHideFullScreen.code &&
                _.isFullScreen.value) {
              return nil;
            }

            if (_.videoType.value == 'live') {
              return const SizedBox();
            }
            if (value > max || max <= 0) {
              return nil;
            }
            return Positioned(
              bottom: -1.5,
              left: 0,
              right: 0,
              child: ProgressBar(
                progress: Duration(seconds: value),
                buffered: Duration(seconds: buffer),
                total: Duration(seconds: max),
                progressBarColor: colorTheme,
                baseBarColor: Colors.white.withOpacity(0.2),
                bufferedBarColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.4),
                timeLabelLocation: TimeLabelLocation.none,
                thumbColor: colorTheme,
                barHeight: 3,
                thumbRadius: 0.0,
                // onDragStart: (duration) {
                //   _.onChangedSliderStart();
                // },
                // onDragEnd: () {
                //   _.onChangedSliderEnd();
                // },
                // onDragUpdate: (details) {
                //   print(details);
                // },
                // onSeek: (duration) {
                //   feedBack();
                //   _.onChangedSlider(duration.inSeconds.toDouble());
                //   _.seekTo(duration);
                // },
              ),
              // SlideTransition(
              //     position: Tween<Offset>(
              //       begin: Offset.zero,
              //       end: const Offset(0, -1),
              //     ).animate(CurvedAnimation(
              //       parent: animationController,
              //       curve: Curves.easeInOut,
              //     )),
              //     child: ),
            );
          },
        ),

        // 锁
        Obx(
          () => Visibility(
            visible: _.videoType.value != 'live',
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionalTranslation(
                translation: const Offset(1, 0.0),
                child: Visibility(
                  visible: _.showControls.value,
                  child: ComBtn(
                    icon: Icon(
                      _.controlsLock.value
                          ? FontAwesomeIcons.lock
                          : FontAwesomeIcons.lockOpen,
                      size: 15,
                      color: Colors.white,
                    ),
                    fuc: () => _.onLockControl(!_.controlsLock.value),
                  ),
                ),
              ),
            ),
          ),
        ),
        //
        Obx(() {
          if (_.dataStatus.loading || _.isBuffering.value) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.black26, Colors.transparent],
                  ),
                ),
                child: Image.asset(
                  'assets/images/loading.gif',
                  height: 25,
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        }),

        /// 点击 快进/快退
        Obx(
          () => Visibility(
            visible: _ctr.mountSeekBackwardButton.value ||
                _ctr.mountSeekForwardButton.value,
            child: Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    child: _ctr.mountSeekBackwardButton.value
                        ? TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0.0,
                              end:
                                  _ctr.hideSeekBackwardButton.value ? 0.0 : 1.0,
                            ),
                            duration: const Duration(milliseconds: 500),
                            builder: (BuildContext context, double value,
                                    Widget? child) =>
                                Opacity(
                              opacity: value,
                              child: child,
                            ),
                            onEnd: () {
                              if (_ctr.hideSeekBackwardButton.value) {
                                _ctr.hideSeekBackwardButton.value = false;
                                _ctr.mountSeekBackwardButton.value = false;
                              }
                            },
                            child: BackwardSeekIndicator(
                              onChanged: (Duration value) {
                                // _seekBarDeltaValueNotifier.value = -value;
                              },
                              onSubmitted: (Duration value) {
                                _ctr.hideSeekBackwardButton.value = true;
                                final Player player =
                                    widget.controller.videoPlayerController!;
                                Duration result = player.state.position - value;
                                result = result.clamp(
                                  Duration.zero,
                                  player.state.duration,
                                );
                                player.seek(result);
                                widget.controller.play();
                              },
                            ),
                          )
                        : nil,
                  ),
                  const Spacer(),
                  // Expanded(
                  //   child: SizedBox(
                  //     width: context.width / 4,
                  //   ),
                  // ),
                  Expanded(
                    child: _ctr.mountSeekForwardButton.value
                        ? TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0.0,
                              end: _ctr.hideSeekForwardButton.value ? 0.0 : 1.0,
                            ),
                            duration: const Duration(milliseconds: 500),
                            builder: (BuildContext context, double value,
                                    Widget? child) =>
                                Opacity(
                              opacity: value,
                              child: child,
                            ),
                            onEnd: () {
                              if (_ctr.hideSeekForwardButton.value) {
                                _ctr.hideSeekForwardButton.value = false;
                                _ctr.mountSeekForwardButton.value = false;
                              }
                            },
                            child: ForwardSeekIndicator(
                              onChanged: (Duration value) {
                                // _seekBarDeltaValueNotifier.value = value;
                              },
                              onSubmitted: (Duration value) {
                                _ctr.hideSeekForwardButton.value = true;
                                final Player player =
                                    widget.controller.videoPlayerController!;
                                Duration result = player.state.position + value;
                                result = result.clamp(
                                  Duration.zero,
                                  player.state.duration,
                                );
                                player.seek(result);
                                widget.controller.play();
                              },
                            ),
                          )
                        : nil,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PLVideoPlayerController extends GetxController {
  RxBool mountSeekBackwardButton = false.obs;
  RxBool mountSeekForwardButton = false.obs;
  RxBool hideSeekBackwardButton = false.obs;
  RxBool hideSeekForwardButton = false.obs;

  RxDouble brightnessValue = 0.0.obs;
  RxBool brightnessIndicator = false.obs;

  RxDouble volumeValue = 0.0.obs;
  RxBool volumeIndicator = false.obs;

  RxDouble distance = 0.0.obs;
  // 初始手指落下位置
  RxDouble initTapPositoin = 0.0.obs;

  RxBool volumeInterceptEventStream = false.obs;

  // 双击快进 展示样式
  void onDoubleTapSeekForward() {
    mountSeekForwardButton.value = true;
  }

  void onDoubleTapSeekBackward() {
    mountSeekBackwardButton.value = true;
  }
}
