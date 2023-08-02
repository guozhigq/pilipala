import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:pilipala/common/widgets/app_bar_ani.dart';
import 'package:pilipala/plugin/pl_player/controller.dart';
import 'package:pilipala/plugin/pl_player/models/duration.dart';
import 'package:pilipala/plugin/pl_player/models/play_status.dart';
import 'package:pilipala/plugin/pl_player/utils.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:volume_controller/volume_controller.dart';

import 'widgets/backward_seek.dart';
import 'widgets/bottom_control.dart';
import 'widgets/common_btn.dart';
import 'widgets/forward_seek.dart';
import 'widgets/play_pause_btn.dart';

class PLVideoPlayer extends StatefulWidget {
  final PlPlayerController controller;
  final PreferredSizeWidget? headerControl;
  final Widget? danmuWidget;

  const PLVideoPlayer({
    required this.controller,
    this.headerControl,
    this.danmuWidget,
    super.key,
  });

  @override
  State<PLVideoPlayer> createState() => _PLVideoPlayerState();
}

class _PLVideoPlayerState extends State<PLVideoPlayer>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late VideoController videoController;

  bool _mountSeekBackwardButton = false;
  bool _mountSeekForwardButton = false;
  bool _hideSeekBackwardButton = false;
  bool _hideSeekForwardButton = false;

  double _brightnessValue = 0.0;
  bool _brightnessIndicator = false;
  Timer? _brightnessTimer;

  double _volumeValue = 0.0;
  bool _volumeIndicator = false;
  Timer? _volumeTimer;

  bool _volumeInterceptEventStream = false;

  void onDoubleTapSeekBackward() {
    setState(() {
      _mountSeekBackwardButton = true;
    });
  }

  void onDoubleTapSeekForward() {
    setState(() {
      _mountSeekForwardButton = true;
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    videoController = widget.controller.videoController!;

    Future.microtask(() async {
      try {
        VolumeController().showSystemUI = false;
        _volumeValue = await VolumeController().getVolume();
        VolumeController().listener((value) {
          if (mounted && !_volumeInterceptEventStream) {
            setState(() {
              _volumeValue = value;
            });
          }
        });
      } catch (_) {}
    });

    Future.microtask(() async {
      try {
        _brightnessValue = await ScreenBrightness().current;
        ScreenBrightness().onCurrentBrightnessChanged.listen((value) {
          if (mounted) {
            setState(() {
              _brightnessValue = value;
            });
          }
        });
      } catch (_) {}
    });
  }

  Future<void> setVolume(double value) async {
    try {
      VolumeController().setVolume(value);
    } catch (_) {}
    setState(() {
      _volumeValue = value;
      _volumeIndicator = true;
      _volumeInterceptEventStream = true;
    });
    _volumeTimer?.cancel();
    _volumeTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _volumeIndicator = false;
          _volumeInterceptEventStream = false;
        });
      }
    });
  }

  Future<void> setBrightness(double value) async {
    try {
      await ScreenBrightness().setScreenBrightness(value);
    } catch (_) {}
    setState(() {
      _brightnessIndicator = true;
    });
    _brightnessTimer?.cancel();
    _brightnessTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _brightnessIndicator = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _ = widget.controller;
    Color colorTheme = Theme.of(context).colorScheme.primary;
    TextStyle subTitleStyle = const TextStyle(
      height: 1.5,
      fontSize: 40.0,
      letterSpacing: 0.0,
      wordSpacing: 0.0,
      color: Color(0xffffffff),
      fontWeight: FontWeight.normal,
      backgroundColor: Color(0xaa000000),
    );
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    return Stack(
      clipBehavior: Clip.hardEdge,
      fit: StackFit.passthrough,
      children: [
        Video(
          controller: videoController,
          controls: NoVideoControls,
          subtitleViewConfiguration: SubtitleViewConfiguration(
            style: subTitleStyle,
            textAlign: TextAlign.center,
            padding: const EdgeInsets.all(24.0),
          ),
        ),

        /// 长按倍速
        Obx(
          () => Align(
            alignment: Alignment.topCenter,
            child: FractionalTranslation(
              translation: const Offset(0.0, 1), // 上下偏移量（负数向上偏移）
              child: AnimatedOpacity(
                curve: Curves.easeInOut,
                opacity: _.doubleSpeedStatus.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0x88000000),
                    borderRadius: BorderRadius.circular(64.0),
                  ),
                  height: 34.0,
                  width: 86.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 3),
                      Image.asset(
                        'assets/images/run-pokemon.gif',
                        height: 20,
                      ),
                      const Text(
                        '倍速中',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        /// 时间进度
        Obx(
          () => Align(
            alignment: Alignment.topCenter,
            child: FractionalTranslation(
              translation: const Offset(0.0, 1.0), // 上下偏移量（负数向上偏移）
              child: AnimatedOpacity(
                curve: Curves.easeInOut,
                opacity: _.isSliderMoving.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0x88000000),
                    borderRadius: BorderRadius.circular(64.0),
                  ),
                  height: 34.0,
                  width: 100.0,
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

        /// 音量🔊 控制条展示
        Align(
          alignment: Alignment.center,
          child: AnimatedOpacity(
            curve: Curves.easeInOut,
            opacity: _volumeIndicator ? 1.0 : 0.0,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 34.0,
                    width: 28.0,
                    alignment: Alignment.centerRight,
                    child: Icon(
                      _volumeValue == 0.0
                          ? Icons.volume_off
                          : _volumeValue < 0.5
                              ? Icons.volume_down
                              : Icons.volume_up,
                      color: const Color(0xFFFFFFFF),
                      size: 20.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${(_volumeValue * 100.0).round()}%',
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

        /// 亮度🌞 控制条展示
        Align(
          alignment: Alignment.center,
          child: AnimatedOpacity(
            curve: Curves.easeInOut,
            opacity: _brightnessIndicator ? 1.0 : 0.0,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 30.0,
                    width: 28.0,
                    alignment: Alignment.centerRight,
                    child: Icon(
                      _brightnessValue < 1.0 / 3.0
                          ? Icons.brightness_low
                          : _brightnessValue < 2.0 / 3.0
                              ? Icons.brightness_medium
                              : Icons.brightness_high,
                      color: const Color(0xFFFFFFFF),
                      size: 18.0,
                    ),
                  ),
                  const SizedBox(width: 2.0),
                  Expanded(
                    child: Text(
                      '${(_brightnessValue * 100.0).round()}%',
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
            onDoubleTapDown: (details) {
              final totalWidth = MediaQuery.of(context).size.width;
              final tapPosition = details.localPosition.dx;
              final sectionWidth = totalWidth / 3;
              if (tapPosition < sectionWidth) {
                // 双击左边区域 👈
                onDoubleTapSeekBackward();
              } else if (tapPosition < sectionWidth * 2) {
                if (_.playerStatus.status.value == PlayerStatus.playing) {
                  _.togglePlay();
                } else {
                  _.play();
                }
              } else {
                // 双击右边区域 👈
                onDoubleTapSeekForward();
              }
            },
            onLongPressStart: (detail) {
              feedBack();
              double currentSpeed = _.playbackSpeed;
              _.setDoubleSpeedStatus(true);
              _.setPlaybackSpeed(currentSpeed * 2);
            },
            onLongPressEnd: (details) {
              double currentSpeed = _.playbackSpeed;
              _.setDoubleSpeedStatus(false);
              _.setPlaybackSpeed(currentSpeed / 2);
            },
            // 水平位置 快进
            onHorizontalDragUpdate: (DragUpdateDetails details) {},
            onHorizontalDragEnd: (DragEndDetails details) {},
            // 垂直方向 音量/亮度调节
            onVerticalDragUpdate: (DragUpdateDetails details) {
              final totalWidth = MediaQuery.of(context).size.width;
              final tapPosition = details.localPosition.dx;
              final sectionWidth = totalWidth / 3;

              if (tapPosition < sectionWidth) {
                // 左边区域 👈
                final delta = details.delta.dy;
                final brightness = _brightnessValue - delta / 100.0;
                final result = brightness.clamp(0.0, 1.0);
                setBrightness(result);
              } else if (tapPosition < sectionWidth * 2) {
                // 全屏
                print('全屏');
              } else {
                // 右边区域 👈
                final delta = details.delta.dy;
                final volume = _volumeValue - delta / 100.0;
                final result = volume.clamp(0.0, 1.0);
                setVolume(result);
              }
            },
            onVerticalDragEnd: (DragEndDetails details) {},
          ),
        ),

        // 头部、底部控制条
        if (_.controlsEnabled)
          Obx(
            () => Column(
              children: [
                ClipRect(
                  clipBehavior: Clip.hardEdge,
                  child: AppBarAni(
                    controller: animationController,
                    visible: !_.controlsLock.value && _.showControls.value,
                    position: 'top',
                    child: widget.headerControl!,
                  ),
                ),
                const Spacer(),
                ClipRect(
                  clipBehavior: Clip.hardEdge,
                  child: AppBarAni(
                    controller: animationController,
                    visible: !_.controlsLock.value && _.showControls.value,
                    position: 'bottom',
                    child: BottomControl(controller: widget.controller),
                  ),
                ),
              ],
            ),
          ),
        // 进度条
        Obx(
          () {
            final int value = _.sliderPosition.value.inSeconds;
            final int max = _.duration.value.inSeconds;
            final int buffer = _.buffered.value.inSeconds;
            if (value > max || max <= 0) {
              return Container();
            }
            return Positioned(
              bottom: -3,
              left: 0,
              right: 0,
              child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(0, -1),
                  ).animate(CurvedAnimation(
                    parent: animationController,
                    curve: Curves.easeInOut,
                  )),
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
                    barHeight: 2,
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
                  )),
            );
          },
        ),

        // 锁
        if (_.controlsEnabled)
          Obx(
            () => Align(
              alignment: Alignment.centerLeft,
              child: FractionalTranslation(
                translation: const Offset(0.5, 0.0),
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
        //
        Obx(() {
          if (_.dataStatus.loading || _.isBuffering.value) {
            return Center(
              child: Image.asset(
                'assets/images/loading.gif',
                height: 25,
              ),
            );
          } else {
            return Container();
          }
        }),

        /// 点击 快进/快退
        if (_mountSeekBackwardButton || _mountSeekForwardButton)
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  child: _mountSeekBackwardButton
                      ? TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0.0,
                            end: _hideSeekBackwardButton ? 0.0 : 1.0,
                          ),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, value, child) => Opacity(
                            opacity: value,
                            child: child,
                          ),
                          onEnd: () {
                            if (_hideSeekBackwardButton) {
                              setState(() {
                                _hideSeekBackwardButton = false;
                                _mountSeekBackwardButton = false;
                              });
                            }
                          },
                          child: BackwardSeekIndicator(
                            onChanged: (value) {
                              print(value);
                              // _seekBarDeltaValueNotifier.value = -value;
                            },
                            onSubmitted: (value) {
                              setState(() {
                                _hideSeekBackwardButton = true;
                              });
                              Player player =
                                  widget.controller.videoPlayerController!;
                              var result = player.state.position - value;
                              result = result.clamp(
                                Duration.zero,
                                player.state.duration,
                              );
                              player.seek(result);
                              widget.controller.play();
                            },
                          ),
                        )
                      : const SizedBox(),
                ),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                ),
                Expanded(
                  child: _mountSeekForwardButton
                      ? TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0.0,
                            end: _hideSeekForwardButton ? 0.0 : 1.0,
                          ),
                          duration: const Duration(milliseconds: 500),
                          builder: (context, value, child) => Opacity(
                            opacity: value,
                            child: child,
                          ),
                          onEnd: () {
                            if (_hideSeekForwardButton) {
                              setState(() {
                                _hideSeekForwardButton = false;
                                _mountSeekForwardButton = false;
                              });
                            }
                          },
                          child: ForwardSeekIndicator(
                            onChanged: (value) {
                              // _seekBarDeltaValueNotifier.value = value;
                            },
                            onSubmitted: (value) {
                              setState(() {
                                _hideSeekForwardButton = true;
                              });
                              Player player =
                                  widget.controller.videoPlayerController!;
                              var result = player.state.position + value;
                              result = result.clamp(
                                Duration.zero,
                                player.state.duration,
                              );
                              player.seek(result);
                              widget.controller.play();
                            },
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class MSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData? sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackLeft = offset.dx;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, -1, trackWidth, 3);
  }
}
