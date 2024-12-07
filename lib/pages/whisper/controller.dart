import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/msg.dart';
import 'package:pilipala/models/msg/account.dart';
import 'package:pilipala/models/msg/session.dart';

class WhisperController extends GetxController {
  RxList<SessionList> sessionList = <SessionList>[].obs;
  RxList<AccountListModel> accountList = <AccountListModel>[].obs;
  bool isLoading = false;
  RxList noticesList = [
    {
      'icon': Icons.message_outlined,
      'title': '回复我的',
      'path': '/messageReply',
      'count': 0,
    },
    {
      'icon': Icons.alternate_email,
      'title': '@我的',
      'path': '/messageAt',
      'count': 0,
    },
    {
      'icon': Icons.thumb_up_outlined,
      'title': '收到的赞',
      'path': '/messageLike',
      'count': 0,
    },
    {
      'icon': Icons.notifications_none_outlined,
      'title': '系统通知',
      'path': '/messageSystem',
      'count': 0,
    }
  ].obs;

  @override
  void onInit() {
    unread();
    super.onInit();
  }

  Future querySessionList(String? type) async {
    if (isLoading) return;
    var res = await MsgHttp.sessionList(
        endTs: type == 'onLoad' ? sessionList.last.sessionTs : null);
    try {
      if (res['status'] &&
          res['data'].sessionList != null &&
          res['data'].sessionList.isNotEmpty) {
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
        if (type == 'onLoad') {
          sessionList.addAll(res['data'].sessionList);
        } else {
          sessionList.value = res['data'].sessionList;
        }
      }
    } catch (err) {
      res = {
        'status': false,
        'message': err.toString(),
      };
    }

    isLoading = false;
    return res;
  }

  Future queryAccountList(sessionList) async {
    List midsList = sessionList.map((e) => e.talkerId!).toList();
    var index = midsList.indexOf(0);
    AccountListModel? accountInfo;
    if (index != -1) {
      accountInfo = AccountListModel(
        mid: 0,
        name: '客服消息',
        face:
            'https://i0.hdslb.com/bfs/activity-plat/static/20230809/f87fc7ea98282a4dd48ec7743044b0bf/OWdoP9ZXAX.png',
      );
    }
    if (midsList.length == 1 && index != -1) {
      accountList.add(accountInfo!);
      return;
    }

    var res = await MsgHttp.accountList(midsList.join(','));
    if (res['status']) {
      accountList.value = res['data'];
      if (accountInfo != null) {
        if (accountList.isNotEmpty) {
          accountList.insert(index, accountInfo);
        } else {
          accountList.add(accountInfo);
        }
      }
    }

    return res;
  }

  Future onLoad() async {
    querySessionList('onLoad');
  }

  Future onRefresh() async {
    querySessionList('onRefresh');
  }

  void refreshLastMsg(int talkerId, String content) {
    final SessionList currentItem =
        sessionList.where((p0) => p0.talkerId == talkerId).first;
    currentItem.lastMsg!.content['content'] = content;
    sessionList.removeWhere((p0) => p0.talkerId == talkerId);
    sessionList.insert(0, currentItem);
    sessionList.refresh();
  }

  // 移除会话
  void removeSessionMsg(int talkerId) {
    sessionList.removeWhere((p0) => p0.talkerId == talkerId);
    sessionList.refresh();
  }

  // 消息未读数
  void unread() async {
    var res = await MsgHttp.unread();
    if (res['status']) {
      noticesList[0]['count'] = res['data']['reply'];
      noticesList[1]['count'] = res['data']['at'];
      noticesList[2]['count'] = res['data']['like'];
      noticesList[3]['count'] = res['data']['sys_msg'];
      noticesList.refresh();
    }
  }
}
