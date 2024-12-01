import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import 'package:pilipala/utils/feed_back.dart';

class ProgressBarWidget extends StatelessWidget {
  final PlPlayerController controller;

  const ProgressBarWidget({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Color colorTheme = Theme.of(context).colorScheme.primary;
      final _ = controller;
      final int value = _.sliderPositionSeconds.value;
      final int max = _.durationSeconds.value;
      final int buffer = _.bufferedSeconds.value;
      if (value > max || max <= 0) {
        return const SizedBox();
      }
      return ProgressBar(
        progress: Duration(seconds: value),
        buffered: Duration(seconds: buffer),
        total: Duration(seconds: max),
        progressBarColor: colorTheme,
        baseBarColor: Colors.white.withOpacity(0.2),
        bufferedBarColor: Colors.white.withOpacity(0.6),
        timeLabelLocation: TimeLabelLocation.none,
        thumbColor: colorTheme,
        barHeight: 3.5,
        thumbRadius: 7,
        onDragStart: (duration) {
          feedBack();
          _.onChangedSliderStart();
        },
        onDragUpdate: (duration) {
          _.onUpdatedSliderProgress(duration.timeStamp);
        },
        onSeek: (duration) {
          _.onChangedSliderEnd();
          _.onChangedSlider(duration.inSeconds.toDouble());
          _.seekTo(Duration(seconds: duration.inSeconds), type: 'slider');
        },
      );
    });
  }
}
