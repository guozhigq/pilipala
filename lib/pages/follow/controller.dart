import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/follow.dart';
import 'package:pilipala/models/follow/result.dart';
import 'package:pilipala/utils/storage.dart';

class FollowController extends GetxController {
  Box userInfoCache = GStrorage.userInfo;
  int pn = 1;
  int total = 0;
  RxList<FollowItemModel> followList = [FollowItemModel()].obs;
  late int mid;
  late String name;
  var userInfo;

  @override
  void onInit() {
    super.onInit();
    userInfo = userInfoCache.get('userInfoCache');
    mid = Get.parameters['mid'] != null
        ? int.parse(Get.parameters['mid']!)
        : userInfo.mid;
    name = Get.parameters['name'] ?? userInfo.uname;
  }

  Future queryFollowings(type) async {
    if (type == 'init') {
      pn = 1;
    }
    var res = await FollowHttp.followings(
      vmid: mid,
      pn: pn,
      ps: 20,
      orderType: 'attention',
    );
    if (res['status']) {
      if (type == 'init') {
        followList.value = res['data'].list;
        total = res['data'].total;
      } else if (type == 'onRefresh') {
        followList.insertAll(0, res['data'].list);
      } else if (type == 'onLoad') {
        followList.addAll(res['data'].list);
      }
      pn += 1;
    }
    return res;
  }
}
