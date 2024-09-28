import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ns_danmaku/ns_danmaku.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/http/live.dart';
import 'package:pilipala/models/live/message.dart';
import 'package:pilipala/models/live/quality.dart';
import 'package:pilipala/models/live/room_info.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import 'package:pilipala/plugin/pl_socket/index.dart';
import 'package:pilipala/utils/live.dart';
import '../../models/live/room_info_h5.dart';
import '../../utils/storage.dart';
import '../../utils/video_utils.dart';

class LiveRoomController extends GetxController {
  String cover = '';
  late int roomId;
  dynamic liveItem;
  late String heroTag;
  double volume = 0.0;
  // 静音状态
  RxBool volumeOff = false.obs;
  PlPlayerController plPlayerController = PlPlayerController(videoType: 'live');
  Rx<RoomInfoH5Model> roomInfoH5 = RoomInfoH5Model().obs;
  late bool enableCDN;
  late int currentQn;
  int? tempCurrentQn;
  late List<Map<String, dynamic>> acceptQnList;
  RxString currentQnDesc = ''.obs;
  Box userInfoCache = GStrorage.userInfo;
  int userId = 0;
  PlSocket? plSocket;
  List<String> danmuHostList = [];
  String token = '';
  // 弹幕消息列表
  RxList<LiveMessageModel> messageList = <LiveMessageModel>[].obs;
  DanmakuController? danmakuController;
  // 输入控制器
  TextEditingController inputController = TextEditingController();
  // 加入直播间提示
  RxMap<String, String> joinRoomTip = {'userName': '', 'message': ''}.obs;
  // 直播间弹幕开关 默认打开
  RxBool danmakuSwitch = true.obs;
  late String buvid;

  @override
  void onInit() {
    super.onInit();
    currentQn = setting.get(SettingBoxKey.defaultLiveQa,
        defaultValue: LiveQuality.values.last.code);
    roomId = int.parse(Get.parameters['roomid']!);
    if (Get.arguments != null) {
      liveItem = Get.arguments['liveItem'];
      heroTag = Get.arguments['heroTag'] ?? '';
      if (liveItem != null && liveItem.pic != null && liveItem.pic != '') {
        cover = liveItem.pic;
      }
      if (liveItem != null && liveItem.cover != null && liveItem.cover != '') {
        cover = liveItem.cover;
      }
      Request.getBuvid().then((value) => buvid = value);
    }
    // CDN优化
    enableCDN = setting.get(SettingBoxKey.enableCDN, defaultValue: true);
    final userInfo = userInfoCache.get('userInfoCache');
    if (userInfo != null && userInfo.mid != null) {
      userId = userInfo.mid;
    }
    liveDanmakuInfo().then((value) => initSocket());
    danmakuSwitch.listen((p0) {
      plPlayerController.isOpenDanmu.value = p0;
    });
  }

  playerInit(source) async {
    await plPlayerController.setDataSource(
      DataSource(
        videoSource: source,
        audioSource: null,
        type: DataSourceType.network,
        httpHeaders: {
          'user-agent':
              'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
          'referer': HttpString.baseUrl
        },
      ),
      // 硬解
      enableHA: true,
      autoplay: true,
    );
    plPlayerController.isOpenDanmu.value = danmakuSwitch.value;
    heartBeat();
  }

  Future queryLiveInfo() async {
    var res = await LiveHttp.liveRoomInfo(roomId: roomId, qn: currentQn);
    if (res['status']) {
      List<CodecItem> codec =
          res['data'].playurlInfo.playurl.stream.first.format.first.codec;
      CodecItem item = codec.first;
      // 以服务端返回的码率为准
      currentQn = item.currentQn!;
      if (tempCurrentQn != null && tempCurrentQn == currentQn) {
        SmartDialog.showToast('画质切换失败，请检查登录状态');
      }
      List acceptQn = item.acceptQn!;
      acceptQnList = acceptQn.map((e) {
        return {
          'code': e,
          'desc': LiveQuality.values
              .firstWhere((element) => element.code == e)
              .description,
        };
      }).toList();
      currentQnDesc.value = LiveQuality.values
          .firstWhere((element) => element.code == currentQn)
          .description;
      String videoUrl = enableCDN
          ? VideoUtils.getCdnUrl(item)
          : (item.urlInfo?.first.host)! +
              item.baseUrl! +
              item.urlInfo!.first.extra!;
      await playerInit(videoUrl);
      return res;
    }
  }

  void setVolumn(value) {
    if (value == 0) {
      // 设置音量
      volumeOff.value = false;
    } else {
      // 取消音量
      volume = value;
      volumeOff.value = true;
    }
  }

  Future queryLiveInfoH5() async {
    var res = await LiveHttp.liveRoomInfoH5(roomId: roomId);
    if (res['status']) {
      roomInfoH5.value = res['data'];
    }
    return res;
  }

  // 修改画质
  void changeQn(int qn) async {
    tempCurrentQn = currentQn;
    if (currentQn == qn) {
      return;
    }
    currentQn = qn;
    currentQnDesc.value = LiveQuality.values
        .firstWhere((element) => element.code == currentQn)
        .description;
    await queryLiveInfo();
  }

  Future liveDanmakuInfo() async {
    var res = await LiveHttp.liveDanmakuInfo(roomId: roomId);
    if (res['status']) {
      danmuHostList = (res["data"]["host_list"] as List)
          .map<String>((e) => '${e["host"]}:${e['wss_port']}')
          .toList();
      token = res["data"]["token"];
      return res;
    }
  }

  // 建立socket
  void initSocket() async {
    final wsUrl = danmuHostList.isNotEmpty
        ? danmuHostList.first
        : "broadcastlv.chat.bilibili.com";
    plSocket = PlSocket(
      url: 'wss://$wsUrl/sub',
      heartTime: 30,
      onReadyCb: () {
        joinRoom();
      },
      onMessageCb: (message) {
        final List<LiveMessageModel>? liveMsg =
            LiveUtils.decodeMessage(message);
        if (liveMsg != null && liveMsg.isNotEmpty) {
          if (liveMsg.first.type == LiveMessageType.online) {
            print('当前直播间人气：${liveMsg.first.data}');
          } else if (liveMsg.first.type == LiveMessageType.join ||
              liveMsg.first.type == LiveMessageType.follow) {
            // 每隔一秒依次liveMsg中的每一项赋给activeUserName

            int index = 0;
            Timer.periodic(const Duration(seconds: 2), (timer) {
              if (index < liveMsg.length) {
                if (liveMsg[index].type == LiveMessageType.join ||
                    liveMsg[index].type == LiveMessageType.follow) {
                  joinRoomTip.value = {
                    'userName': liveMsg[index].userName,
                    'message': liveMsg[index].message!,
                  };
                }
                index++;
              } else {
                timer.cancel();
              }
            });

            return;
          }
          // 过滤出聊天消息
          var chatMessages =
              liveMsg.where((msg) => msg.type == LiveMessageType.chat).toList();

          // 添加到 messageList
          messageList.addAll(chatMessages);

          // 将 chatMessages 转换为 danmakuItems 列表
          List<DanmakuItem> danmakuItems = chatMessages.map<DanmakuItem>((e) {
            return DanmakuItem(
              e.message ?? '',
              color: Color.fromARGB(
                255,
                e.color.r,
                e.color.g,
                e.color.b,
              ),
            );
          }).toList();

          // 添加到 danmakuController
          if (danmakuSwitch.value) {
            danmakuController?.addItems(danmakuItems);
          }
        }
      },
      onErrorCb: (e) {
        print('error: $e');
      },
    );
    await plSocket?.connect();
  }

  void joinRoom() async {
    var joinData = LiveUtils.encodeData(
      json.encode({
        "uid": userId,
        "roomid": roomId,
        "protover": 3,
        "buvid": buvid,
        "platform": "web",
        "type": 2,
        "key": token,
      }),
      7,
    );
    plSocket?.sendMessage(joinData);
  }

  // 发送弹幕
  void sendMsg() async {
    final msg = inputController.text;
    if (msg.isEmpty) {
      return;
    }
    final res = await LiveHttp.sendDanmaku(
      roomId: roomId,
      msg: msg,
    );
    if (res['status']) {
      inputController.clear();
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  // 历史记录
  void heartBeat() {
    LiveHttp.liveRoomEntry(roomId: roomId);
  }

  String encodeToBase64(String input) {
    List<int> bytes = utf8.encode(input);
    String base64Str = base64.encode(bytes);
    return base64Str;
  }

  @override
  void onClose() {
    heartBeat();
    plSocket?.onClose();
    super.onClose();
  }
}
