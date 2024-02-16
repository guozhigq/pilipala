import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/msg.dart';
import 'package:pilipala/models/msg/account.dart';
import 'package:pilipala/models/msg/session.dart';

import '../../models/msg/msgfeed_unread.dart';

class WhisperController extends GetxController {
  RxList<SessionList> sessionList = <SessionList>[].obs;
  RxList<AccountListModel> accountList = <AccountListModel>[].obs;
  bool isLoading = false;
  Rx<MsgFeedUnread> msgFeedUnread = MsgFeedUnread().obs;
  RxList msgFeedTop = [
    {
      "name":"回复我的",
      "icon":Icons.message_outlined,
      "route": "/replyMe",
      "value": 0
    },
    {
      "name":"@我",
      "icon":Icons.alternate_email_outlined,
      "route": "/atMe",
      "value": 0
    },
    {
      "name":"收到的赞",
      "icon":Icons.favorite_border_outlined,
      "route": "/likeMe",
      "value": 0
    },
    {
      "name":"系统通知",
      "icon":Icons.notifications_none_outlined,
      "route": "/sysMsg",
      "value": 0
    },
  ].obs;

  Future queryMsgFeedUnread() async {
    var res = await MsgHttp.msgFeedUnread();
    if (res['status']) {
      msgFeedUnread.value = MsgFeedUnread.fromJson(res['data']);
      msgFeedTop[0]["value"] = msgFeedUnread.value.reply;
      msgFeedTop[1]["value"] = msgFeedUnread.value.at;
      msgFeedTop[2]["value"] = msgFeedUnread.value.like;
      msgFeedTop[3]["value"] = msgFeedUnread.value.sys_msg;
      // 触发更新
      msgFeedTop.refresh();
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  Future querySessionList(String? type) async {
    if (isLoading) return;
    var res = await MsgHttp.sessionList(
        endTs: type == 'onLoad' ? sessionList.last.sessionTs : null);
    if (res['data'].sessionList != null && res['data'].sessionList.isNotEmpty) {
      await queryAccountList(res['data'].sessionList);
      // 将 accountList 转换为 Map 结构
      Map<int, dynamic> accountMap = {};
      for (var j in accountList) {
        accountMap[j.mid!] = j;
      }

      // 遍历 sessionList，通过 mid 查找并赋值 accountInfo
      for (var i in res['data'].sessionList) {
        var accountInfo = accountMap[i.talkerId];
        if (accountInfo != null) {
          i.accountInfo = accountInfo;
        }
        if (i.talkerId == 844424930131966) {
          i.accountInfo = AccountListModel(
            name: 'UP主小助手',
            face:
                'https://message.biliimg.com/bfs/im/489a63efadfb202366c2f88853d2217b5ddc7a13.png',
          );
        }
      }
    }
    if (res['status'] && res['data'].sessionList != null) {
      if (type == 'onLoad') {
        sessionList.addAll(res['data'].sessionList);
      } else {
        sessionList.value = res['data'].sessionList;
      }
    }
    isLoading = false;
    return res;
  }

  Future queryAccountList(sessionList) async {
    List midsList = sessionList.map((e) => e.talkerId!).toList();
    var res = await MsgHttp.accountList(midsList.join(','));
    if (res['status']) {
      accountList.value = res['data'];
    }
    return res;
  }

  Future onLoad() async {
    querySessionList('onLoad');
  }

  Future onRefresh() async {
    querySessionList('onRefresh');
  }
}
