import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/msg.dart';
import 'package:pilipala/models/msg/session.dart';

class WhisperDetailController extends GetxController {
  late int talkerId;
  late String name;
  late String face;
  late String mid;
  RxList<MessageItem> messageList = <MessageItem>[].obs;
  //表情转换图片规则
  List<dynamic>? eInfos;

  @override
  void onInit() {
    super.onInit();
    talkerId = int.parse(Get.parameters['talkerId']!);
    name = Get.parameters['name']!;
    face = Get.parameters['face']!;
    mid = Get.parameters['mid']!;
  }

  Future querySessionMsg() async {
    var res = await MsgHttp.sessionMsg(talkerId: talkerId);
    if (res['status']) {
      messageList.value = res['data'].messages;
      if (messageList.isNotEmpty) {
        ackSessionMsg();
        if (res['data'].eInfos != null) {
          eInfos = res['data'].eInfos;
        }
      }
    } else {
      SmartDialog.showToast(res['msg']);
    }
    return res;
  }

  // 消息标记已读
  Future ackSessionMsg() async {
    if (messageList.isEmpty) {
      return;
    }
    var res = await MsgHttp.ackSessionMsg(
      talkerId: talkerId,
      ackSeqno: messageList.last.msgSeqno,
    );
    if (res['status']) {
      SmartDialog.showToast("已读成功");
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }
}
