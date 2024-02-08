import 'dart:io';

import 'package:floating/floating.dart';
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
  late Future? _futureBuilder;
  late Future? _futureBuilderFuture;

  bool isShowCover = true;
  bool isPlay = true;
  Floating? floating;

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
    if (Platform.isAndroid) {
      floating = Floating();
    }
    _futureBuilder = _liveRoomController.queryLiveInfoH5();
    _futureBuilderFuture = _liveRoomController.queryLiveInfo();
  }

  @override
  void dispose() {
    plPlayerController!.dispose();
    if (floating != null) {
      floating!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget videoPlayerPanel = FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data['status']) {
          return PLVideoPlayer(
            controller: plPlayerController!,
            bottomControl: BottomControl(
              controller: plPlayerController,
              liveRoomCtr: _liveRoomController,
              floating: floating,
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );

    Widget childWhenDisabled = Scaffold(
      primary: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Obx(
          //   () => Positioned.fill(
          //     child: Opacity(
          //       opacity: 0.8,
          //       child: _liveRoomController
          //                       .roomInfoH5.value.roomInfo?.appBackground !=
          //                   '' &&
          //               _liveRoomController
          //                       .roomInfoH5.value.roomInfo?.appBackground !=
          //                   null
          //           ? NetworkImgLayer(
          //               width: Get.width,
          //               height: Get.height,
          //               src: _liveRoomController
          //                       .roomInfoH5.value.roomInfo?.appBackground ??
          //                   '',
          //             )
          //           : Image.asset(
          //               'assets/images/live/default_bg.webp',
          //               width: Get.width,
          //               height: Get.height,
          //             ),
          //     ),
          //   ),
          // ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/live/default_bg.webp',
                width: Get.width,
                height: Get.height,
              ),
            ),
          ),
          Column(
            children: [
              AppBar(
                centerTitle: false,
                titleSpacing: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                toolbarHeight:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 56
                        : 0,
                title: FutureBuilder(
                  future: _futureBuilder,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const SizedBox();
                    }
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return Obx(
                        () => Row(
                          children: [
                            NetworkImgLayer(
                              width: 34,
                              height: 34,
                              type: 'avatar',
                              src: _liveRoomController
                                  .roomInfoH5.value.anchorInfo!.baseInfo!.face,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _liveRoomController.roomInfoH5.value
                                      .anchorInfo!.baseInfo!.uname!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 1),
                                if (_liveRoomController
                                        .roomInfoH5.value.watchedShow !=
                                    null)
                                  Text(
                                    _liveRoomController.roomInfoH5.value
                                            .watchedShow!['text_large'] ??
                                        '',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              PopScope(
                canPop: plPlayerController?.isFullScreen.value != true,
                onPopInvoked: (bool didPop) {
                  if (plPlayerController?.isFullScreen.value == true) {
                    plPlayerController!.triggerFullScreen(status: false);
                  }
                  if (MediaQuery.of(context).orientation ==
                      Orientation.landscape) {
                    verticalScreen();
                  }
                },
                child: SizedBox(
                  width: Get.size.width,
                  height: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? Get.size.height
                      : Get.size.width * 9 / 16,
                  child: videoPlayerPanel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    if (Platform.isAndroid) {
      return PiPSwitcher(
        childWhenDisabled: childWhenDisabled,
        childWhenEnabled: videoPlayerPanel,
        floating: floating,
      );
    } else {
      return childWhenDisabled;
    }
  }
}
