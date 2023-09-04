import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/plugin/pl_player/index.dart';

import 'controller.dart';
import 'widgets/bottom_control.dart';

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  final LiveRoomController _liveRoomController = Get.put(LiveRoomController());
  PlPlayerController? plPlayerController;

  bool isShowCover = true;
  bool isPlay = true;

  @override
  void initState() {
    super.initState();
    plPlayerController = _liveRoomController.plPlayerController;
    plPlayerController!.onPlayerStatusChanged.listen(
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
    plPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoHeight = MediaQuery.of(context).size.width * 9 / 16;

    return Scaffold(
      primary: true,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: _liveRoomController.liveItem != null
            ? Row(
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
                      const SizedBox(height: 1),
                      if (_liveRoomController.liveItem.watchedShow != null)
                        Text(
                            _liveRoomController
                                    .liveItem.watchedShow['text_large'] ??
                                '',
                            style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              )
            : const SizedBox(),
        // actions: [
        //   SizedBox(
        //     height: 34,
        //     child: ElevatedButton(onPressed: () {}, child: const Text('关注')),
        //   ),
        //   const SizedBox(width: 12),
        // ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: plPlayerController!.videoPlayerController != null
                    ? PLVideoPlayer(
                        controller: plPlayerController!,
                        bottomControl: BottomControl(
                          controller: plPlayerController,
                          liveRoomCtr: _liveRoomController,
                        ),
                      )
                    : const SizedBox(),
              ),
              // if (_liveRoomController.liveItem != null &&
              //     _liveRoomController.liveItem.cover != null)
              //   Visibility(
              //     visible: isShowCover,
              //     child: Positioned(
              //       top: 0,
              //       left: 0,
              //       right: 0,
              //       child: NetworkImgLayer(
              //         type: 'emote',
              //         src: _liveRoomController.liveItem.cover,
              //         width: Get.size.width,
              //         height: videoHeight,
              //       ),
              //     ),
              //   ),
            ],
          ),
        ],
      ),
    );
  }
}
