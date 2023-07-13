import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_meedu_media_kit/meedu_player.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:pilipala/common/widgets/network_img_layer.dart';

import 'controller.dart';

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  final LiveRoomController _liveRoomController = Get.put(LiveRoomController());
  MeeduPlayerController? _meeduPlayerController;
  StreamSubscription? _playerEventSubs;

  bool isShowCover = true;
  bool isPlay = true;

  @override
  void initState() {
    super.initState();
    _meeduPlayerController = _liveRoomController.meeduPlayerController;
    _playerEventSubs = _meeduPlayerController!.onPlayerStatusChanged.listen(
      (PlayerStatus status) {
        if (status == PlayerStatus.playing) {
          isShowCover = false;
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _meeduPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final videoHeight = MediaQuery.of(context).size.width * 9 / 16;

    return Scaffold(
      primary: true,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            NetworkImgLayer(
              width: 34,
              height: 34,
              type: 'avatar',
              src: _liveRoomController.liveItem.face,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _liveRoomController.liveItem.uname,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 3),
                Text(_liveRoomController.liveItem.title,
                    style: const TextStyle(fontSize: 12)),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Hero(
              tag: _liveRoomController.heroTag,
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: MeeduVideoPlayer(
                      controller: _meeduPlayerController!,
                    ),
                  ),
                  Visibility(
                    visible: isShowCover,
                    child: Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: NetworkImgLayer(
                        type: 'emote',
                        src: _liveRoomController.liveItem.cover,
                        width: Get.size.width,
                        height: videoHeight,
                      ),
                    ),
                  ),
                ],
              )),
          if (_liveRoomController.liveItem.watchedShow != null)
            Container(
              height: 45,
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Row(children: [
                Text(_liveRoomController.liveItem.watchedShow['text_large']),
              ]),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.1)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
