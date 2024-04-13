import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/user/info.dart';
import 'package:pilipala/utils/storage.dart';

import '../../models/user/sub_folder.dart';

class SubController extends GetxController {
  final ScrollController scrollController = ScrollController();
  Rx<SubFolderModelData> subFolderData = SubFolderModelData().obs;
  Box userInfoCache = GStrorage.userInfo;
  UserInfoData? userInfo;
  int currentPage = 1;
  int pageSize = 20;
  RxBool hasMore = true.obs;

  Future<dynamic> querySubFolder({type = 'init'}) async {
    userInfo = userInfoCache.get('userInfoCache');
    if (userInfo == null) {
      return {'status': false, 'msg': '账号未登录'};
    }
    var res = await UserHttp.userSubFolder(
      pn: currentPage,
      ps: pageSize,
      mid: userInfo!.mid!,
    );
    if (res['status']) {
      if (type == 'init') {
        subFolderData.value = res['data'];
      } else {
        if (res['data'].list.isNotEmpty) {
          subFolderData.value.list!.addAll(res['data'].list);
          subFolderData.update((val) {});
        }
      }
      currentPage++;
    } else {
      SmartDialog.showToast(res['msg']);
    }
    return res;
  }

  Future onLoad() async {
    querySubFolder(type: 'onload');
  }

  // 取消订阅
  Future<void> cancelSub(SubFolderItemData subFolderItem) async {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('提示'),
        content: const Text('确定取消订阅吗？'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              '取消',
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          TextButton(
            onPressed: () async {
              var res = await UserHttp.cancelSub(seasonId: subFolderItem.id!);
              if (res['status']) {
                subFolderData.value.list!.remove(subFolderItem);
                subFolderData.update((val) {});
                SmartDialog.showToast('取消订阅成功');
              } else {
                SmartDialog.showToast(res['msg']);
              }
              Get.back();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
