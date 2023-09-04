import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/video/play/url.dart';
import 'package:pilipala/pages/liveRoom/index.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import 'package:pilipala/utils/storage.dart';

class BottomControl extends StatefulWidget implements PreferredSizeWidget {
  final PlPlayerController? controller;
  final LiveRoomController? liveRoomCtr;
  const BottomControl({
    this.controller,
    this.liveRoomCtr,
    Key? key,
  }) : super(key: key);

  @override
  State<BottomControl> createState() => _BottomControlState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _BottomControlState extends State<BottomControl> {
  late PlayUrlModel videoInfo;
  List<PlaySpeed> playSpeed = PlaySpeed.values;
  TextStyle subTitleStyle = const TextStyle(fontSize: 12);
  TextStyle titleStyle = const TextStyle(fontSize: 14);
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
  Box localCache = GStrorage.localCache;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      primary: false,
      centerTitle: false,
      automaticallyImplyLeading: false,
      titleSpacing: 14,
      title: Row(
        children: [
          ComBtn(
            icon: const Icon(
              Icons.subtitles_outlined,
              size: 18,
              color: Colors.white,
            ),
            fuc: () => Get.back(),
          ),
          const SizedBox(width: 4),
          const Spacer(),
          const SizedBox(width: 4),
          ComBtn(
            icon: const Icon(
              Icons.hd_outlined,
              size: 18,
              color: Colors.white,
            ),
            fuc: () => {},
          ),
          const SizedBox(width: 4),
          Obx(
            () => ComBtn(
              icon: Icon(
                widget.liveRoomCtr!.volumeOff.value
                    ? Icons.volume_off_outlined
                    : Icons.volume_up_outlined,
                size: 18,
                color: Colors.white,
              ),
              fuc: () => {},
            ),
          ),
          const SizedBox(width: 4),
          ComBtn(
            icon: const Icon(
              Icons.fullscreen,
              size: 20,
              color: Colors.white,
            ),
            fuc: () => widget.controller!.triggerFullScreen(),
          ),
        ],
      ),
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
    const double trackHeight = 3;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2 + 4;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
