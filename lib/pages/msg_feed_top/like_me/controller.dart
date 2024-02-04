import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/msg.dart';
import '../../../models/msg/msgfeed_like_me.dart';

class LikeMeController extends GetxController {
  RxList<LikeMeItems> msgFeedLikeMeList = <LikeMeItems>[].obs;
  bool isLoading = false;
  int cursor = -1;
  int cursorTime = -1;
  bool isEnd = false;

  Future queryMsgFeedLikeMe() async {
    if (isLoading) return;
    isLoading = true;
    var res = await MsgHttp.msgFeedLikeMe(cursor: cursor, cursorTime: cursorTime);
    isLoading = false;
    if (res['status']) {
      MsgFeedLikeMe data = MsgFeedLikeMe.fromJson(res['data']);
      isEnd = data.total?.cursor?.isEnd ?? false;
      if (cursor == -1) {
        msgFeedLikeMeList.assignAll(data.total!.items!);
      } else {
        msgFeedLikeMeList.addAll(data.total!.items!);
      }
      cursor = data.total?.cursor?.id ?? -1;
      cursorTime = data.total?.cursor?.time ?? -1;
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  Future onLoad() async {
    if (isEnd) return;
    queryMsgFeedLikeMe();
  }

  Future onRefresh() async {
    cursor = -1;
    cursorTime = -1;
    queryMsgFeedLikeMe();
  }

}
