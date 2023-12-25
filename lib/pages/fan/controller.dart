import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/fan.dart';
import 'package:pilipala/models/fans/result.dart';
import 'package:pilipala/utils/storage.dart';

class FansController extends GetxController {
  Box userInfoCache = GStrorage.userInfo;
  int pn = 1;
  int ps = 20;
  int total = 0;
  RxList<FansItemModel> fansList = [FansItemModel()].obs;
  late int mid;
  late String name;
  var userInfo;
  RxString loadingText = '加载中...'.obs;
  RxBool isOwner = false.obs;

  @override
  void onInit() {
    super.onInit();
    userInfo = userInfoCache.get('userInfoCache');
    mid = Get.parameters['mid'] != null
        ? int.parse(Get.parameters['mid']!)
        : userInfo.mid;
    isOwner.value = mid == userInfo.mid;
    name = Get.parameters['name'] ?? userInfo.uname;
  }

  Future queryFans(type) async {
    if (type == 'init') {
      pn = 1;
      loadingText.value == '加载中...';
    }
    if (loadingText.value == '没有更多了') {
      return;
    }
    var res = await FanHttp.fans(
      vmid: mid,
      pn: pn,
      ps: ps,
      orderType: 'attention',
    );
    if (res['status']) {
      if (type == 'init') {
        fansList.value = res['data'].list;
        total = res['data'].total;
      } else if (type == 'onLoad') {
        fansList.addAll(res['data'].list);
      }
      print(total);
      if ((pn == 1 && total < ps) || res['data'].list.isEmpty) {
        loadingText.value = '没有更多了';
      }
      pn += 1;
    } else {
      SmartDialog.showToast(res['msg']);
    }
    return res;
  }
}
