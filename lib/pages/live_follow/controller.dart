import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/live.dart';
import 'package:pilipala/models/live/follow.dart';
import 'package:pilipala/utils/storage.dart';

class LiveFollowController extends GetxController {
  RxInt crossAxisCount = 2.obs;
  Box setting = GStrorage.setting;
  int _currentPage = 1;
  RxInt liveFollowingCount = 0.obs;
  RxList<LiveFollowingItemModel> liveFollowingList =
      <LiveFollowingItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    crossAxisCount.value =
        setting.get(SettingBoxKey.customRows, defaultValue: 2);
  }

  Future queryLiveFollowList(type) async {
    var res = await LiveHttp.liveFollowing(
      pn: _currentPage,
      ps: 20,
    );
    if (res['status']) {
      if (type == 'init') {
        liveFollowingList.value = res['data'].list;
        liveFollowingCount.value = res['data'].liveCount;
      } else if (type == 'onLoad') {
        liveFollowingList.addAll(res['data'].list);
      }
      _currentPage += 1;
    } else {
      SmartDialog.showToast(res['msg']);
    }
    return res;
  }

  Future onRefresh() async {
    _currentPage = 1;
    await queryLiveFollowList('init');
  }

  void onLoad() async {
    queryLiveFollowList('onLoad');
  }
}
