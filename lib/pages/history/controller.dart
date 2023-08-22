import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/user/history.dart';
import 'package:pilipala/utils/storage.dart';

class HistoryController extends GetxController {
  final ScrollController scrollController = ScrollController();
  RxList<HisListItem> historyList = [HisListItem()].obs;
  RxBool isLoadingMore = false.obs;
  RxBool pauseStatus = false.obs;
  Box localCache = GStrorage.localCache;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    historyStatus();
  }

  Future queryHistoryList({type = 'init'}) async {
    int max = 0;
    int viewAt = 0;
    if (type == 'onload') {
      max = historyList.last.history!.oid!;
      viewAt = historyList.last.viewAt!;
    }
    isLoadingMore.value = true;
    var res = await UserHttp.historyList(max, viewAt);
    isLoadingMore.value = false;
    if (res['status']) {
      if (type == 'onload') {
        historyList.addAll(res['data'].list);
      } else {
        historyList.value = res['data'].list;
      }
    }
    return res;
  }

  Future onLoad() async {
    queryHistoryList(type: 'onload');
  }

  Future onRefresh() async {
    queryHistoryList(type: 'onRefresh');
  }

  // 暂停观看历史
  Future onPauseHistory() async {
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content:
              Text(!pauseStatus.value ? '啊叻？你要暂停历史记录功能吗？' : '啊叻？要恢复历史记录功能吗？'),
          actions: [
            TextButton(
                onPressed: () => SmartDialog.dismiss(),
                child: const Text('取消')),
            TextButton(
              onPressed: () async {
                SmartDialog.showLoading(msg: '请求中');
                var res = await UserHttp.pauseHistory(!pauseStatus.value);
                SmartDialog.dismiss();
                if (res.data['code'] == 0) {
                  SmartDialog.showToast(
                      !pauseStatus.value ? '暂停观看历史' : '恢复观看历史');
                  pauseStatus.value = !pauseStatus.value;
                  localCache.put(LocalCacheKey.historyPause, pauseStatus.value);
                }
                SmartDialog.dismiss();
              },
              child: Text(!pauseStatus.value ? '确认暂停' : '确认恢复'),
            )
          ],
        );
      },
    );
  }

  // 观看历史暂停状态
  Future historyStatus() async {
    var res = await UserHttp.historyStatus();
    pauseStatus.value = res.data['data'];
    localCache.put(LocalCacheKey.historyPause, res.data['data']);
  }

  // 清空观看历史
  Future onClearHistory() async {
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('啊叻？你要清空历史记录功能吗？'),
          actions: [
            TextButton(
                onPressed: () => SmartDialog.dismiss(),
                child: const Text('取消')),
            TextButton(
              onPressed: () async {
                SmartDialog.showLoading(msg: '请求中');
                var res = await UserHttp.clearHistory();
                SmartDialog.dismiss();
                if (res.data['code'] == 0) {
                  SmartDialog.showToast('清空观看历史');
                }
                SmartDialog.dismiss();
                historyList.clear();
              },
              child: const Text('确认清空'),
            )
          ],
        );
      },
    );
  }
}
