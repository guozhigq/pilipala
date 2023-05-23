import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/utils/storage.dart';

class MediaController extends GetxController {
  Rx<FavFolderData> favFolderData = FavFolderData().obs;
  Box user = GStrorage.user;
  RxBool userLogin = false.obs;
  List list = [
    {
      'icon': Icons.file_download_outlined,
      'title': '离线缓存',
      'onTap': () {},
    },
    {
      'icon': Icons.history,
      'title': '观看记录',
      'onTap': () {},
    },
    {
      'icon': Icons.star_border,
      'title': '我的收藏',
      'onTap': () => Get.toNamed('/fav'),
    },
    {
      'icon': Icons.watch_later_outlined,
      'title': '稍后再看',
      'onTap': () => Get.toNamed('/later'),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    userLogin.value = user.get(UserBoxKey.userLogin) ?? false;
  }

  Future<dynamic> queryFavFolder() async {
    if (!userLogin.value) {
      return {'status': false, 'data': [], 'msg': '未登录'};
    }
    var res = await await UserHttp.userfavFolder(
      pn: 1,
      ps: 5,
      mid: GStrorage.user.get(UserBoxKey.userMid),
    );
    favFolderData.value = res['data'];
    return res;
  }
}
