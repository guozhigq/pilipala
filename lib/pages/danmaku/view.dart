import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ns_danmaku/ns_danmaku.dart';
import 'package:pilipala/pages/danmaku/index.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import 'package:pilipala/utils/danmaku.dart';

/// 传入播放器控制器，监听播放进度，加载对应弹幕
class PlDanmaku extends StatefulWidget {
  final int cid;
  final PlPlayerController playerController;

  const PlDanmaku({
    super.key,
    required this.cid,
    required this.playerController,
  });

  @override
  State<PlDanmaku> createState() => _PlDanmakuState();
}

class _PlDanmakuState extends State<PlDanmaku> {
  late PlPlayerController playerController;
  late PlDanmakuController _plDanmakuController;
  DanmakuController? _controller;
  bool danmuPlayStatus = true;

  @override
  void initState() {
    super.initState();
    _plDanmakuController =
        PlDanmakuController(widget.cid, widget.playerController);
    if (mounted) {
      playerController = widget.playerController;
      _plDanmakuController.videoDuration = playerController.duration.value;
      _plDanmakuController
        ..calcSegment()
        ..queryDanmaku();
      playerController
        ..addStatusLister(playerListener)
        ..addPositionListener(videoPositionListen);
    }
  }

  // 播放器状态监听
  void playerListener(PlayerStatus? status) {
    if (status == PlayerStatus.paused) {
      _controller!.pause();
    }
    if (status == PlayerStatus.playing) {
      _controller!.onResume();
    }
  }

  void videoPositionListen(Duration position) {
    if (!danmuPlayStatus) {
      _controller!.onResume();
      danmuPlayStatus = true;
    }
    PlDanmakuController ctr = _plDanmakuController;
    int currentPosition = position.inMilliseconds;

    // 超出分段数返回
    if (ctr.currentSegIndex >= ctr.dmSegList.length) {
      return;
    }
    if (ctr.dmSegList.isEmpty ||
        ctr.dmSegList[ctr.currentSegIndex].elems.isEmpty) {
      return;
    }
    // 超出当前分段的弹幕总数返回
    if (ctr.currentDmIndex >= ctr.dmSegList[ctr.currentSegIndex].elems.length) {
      ctr.currentDmIndex = 0;
      ctr.currentSegIndex++;
      return;
    }
    var element = ctr.dmSegList[ctr.currentSegIndex].elems[ctr.currentDmIndex];
    var delta = currentPosition - element.progress;

    if (delta >= 0 && delta < 200) {
      _controller!.addItems([
        DanmakuItem(
          element.content,
          color: DmUtils.decimalToColor(element.color),
          time: element.progress,
          type: DmUtils.getPosition(element.mode),
        )
      ]);
      ctr.currentDmIndex++;
    } else {
      if (!playerController.isOpenDanmu.value) {
        _controller!.pause();
        danmuPlayStatus = false;
        return;
      }
      ctr.findClosestPositionIndex(position.inMilliseconds);
    }
  }

  @override
  void dispose() {
    playerController.removePositionListener(videoPositionListen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedOpacity(
        opacity: playerController.isOpenDanmu.value ? 1 : 0,
        duration: const Duration(milliseconds: 100),
        child: DanmakuView(
          createdController: (DanmakuController e) async {
            _controller = e;
          },
          option: DanmakuOption(
            fontSize: 15,
            area: 0.5,
            duration: 5,
          ),
          statusChanged: (isPlaying) {},
        ),
      ),
    );
  }
}
