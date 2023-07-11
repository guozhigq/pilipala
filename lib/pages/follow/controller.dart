import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/follow.dart';
import 'package:pilipala/models/follow/result.dart';
import 'package:pilipala/utils/storage.dart';

class FollowController extends GetxController {
  Box user = GStrorage.user;
  int pn = 1;
  int total = 0;
  RxList<FollowItemModel> followList = [FollowItemModel()].obs;

  Future queryFollowings(type) async {
    if (type == 'init') {
      pn = 1;
    }
    var res = await FollowHttp.followings(
      vmid: user.get(UserBoxKey.userMid),
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
