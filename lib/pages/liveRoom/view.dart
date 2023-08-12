import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/plugin/pl_player/index.dart';

import 'controller.dart';

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
                const SizedBox(height: 1),
                if (_liveRoomController.liveItem.watchedShow != null)
                  Text(
                      _liveRoomController.liveItem.watchedShow['text_large'] ??
                          '',
                      style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          SizedBox(
            height: 34,
            child: ElevatedButton(onPressed: () {}, child: const Text('关注')),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Hero(
            tag: _liveRoomController.heroTag,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: plPlayerController!.videoPlayerController != null
                      ? PLVideoPlayer(controller: plPlayerController!)
                      : const SizedBox(),
                ),
                if (_liveRoomController.liveItem.cover != null)
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
            ),
          ),
          Container(
            height: 45,
            padding: const EdgeInsets.only(left: 12, right: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.1)),
              ),
            ),
            child: Row(children: <Widget>[
              SizedBox(
                width: 38,
                height: 38,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.subtitles_outlined,
                    size: 21,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 38,
                height: 38,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.hd_outlined,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(
                width: 38,
                height: 38,
                child: IconButton(
                  onPressed: () => _liveRoomController
                      .setVolumn(plPlayerController!.volume.value),
                  icon: Obx(() => Icon(
                        _liveRoomController.volumeOff.value
                            ? Icons.volume_off_outlined
                            : Icons.volume_up_outlined,
                        size: 21,
                      )),
                ),
              ),
              SizedBox(
                width: 38,
                height: 38,
                child: IconButton(
                  onPressed: () => {},
                  // plPlayerController!.goToFullscreen(context),
                  icon: const Icon(
                    Icons.fullscreen,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
