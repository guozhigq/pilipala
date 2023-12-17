import 'package:get/get.dart';
import 'package:pilipala/http/msg.dart';
import 'package:pilipala/models/msg/account.dart';
import 'package:pilipala/models/msg/session.dart';

class WhisperController extends GetxController {
  RxList<SessionList> sessionList = <SessionList>[].obs;
  RxList<AccountListModel> accountList = <AccountListModel>[].obs;
  bool isLoading = false;

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
