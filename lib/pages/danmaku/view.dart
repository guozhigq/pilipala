import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ns_danmaku/ns_danmaku.dart';
import 'package:pilipala/pages/danmaku/index.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import 'package:pilipala/utils/danmaku.dart';
import 'package:pilipala/utils/storage.dart';

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
  Box setting = GStrorage.setting;
  late bool enableShowDanmaku;
  late List blockTypes;
  late double showArea;
  late double opacityVal;
  late double fontSizeVal;
  late double danmakuSpeedVal;

  @override
  void initState() {
    super.initState();
    enableShowDanmaku =
        setting.get(SettingBoxKey.enableShowDanmaku, defaultValue: false);
    _plDanmakuController =
        PlDanmakuController(widget.cid, widget.playerController);
    if (mounted) {
      playerController = widget.playerController;
      _plDanmakuController.videoDuration = playerController.duration.value;
      if (enableShowDanmaku || playerController.isOpenDanmu.value) {
        _plDanmakuController
          ..calcSegment()
          ..queryDanmaku();
      }
      playerController
        ..addStatusLister(playerListener)
        ..addPositionListener(videoPositionListen);
    }
    playerController.isOpenDanmu.listen((p0) {
      if (p0) {
        if (_plDanmakuController.dmSegList.isEmpty) {
          _plDanmakuController
            ..calcSegment()
            ..queryDanmaku();
        }
      }
    });
    blockTypes = playerController.blockTypes;
    showArea = playerController.showArea;
    opacityVal = playerController.opacityVal;
    fontSizeVal = playerController.fontSizeVal;
    danmakuSpeedVal = playerController.danmakuSpeedVal;
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
    if (!playerController.isOpenDanmu.value) {
      return;
    }
    PlDanmakuController ctr = _plDanmakuController;
    int currentPosition = position.inMilliseconds;
    blockTypes = playerController.blockTypes;
    // 根据position判断是否有已缓存弹幕。没有则请求对应段
    int segIndex = (currentPosition / (6 * 60 * 1000)).ceil();
    segIndex = segIndex < 1 ? 1 : segIndex;
    // print('🌹🌹： ${segIndex}');
    // print('🌹🌹： ${ctr.dmSegList.length}');
    // print('🌹🌹： ${ctr.hasrequestSeg.contains(segIndex - 1)}');
    if (segIndex - 1 >= ctr.dmSegList.length ||
        (ctr.dmSegList[segIndex - 1].elems.isEmpty &&
            !ctr.hasrequestSeg.contains(segIndex - 1))) {
      ctr.hasrequestSeg.add(segIndex - 1);
      ctr.currentSegIndex = segIndex;
      EasyThrottle.throttle('follow', const Duration(seconds: 1), () {
        ctr.queryDanmaku();
      });
    }
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
      // 屏蔽彩色弹幕
      if (blockTypes.contains(6) ? element.color == 16777215 : true) {
        _controller!.addItems([
          DanmakuItem(
            element.content,
            color: DmUtils.decimalToColor(element.color),
            time: element.progress,
            type: DmUtils.getPosition(element.mode),
          )
        ]);
      }
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
    return LayoutBuilder(builder: (context, box) {
      double initDuration = box.maxWidth / 12;
      return Obx(
        () => AnimatedOpacity(
          opacity: playerController.isOpenDanmu.value ? 1 : 0,
          duration: const Duration(milliseconds: 100),
          child: DanmakuView(
            createdController: (DanmakuController e) async {
              widget.playerController.danmakuController = _controller = e;
            },
            option: DanmakuOption(
              fontSize: 15 * fontSizeVal,
              area: showArea,
              opacity: opacityVal,
              hideTop: blockTypes.contains(5),
              hideScroll: blockTypes.contains(2),
              hideBottom: blockTypes.contains(4),
              duration: initDuration /
                  (danmakuSpeedVal * widget.playerController.playbackSpeed),
            ),
            statusChanged: (isPlaying) {},
          ),
        ),
      );
    });
  }
}
