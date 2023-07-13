import 'package:flutter/material.dart';
import 'package:flutter_meedu_media_kit/meedu_player.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/http/live.dart';
import 'package:pilipala/models/live/room_info.dart';

class LiveRoomController extends GetxController {
  String cover = '';
  late int roomId;
  var liveItem;

  MeeduPlayerController meeduPlayerController = MeeduPlayerController(
    colorTheme: Theme.of(Get.context!).colorScheme.primary,
    pipEnabled: true,
    controlsStyle: ControlsStyle.youtube,
    enabledButtons: const EnabledButtons(pip: true),
  );

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      var args = Get.arguments['liveItem'];
      liveItem = args;
      roomId = liveItem.roomId!;
      if (args.pic != null && args.pic != '') {
        cover = args.cover;
      }
    }
    queryLiveInfo();
  }

  playerInit(source) {
    meeduPlayerController.setDataSource(
      DataSource(
        type: DataSourceType.network,
        source: source,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
          'referer': HttpString.baseUrl
        },
      ),
      autoplay: true,
    );
  }

  Future queryLiveInfo() async {
    var res = await LiveHttp.liveRoomInfo(roomId: roomId, qn: 10000);
    if (res['status']) {
      List<CodecItem> codec =
          res['data'].playurlInfo.playurl.stream.first.format.first.codec;
      CodecItem item = codec.first;
      String videoUrl = (item.urlInfo?.first.host)! +
          item.baseUrl! +
          item.urlInfo!.first.extra!;
      playerInit(videoUrl);
    }
  }
}
