import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:pilipala/common/widgets/app_bar_ani.dart';
import 'package:pilipala/plugin/pl_player/controller.dart';
import 'package:pilipala/plugin/pl_player/models/play_status.dart';
import 'package:pilipala/utils/feed_back.dart';

import 'widgets/bottom_control.dart';
import 'widgets/common_btn.dart';

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

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    videoController = widget.controller.videoController!;
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
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 15),
          child: GestureDetector(
              onTap: () {
                _.controls = !_.showControls.value;
              },
              onDoubleTap: () {
                if (_.playerStatus.status.value == PlayerStatus.playing) {
                  _.togglePlay();
                } else {
                  _.play();
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
              onVerticalDragUpdate: (DragUpdateDetails details) {},
              onVerticalDragEnd: (DragEndDetails details) {}),
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
                    visible: !_.controlsClose.value && _.showControls.value,
                    position: 'top',
                    child: widget.headerControl!,
                  ),
                ),
                const Spacer(),
                ClipRect(
                  clipBehavior: Clip.hardEdge,
                  child: AppBarAni(
                    controller: animationController,
                    visible: !_.controlsClose.value && _.showControls.value,
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
              bottom: -4,
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
                    barHeight: 3,
                    thumbRadius: 0.0,
                    onDragStart: (duration) {
                      _.onChangedSliderStart();
                    },
                    onDragEnd: () {
                      _.onChangedSliderEnd();
                    },
                    // onDragUpdate: (details) {
                    //   print(details);
                    // },
                    onSeek: (duration) {
                      feedBack();
                      _.onChangedSlider(duration.inSeconds.toDouble());
                      _.seekTo(duration);
                    },
                  )),
            );
          },
        ),
        // 长按倍速
        Obx(
          () => Align(
            alignment: Alignment.topCenter,
            child: FractionalTranslation(
              translation: const Offset(0.0, 1.5), // 上下偏移量（负数向上偏移）
              child: Visibility(
                visible: _.doubleSpeedStatus.value,
                child: const Text(
                  '** 倍速中 **',
                  style: TextStyle(
                    fontSize: 13,
                    backgroundColor: Color(0xaa000000),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
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
                      _.controlsClose.value
                          ? FontAwesomeIcons.lock
                          : FontAwesomeIcons.lockOpen,
                      size: 15,
                      color: Colors.white,
                    ),
                    fuc: () => _.onCloseControl(!_.controlsClose.value),
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

class PLPlayerCtr extends GetxController {}
