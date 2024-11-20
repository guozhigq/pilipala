import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/msg.dart';
import 'package:pilipala/models/msg/at.dart';

class MessageAtController extends GetxController {
  Cursor? cursor;
  RxList<MessageAtItems> atItems = <MessageAtItems>[].obs;

  Future queryMessageAt({String type = 'init'}) async {
    if (cursor != null && cursor!.isEnd == true) {
      return {};
    }
    var res = await MsgHttp.messageAt();
    if (res['status']) {
      cursor = res['data'].cursor;
      if (type == 'init') {
        atItems.value = res['data'].items;
      } else {
        atItems.addAll(res['data'].items);
      }
    } else {
      SmartDialog.showToast(res['msg']);
    }
    return res;
  }
}
