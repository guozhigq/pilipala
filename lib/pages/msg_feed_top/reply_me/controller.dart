import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/msg.dart';

import '../../../models/msg/msgfeed_reply_me.dart';

class ReplyMeController extends GetxController {
  RxList<ReplyMeItems> msgFeedReplyMeList = <ReplyMeItems>[].obs;
  bool isLoading = false;
  int cursor = -1;
  int cursorTime = -1;
  bool isEnd = false;

  Future queryMsgFeedReplyMe() async {
    if (isLoading) return;
    isLoading = true;
    var res = await MsgHttp.msgFeedReplyMe(cursor: cursor, cursorTime: cursorTime);
    isLoading = false;
    if (res['status']) {
      MsgFeedReplyMe data = MsgFeedReplyMe.fromJson(res['data']);
      isEnd = data.cursor?.isEnd ?? false;
      if (cursor == -1) {
        msgFeedReplyMeList.assignAll(data.items!);
      } else {
        msgFeedReplyMeList.addAll(data.items!);
      }
      cursor = data.cursor?.id ?? -1;
      cursorTime = data.cursor?.time ?? -1;
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  Future onLoad() async {
    if (isEnd) return;
    queryMsgFeedReplyMe();
  }

  Future onRefresh() async {
    cursor = -1;
    queryMsgFeedReplyMe();
  }

}
