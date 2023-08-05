import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/model_hot_video_item.dart';

class LaterController extends GetxController {
  final ScrollController scrollController = ScrollController();
  RxList<HotVideoItemModel> laterList = [HotVideoItemModel()].obs;
  int count = 0;

  Future queryLaterList() async {
    var res = await UserHttp.seeYouLater();
    if (res['status']) {
      laterList.value = res['data']['list'];
      count = res['data']['count'];
    }
    return res;
  }

  Future toViewDel() async {
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('即将删除所有已观看视频，此操作不可恢复。确定是否删除？'),
          actions: [
            TextButton(
                onPressed: () => SmartDialog.dismiss(),
                child: const Text('取消')),
            TextButton(
              onPressed: () async {
                var res = await UserHttp.toViewDel();
                if (res['status']) {
                  laterList.clear();
                  queryLaterList();
                }
                SmartDialog.dismiss();
                SmartDialog.showToast(res['msg']);
              },
              child: const Text('确认删除'),
            )
          ],
        );
      },
    );
  }
}
