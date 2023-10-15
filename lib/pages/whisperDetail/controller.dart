import 'package:get/get.dart';
import 'package:pilipala/http/msg.dart';
import 'package:pilipala/models/msg/session.dart';

class WhisperDetailController extends GetxController {
  late int talkerId;
  RxString name = ''.obs;
  RxList<MessageItem> messageList = <MessageItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    talkerId = int.parse(Get.parameters['talkerId']!);
    name.value = Get.parameters['name']!;
  }

  Future querySessionMsg() async {
    var res = await MsgHttp.sessionMsg(talkerId: talkerId);
    if (res['status']) {
      messageList.value = res['data'].messages;
    }
    return res;
  }
}
