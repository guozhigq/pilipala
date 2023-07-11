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

  @override
  void initState() {
    super.initState();
    _meeduPlayerController = _liveRoomController.meeduPlayerController;
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
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NetworkImgLayer(
              type: 'emote',
              src: _liveRoomController.cover,
              width: Get.size.width,
              height: videoHeight + 45,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.background.withOpacity(0.1),
                ),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: MeeduVideoPlayer(
                    controller: _meeduPlayerController!,
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.background,
                  height: 45,
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(children: [
                    Text(
                        _liveRoomController.liveItem.watchedShow['text_large']),
                  ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
