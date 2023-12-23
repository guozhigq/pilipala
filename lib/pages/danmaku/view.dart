import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ns_danmaku/ns_danmaku.dart';
import 'package:pilipala/models/danmaku/dm.pb.dart';
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
  // bool danmuPlayStatus = true;
  Box setting = GStrorage.setting;
  late bool enableShowDanmaku;
  late List blockTypes;
  late double showArea;
  late double opacityVal;
  late double fontSizeVal;
  late double danmakuDurationVal;
  int latestAddedPosition = -1;

  @override
  void initState() {
    super.initState();
    enableShowDanmaku =
        setting.get(SettingBoxKey.enableShowDanmaku, defaultValue: false);
    _plDanmakuController =
        PlDanmakuController(widget.cid);
    if (mounted) {
      playerController = widget.playerController;
      if (enableShowDanmaku || playerController.isOpenDanmu.value) {
        _plDanmakuController.initiate(
            playerController.duration.value.inMilliseconds,
            playerController.position.value.inMilliseconds
        );
      }
      playerController
        ..addStatusLister(playerListener)
        ..addPositionListener(videoPositionListen);
    }
    playerController.isOpenDanmu.listen((p0) {
      if (p0 && !_plDanmakuController.initiated) {
        _plDanmakuController.initiate(
            playerController.duration.value.inMilliseconds,
            playerController.position.value.inMilliseconds
        );
      }
    });
    blockTypes = playerController.blockTypes;
    showArea = playerController.showArea;
    opacityVal = playerController.opacityVal;
    fontSizeVal = playerController.fontSizeVal;
    danmakuDurationVal = playerController.danmakuDurationVal;
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
    if (!playerController.isOpenDanmu.value) {
      return;
    }
    int currentPosition = position.inMilliseconds;
    currentPosition -= currentPosition % 100;//取整百的毫秒数

    if (currentPosition == latestAddedPosition) {
      return;
    }
    latestAddedPosition = currentPosition;

    List<DanmakuElem>? currentDanmakuList =
        _plDanmakuController.getCurrentDanmaku(currentPosition);

    if (currentDanmakuList != null) {
      Color? defaultColor = playerController.blockTypes.contains(6) ?
        DmUtils.decimalToColor(16777215) : null;

      _controller!.addItems(
        currentDanmakuList.map((e) => DanmakuItem(
          e.content,
          color: defaultColor ?? DmUtils.decimalToColor(e.color),
          time: e.progress,
          type: DmUtils.getPosition(e.mode),
        )).toList()
      );
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
      // double initDuration = box.maxWidth / 12;
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
              duration: danmakuDurationVal / widget.playerController.playbackSpeed,
              // initDuration /
              //     (danmakuSpeedVal * widget.playerController.playbackSpeed),
            ),
            statusChanged: (isPlaying) {},
          ),
        ),
      );
    });
  }
}
