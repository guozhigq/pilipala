import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/utils/storage.dart';

class MediaController extends GetxController {
  Rx<FavFolderData> favFolderData = FavFolderData().obs;
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
      'title': '稍候再看',
      'onTap': () => {},
    },
  ];

  Future<dynamic> queryFavFolder() async {
    var res = await await UserHttp.userfavFolder(
      pn: 1,
      ps: 5,
      mid: GStrorage.user.get(UserBoxKey.userMid),
    );
    favFolderData.value = res['data'];
    return res;
  }
}
