import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/dynamics.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/utils/utils.dart';

class DynamicsController extends GetxController {
  int page = 1;
  String? offset = '';
  RxList<DynamicItemModel>? dynamicsList = [DynamicItemModel()].obs;
  RxString dynamicsType = 'all'.obs;
  RxString dynamicsTypeLabel = '全部'.obs;
  final ScrollController scrollController = ScrollController();

  Future queryFollowDynamic({type = 'init'}) async {
    var res = await DynamicsHttp.followDynamic(
      page: type == 'init' ? 1 : page,
      type: dynamicsType.value,
      offset: offset,
    );
    if (res['status']) {
      if (type == 'init') {
        dynamicsList!.value = res['data'].items;
      } else {
        dynamicsList!.addAll(res['data'].items);
      }
      offset = res['data'].offset;
      page++;
    }
    return res;
  }

  onSelectType(value, label) async {
    dynamicsType.value = value;
    dynamicsTypeLabel.value = label;
    await queryFollowDynamic();
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  pushDetail(item, floor, {action = 'all'}) async {
    if (action == 'comment') {
      Get.toNamed('/dynamicDetail',
          arguments: {'item': item, 'floor': floor, 'action': action});
      return false;
    }
    switch (item!.type) {
      case 'DYNAMIC_TYPE_FORWARD':
        Get.toNamed('/dynamicDetail',
            arguments: {'item': item, 'floor': floor});
        break;
      case 'DYNAMIC_TYPE_DRAW':
        Get.toNamed('/dynamicDetail',
            arguments: {'item': item, 'floor': floor});
        break;
      case 'DYNAMIC_TYPE_AV':
        String bvid = item.modules.moduleDynamic.major.archive.bvid;
        int aid = item.modules.moduleDynamic.major.archive.aid;
        String cover = item.modules.moduleDynamic.major.archive.cover;
        String heroTag = Utils.makeHeroTag(aid);
        try {
          int cid = await SearchHttp.ab2c(bvid: bvid);
          Get.toNamed('/video?bvid=$bvid&cid=$cid',
              arguments: {'pic': cover, 'heroTag': heroTag});
        } catch (err) {
          SmartDialog.showToast(err.toString());
        }
        break;
      case 'DYNAMIC_TYPE_ARTICLE':
        String title = item.modules.moduleDynamic.major.opus.title;
        String url = item.modules.moduleDynamic.major.opus.jumpUrl;
        Get.toNamed(
          '/webview',
          parameters: {'url': 'https:$url', 'type': 'note', 'pageTitle': title},
        );
        break;
      case 'DYNAMIC_TYPE_PGC':
        print('番剧');
        break;
      case 'DYNAMIC_TYPE_WORD':
        print('纯文本');
        Get.toNamed('/dynamicDetail',
            arguments: {'item': item, 'floor': floor});
        break;
    }
  }
}
