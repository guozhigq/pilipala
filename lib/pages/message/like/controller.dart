import 'package:get/get.dart';
import 'package:pilipala/http/msg.dart';
import 'package:pilipala/models/msg/like.dart';

class MessageLikeController extends GetxController {
  Cursor? cursor;
  RxList<MessageLikeItem> likeItems = <MessageLikeItem>[].obs;

  Future queryMessageLike({String type = 'init'}) async {
    if (cursor != null && cursor!.isEnd == true) {
      return {};
    }
    var params = {
      if (type == 'onLoad') 'id': cursor!.id,
      if (type == 'onLoad') 'likeTime': cursor!.time,
    };
    var res = await MsgHttp.messageLike(
        id: params['id'], likeTime: params['likeTime']);
    if (res['status']) {
      cursor = res['data'].total.cursor;
      likeItems.addAll(res['data'].total.items);
    }
    return res;
  }

  Future expandedUsersAvatar(i) async {
    likeItems[i].isExpand = !likeItems[i].isExpand;
    likeItems.refresh();
  }
}
