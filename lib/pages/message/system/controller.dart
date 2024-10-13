import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/msg.dart';
import 'package:pilipala/models/msg/system.dart';

class MessageSystemController extends GetxController {
  RxList<MessageSystemModel> systemItems = <MessageSystemModel>[].obs;

  Future<void> queryAndProcessMessages({String type = 'init'}) async {
    // 并行调用两个接口
    var results = await Future.wait([
      queryMessageSystem(type: type),
      queryMessageSystemAccount(type: type),
    ]);

    // 对返回的数据进行处理
    var systemRes = results[0];
    var accountRes = results[1];

    if (systemRes['status'] || accountRes['status']) {
      // 处理返回的数据
      List<MessageSystemModel> combinedData = [
        ...systemRes['data'],
        ...accountRes['data']
      ];
      combinedData.sort((a, b) => b.cursor!.compareTo(a.cursor!));
      systemItems.addAll(combinedData);
      systemItems.refresh();
      if (systemItems.isNotEmpty) {
        systemMarkRead(systemItems.first.cursor!);
      }
    } else {
      SmartDialog.showToast(systemRes['msg'] ?? accountRes['msg']);
    }
    return systemRes;
  }

  // 获取系统消息
  Future queryMessageSystem({String type = 'init'}) async {
    var res = await MsgHttp.messageSystem();
    return res;
  }

  // 获取系统消息 个人
  Future queryMessageSystemAccount({String type = 'init'}) async {
    var res = await MsgHttp.messageSystemAccount();
    return res;
  }

  // 标记已读
  void systemMarkRead(int cursor) async {
    await MsgHttp.systemMarkRead(cursor);
  }
}
