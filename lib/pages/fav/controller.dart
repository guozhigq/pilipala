import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/models/user/info.dart';
import 'package:pilipala/utils/storage.dart';

class FavController extends GetxController {
  final ScrollController scrollController = ScrollController();
  Rx<FavFolderData> favFolderData = FavFolderData().obs;
  RxList<FavFolderItemData> favFolderList = <FavFolderItemData>[].obs;
  Box userInfoCache = GStrorage.userInfo;
  UserInfoData? userInfo;
  int currentPage = 1;
  int pageSize = 60;
  RxBool hasMore = true.obs;
  late int mid;
  late int ownerMid;
  RxBool isOwner = false.obs;

  @override
  void onInit() {
    mid = int.parse(Get.parameters['mid'] ?? '-1');
    userInfo = userInfoCache.get('userInfoCache');
    ownerMid = userInfo != null ? userInfo!.mid! : -1;
    isOwner.value = mid == -1 || mid == ownerMid;
    super.onInit();
  }

  Future<dynamic> queryFavFolder({type = 'init'}) async {
    if (userInfo == null) {
      return {'status': false, 'msg': '账号未登录', 'code': -101};
    }
    if (!hasMore.value) {
      return;
    }
    var res = await UserHttp.userfavFolder(
      pn: currentPage,
      ps: pageSize,
      mid: isOwner.value ? ownerMid : mid,
    );
    if (res['status']) {
      if (type == 'init') {
        favFolderData.value = res['data'];
        favFolderList.value = res['data'].list;
      } else {
        if (res['data'].list.isNotEmpty) {
          favFolderList.addAll(res['data'].list);
          favFolderData.update((val) {});
        }
      }
      hasMore.value = res['data'].hasMore;
      currentPage++;
    } else {
      SmartDialog.showToast(res['msg']);
    }
    return res;
  }

  Future onLoad() async {
    queryFavFolder(type: 'onload');
  }

  removeFavFolder({required int mediaIds}) async {
    for (var i in favFolderList) {
      if (i.id == mediaIds) {
        favFolderList.remove(i);
        break;
      }
    }
  }
}
