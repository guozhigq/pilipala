import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:pilipala/models/common/gesture_mode.dart';
import 'package:pilipala/plugin/pl_player/controller.dart';
import 'package:pilipala/plugin/pl_player/models/duration.dart';
import 'package:pilipala/plugin/pl_player/models/fullscreen_mode.dart';
import 'package:pilipala/plugin/pl_player/utils.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../utils/global_data_cache.dart';
import 'models/bottom_control_type.dart';
import 'models/bottom_progress_behavior.dart';
import 'panels/seek_panel.dart';
import 'widgets/app_bar_ani.dart';
import 'widgets/bottom_control.dart';
import 'widgets/common_btn.dart';
import 'widgets/control_bar.dart';
import 'widgets/play_pause_btn.dart';

class PLVideoPlayer extends StatefulWidget {
  const PLVideoPlayer({
    required this.controller,
    this.headerControl,
    this.bottomControl,
    this.danmuWidget,
    this.bottomList,
    this.customWidget,
    this.customWidgets,
    this.showEposideCb,
    this.fullScreenCb,
    this.alignment = Alignment.center,
    super.key,
  });

  final PlPlayerController controller;
  final PreferredSizeWidget? headerControl;
  final PreferredSizeWidget? bottomControl;
  final Widget? danmuWidget;
  final List<BottomControlType>? bottomList;
  // List<Widget> or Widget

  final Widget? customWidget;
  final List<Widget>? customWidgets;
  final Function? showEposideCb;
  final Function? fullScreenCb;
  final Alignment? alignment;

  @override
  State<PLVideoPlayer> createState() => _PLVideoPlayerState();
}

class _PLVideoPlayerState extends State<PLVideoPlayer>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late VideoController videoController;

  final RxBool _mountSeekBackwardButton = false.obs;
  final RxBool _mountSeekForwardButton = false.obs;
  final RxBool _hideSeekBackwardButton = true.obs;
  final RxBool _hideSeekForwardButton = true.obs;

  final RxDouble _brightnessValue = 0.0.obs;
  final RxBool _brightnessIndicator = false.obs;
  Timer? _brightnessTimer;

  final RxDouble _volumeValue = 0.0.obs;
  final RxBool _volumeIndicator = false.obs;
  Timer? _volumeTimer;

  final RxDouble _distance = 0.0.obs;
  final RxBool _volumeInterceptEventStream = false.obs;

  Box setting = GStorage.setting;
  late FullScreenMode mode;
  late int defaultBtmProgressBehavior;
  late bool enableQuickDouble;
  late bool enableBackgroundPlay;
  late double screenWidth;
  final FullScreenGestureMode fullScreenGestureMode =
      GlobalDataCache.fullScreenGestureMode;

  // 用于记录上一次全屏切换手势触发时间，避免误触
  DateTime? lastFullScreenToggleTime;

  void onDoubleTapSeekBackward() {
    _mountSeekBackwardButton.value = true;
    _hideSeekBackwardButton.value = false;
  }

  void onDoubleTapSeekForward() {
    _mountSeekForwardButton.value = true;
    _hideSeekForwardButton.value = false;
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
    screenWidth = Get.size.width;
    animationController = AnimationController(
      vsync: this,
      duration: GlobalDataCache.enablePlayerControlAnimation
          ? const Duration(milliseconds: 150)
          : const Duration(milliseconds: 10),
    );
    videoController = widget.controller.videoController!;
    widget.controller.headerControl = widget.headerControl;
    widget.controller.bottomControl = widget.bottomControl;
    widget.controller.danmuWidget = widget.danmuWidget;
    defaultBtmProgressBehavior = setting.get(SettingBoxKey.btmProgressBehavior,
        defaultValue: BtmProgresBehavior.values.first.code);
    enableQuickDouble =
        setting.get(SettingBoxKey.enableQuickDouble, defaultValue: true);
    enableBackgroundPlay =
        setting.get(SettingBoxKey.enableBackgroundPlay, defaultValue: false);
    Future.microtask(() async {
      try {
        FlutterVolumeController.updateShowSystemUI(true);
        _volumeValue.value = (await FlutterVolumeController.getVolume())!;
        FlutterVolumeController.addListener((double value) {
          if (mounted && !_volumeInterceptEventStream.value) {
            _volumeValue.value = value;
          }
        });
      } catch (_) {}
    });

    Future.microtask(() async {
      try {
        _brightnessValue.value = await ScreenBrightness().current;
        ScreenBrightness().onCurrentBrightnessChanged.listen((double value) {
          if (mounted) {
            _brightnessValue.value = value;
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
    _volumeValue.value = value;
    _volumeIndicator.value = true;
    _volumeInterceptEventStream.value = true;
    _volumeTimer?.cancel();
    _volumeTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        _volumeIndicator.value = false;
        _volumeInterceptEventStream.value = false;
      }
    });
  }

  Future<void> setBrightness(double value) async {
    try {
      await ScreenBrightness().setScreenBrightness(value);
    } catch (_) {}
    _brightnessIndicator.value = true;
    _brightnessTimer?.cancel();
    _brightnessTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        _brightnessIndicator.value = false;
      }
    });
    widget.controller.brightness.value = value;
  }

  bool isUsingFullScreenGestures(double tapPosition, double sectionWidth) {
    return fullScreenGestureMode != FullScreenGestureMode.none &&
        tapPosition < sectionWidth * 2;
  }

  @override
  void dispose() {
    animationController.dispose();
    FlutterVolumeController.removeListener();
    super.dispose();
  }

  // 动态构建底部控制条
  List<Widget> buildBottomControl() {
    const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    final PlPlayerController _ = widget.controller;
    Map<BottomControlType, Widget> videoProgressWidgets = {
      /// 上一集
      BottomControlType.pre: ComBtn(
        icon: const Icon(
          Icons.skip_previous_rounded,
          size: 21,
          color: Colors.white,
        ),
        fuc: () {},
      ),

      /// 播放暂停
      BottomControlType.playOrPause: PlayOrPauseButton(
        controller: _,
      ),

      /// 下一集
      BottomControlType.next: ComBtn(
        icon: const Icon(
          Icons.skip_next_rounded,
          size: 21,
          color: Colors.white,
        ),
        fuc: () {},
      ),

      /// 时间进度
      BottomControlType.time: Row(
        children: [
          const SizedBox(width: 8),
          Obx(() {
            return Text(
              _.durationSeconds.value >= 3600
                  ? printDurationWithHours(
                      Duration(seconds: _.positionSeconds.value))
                  : printDuration(Duration(seconds: _.positionSeconds.value)),
              style: textStyle,
            );
          }),
          const SizedBox(width: 2),
          const Text('/', style: textStyle),
          const SizedBox(width: 2),
          Obx(
            () => Text(
              _.durationSeconds.value >= 3600
                  ? printDurationWithHours(
                      Duration(seconds: _.durationSeconds.value))
                  : printDuration(Duration(seconds: _.durationSeconds.value)),
              style: textStyle,
            ),
          ),
        ],
      ),

      /// 空白占位
      BottomControlType.space: const Spacer(),

      /// 选集
      BottomControlType.episode: SizedBox(
        height: 30,
        width: 30,
        child: TextButton(
          onPressed: () {
            widget.showEposideCb?.call();
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          ),
          child: const Text('选集', style: textStyle),
        ),
      ),

      /// 画面比例
      BottomControlType.fit: SizedBox(
        width: 45,
        height: 30,
        child: TextButton(
          onPressed: () => _.toggleVideoFit('press'),
          onLongPress: () => _.toggleVideoFit('longPress'),
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          ),
          child: Obx(
            () => Text(_.videoFitDEsc.value, style: textStyle),
          ),
        ),
      ),

      /// 播放速度
      BottomControlType.speed: SizedBox(
        width: 45,
        height: 34,
        child: PopupMenuButton<double>(
          tooltip: '更改播放速度',
          onSelected: (double value) {
            _.setPlaybackSpeed(value);
          },
          initialValue: _.playbackSpeed,
          color: Colors.black.withOpacity(0.8),
          itemBuilder: (BuildContext context) {
            return _.speedsList.map((double speed) {
              return PopupMenuItem<double>(
                height: 40,
                padding: const EdgeInsets.only(left: 20),
                value: speed,
                child: Text('${speed}x', style: textStyle),
              );
            }).toList();
          },
          child: Container(
            width: 45,
            height: 34,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 4),
            child: Obx(
              () => Text('${_.playbackSpeed.toString()}x', style: textStyle),
            ),
          ),
        ),
      ),

      /// 全屏
      BottomControlType.fullscreen: ComBtn(
        icon: Obx(
          () => Image.asset(
            _.isFullScreen.value
                ? 'assets/images/video/fullscreen_exit.png'
                : 'assets/images/video/fullscreen.png',
            width: 19,
            color: Colors.white,
          ),
        ),
        fuc: () {
          _.triggerFullScreen(status: !_.isFullScreen.value);
          widget.fullScreenCb?.call(!_.isFullScreen.value);
        },
      ),
    };
    final List<Widget> list = [];
    List<BottomControlType> userSpecifyItem = widget.bottomList ??
        [
          BottomControlType.playOrPause,
          BottomControlType.time,
          BottomControlType.space,
          BottomControlType.fit,
          BottomControlType.speed,
          BottomControlType.fullscreen,
        ];
    for (var i = 0; i < userSpecifyItem.length; i++) {
      if (userSpecifyItem[i] == BottomControlType.custom) {
        if (widget.customWidget != null && widget.customWidget is Widget) {
          list.add(widget.customWidget!);
        }
        if (widget.customWidgets != null && widget.customWidgets!.isNotEmpty) {
          list.addAll(widget.customWidgets!);
        }
      } else {
        list.add(videoProgressWidgets[userSpecifyItem[i]]!);
      }
    }
    return list;
  }

  void _handleSubmittedCallback(String type, Duration value) {
    final PlPlayerController _ = widget.controller;
    final Player player =
        _.videoPlayerController ?? widget.controller.videoPlayerController!;
    late Duration result;

    switch (type) {
      case 'backward':
        _hideSeekBackwardButton.value = true;
        result = player.state.position - value;
        break;
      case 'forward':
        _hideSeekForwardButton.value = true;
        result = player.state.position + value;
        break;
    }
    _mountSeekBackwardButton.value = false;
    _mountSeekForwardButton.value = false;
    result = result.clamp(Duration.zero, player.state.duration);
    player.seek(result);
    _.play();
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
    return ClipRect(
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Obx(
            () => Video(
              key: ValueKey(_.videoFit.value),
              controller: videoController,
              controls: NoVideoControls,
              alignment: widget.alignment!,
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
            () => ControlBar(
              visible: _volumeIndicator.value,
              icon: _volumeValue.value < 1.0 / 3.0
                  ? Icons.volume_mute
                  : _volumeValue.value < 2.0 / 3.0
                      ? Icons.volume_down
                      : Icons.volume_up,
              value: _volumeValue.value,
            ),
          ),

          /// 亮度🌞 控制条展示
          Obx(
            () => ControlBar(
              visible: _brightnessIndicator.value,
              icon: _brightnessValue.value < 1.0 / 3.0
                  ? Icons.brightness_low
                  : _brightnessValue.value < 2.0 / 3.0
                      ? Icons.brightness_medium
                      : Icons.brightness_high,
              value: _brightnessValue.value,
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

          /// 开启且有字幕时展示
          Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 30,
                child: Align(
                  alignment: Alignment.center,
                  child: Obx(
                    () => Visibility(
                        visible: widget.controller.subTitleCode.value != -1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: widget.controller.subtitleContent.value != ''
                                ? Colors.black.withOpacity(0.6)
                                : Colors.transparent,
                          ),
                          padding: widget.controller.subTitleCode.value != -1
                              ? const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                )
                              : EdgeInsets.zero,
                          child: Text(
                            widget.controller.subtitleContent.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),

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
                if (_.videoType == 'live' || _.controlsLock.value) {
                  return;
                }
                final double totalWidth = MediaQuery.sizeOf(context).width;
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
                if (_.videoType == 'live' || _.controlsLock.value) {
                  return;
                }
                // final double tapPosition = details.localPosition.dx;
                final int curSliderPosition =
                    _.sliderPosition.value.inMilliseconds;
                final double scale = 90000 / MediaQuery.sizeOf(context).width;
                final Duration pos = Duration(
                    milliseconds:
                        curSliderPosition + (details.delta.dx * scale).round());
                final Duration result =
                    pos.clamp(Duration.zero, _.duration.value);
                _.onUpdatedSliderProgress(result);
                _.onChangedSliderStart();
              },
              onHorizontalDragEnd: (DragEndDetails details) {
                if (_.videoType == 'live' || _.controlsLock.value) {
                  return;
                }
                _.onChangedSliderEnd();
                _.seekTo(_.sliderPosition.value, type: 'slider');
              },
              // 垂直方向 音量/亮度调节
              onVerticalDragUpdate: (DragUpdateDetails details) async {
                final double totalWidth = MediaQuery.sizeOf(context).width;
                final double tapPosition = details.localPosition.dx;
                final double sectionWidth =
                    fullScreenGestureMode == FullScreenGestureMode.none
                        ? totalWidth / 2
                        : totalWidth / 3;
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
                  final double level = (_.isFullScreen.value
                          ? Get.size.height
                          : screenWidth * 9 / 16) *
                      3;
                  final double brightness =
                      _brightnessValue.value - delta / level;
                  final double result = brightness.clamp(0.0, 1.0);
                  setBrightness(result);
                } else if (isUsingFullScreenGestures(
                    tapPosition, sectionWidth)) {
                  // 全屏
                  final double dy = details.delta.dy;
                  const double threshold = 7.0; // 滑动阈值
                  final bool flag = fullScreenGestureMode !=
                      FullScreenGestureMode.fromBottomtoTop;
                  if (dy > _distance.value &&
                      dy > threshold &&
                      !_.controlsLock.value) {
                    if (_.isFullScreen.value ^ flag) {
                      lastFullScreenToggleTime = DateTime.now();
                      // 下滑退出全屏
                      await widget.controller.triggerFullScreen(status: flag);
                    }
                    _distance.value = 0.0;
                  } else if (dy < _distance.value &&
                      dy < -threshold &&
                      !_.controlsLock.value) {
                    if (!_.isFullScreen.value ^ flag) {
                      lastFullScreenToggleTime = DateTime.now();
                      // 上滑进入全屏
                      await widget.controller.triggerFullScreen(status: !flag);
                    }
                    _distance.value = 0.0;
                  }
                  _distance.value = dy;
                } else {
                  // 右边区域 👈
                  EasyThrottle.throttle(
                      'setVolume', const Duration(milliseconds: 20), () {
                    final double level = (_.isFullScreen.value
                        ? Get.size.height
                        : screenWidth * 9 / 16);
                    final double volume = _volumeValue.value -
                        double.parse(delta.toStringAsFixed(1)) / level;
                    final double result = volume.clamp(0.0, 1.0);
                    setVolume(result);
                  });
                }
              },
              onVerticalDragEnd: (DragEndDetails details) {},
            ),
          ),

          // 头部、底部控制条
          Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.headerControl != null ||
                    _.headerControl != null) ...[
                  Flexible(
                    child: AppBarAni(
                      controller: animationController,
                      visible: !_.controlsLock.value && _.showControls.value,
                      position: 'top',
                      child: widget.headerControl ?? _.headerControl!,
                    ),
                  ),
                ] else ...[
                  const SizedBox.shrink()
                ],
                Flexible(
                  flex: _.videoType == 'live' ? 0 : 1,
                  child: AppBarAni(
                    controller: animationController,
                    visible: !_.controlsLock.value && _.showControls.value,
                    position: 'bottom',
                    child: widget.bottomControl ??
                        BottomControl(
                          controller: widget.controller,
                          triggerFullScreen: _.triggerFullScreen,
                          buildBottomControl: buildBottomControl(),
                        ),
                  ),
                ),
              ],
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
                return const SizedBox();
              }
              if (defaultBtmProgressBehavior ==
                      BtmProgresBehavior.onlyShowFullScreen.code &&
                  !_.isFullScreen.value) {
                return const SizedBox();
              } else if (defaultBtmProgressBehavior ==
                      BtmProgresBehavior.onlyHideFullScreen.code &&
                  _.isFullScreen.value) {
                return const SizedBox();
              }

              if (_.videoType == 'live') {
                return const SizedBox();
              }
              if (value > max || max <= 0) {
                return const SizedBox();
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
                  bufferedBarColor: Colors.white.withOpacity(0.6),
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
              visible: _.videoType != 'live' && _.isFullScreen.value,
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
                  child: Lottie.asset(
                    'assets/loading.json',
                    width: 200,
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          }),

          /// 快进/快退面板
          SeekPanel(
            mountSeekBackwardButton: _mountSeekBackwardButton,
            mountSeekForwardButton: _mountSeekForwardButton,
            hideSeekBackwardButton: _hideSeekBackwardButton,
            hideSeekForwardButton: _hideSeekForwardButton,
            onSubmittedcb: _handleSubmittedCallback,
          ),
        ],
      ),
    );
  }
}
