import 'package:get/get.dart';
import 'package:pilipala/http/msg.dart';
import 'package:pilipala/models/msg/system.dart';

class MessageSystemController extends GetxController {
  RxList<MessageSystemModel> systemItems = <MessageSystemModel>[].obs;

  Future queryMessageSystem({String type = 'init'}) async {
    var res = await MsgHttp.messageSystem();
    if (res['status']) {
      systemItems.addAll(res['data']);
    }
    return res;
  }
}
