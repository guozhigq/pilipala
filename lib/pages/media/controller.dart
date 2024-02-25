import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/utils/storage.dart';

class MediaController extends GetxController {
  Rx<FavFolderData> favFolderData = FavFolderData().obs;
  Box userInfoCache = GStrorage.userInfo;
  RxBool userLogin = false.obs;
  List list = [
    {
      'icon': Icons.file_download_outlined,
      'title': '离线缓存',
      'onTap': () {
        SmartDialog.showToast('功能开发中');
      },
    },
    {
      'icon': Icons.history,
      'title': '观看记录',
      'onTap': () => Get.toNamed('/history'),
    },
    {
      'icon': Icons.star_border,
      'title': '我的收藏',
      'onTap': () => Get.toNamed('/fav'),
    },
    {
      'icon': Icons.subscriptions_outlined,
      'title': '我的订阅',
      'onTap': () => Get.toNamed('/subscription'),
    },
    {
      'icon': Icons.watch_later_outlined,
      'title': '稍后再看',
      'onTap': () => Get.toNamed('/later'),
    },
  ];
  var userInfo;
  int? mid;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    userInfo = userInfoCache.get('userInfoCache');
    userLogin.value = userInfo != null;
  }

  Future<dynamic> queryFavFolder() async {
    if (!userLogin.value) {
      return {'status': false, 'data': [], 'msg': '未登录'};
    }
    var res = await await UserHttp.userfavFolder(
      pn: 1,
      ps: 5,
      mid: mid ?? GStrorage.userInfo.get('userInfoCache').mid,
    );
    favFolderData.value = res['data'];
    return res;
  }
}
