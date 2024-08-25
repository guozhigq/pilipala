import 'package:get/get.dart';
import 'package:pilipala/http/msg.dart';
import 'package:pilipala/models/msg/system.dart';

class MessageSystemController extends GetxController {
  RxList<MessageSystemModel> systemItems = <MessageSystemModel>[].obs;

  Future queryMessageSystem({String type = 'init'}) async {
    var res = await MsgHttp.messageSystem();
    if (res['status']) {
      if (type == 'init') {
        systemItems.value = res['data'];
      } else {
        systemItems.addAll(res['data']);
      }
      if (systemItems.isNotEmpty) {
        systemMarkRead(systemItems.first.cursor!);
      }
    }
    return res;
  }

  // 标记已读
  void systemMarkRead(int cursor) async {
    await MsgHttp.systemMarkRead(cursor);
  }
}
