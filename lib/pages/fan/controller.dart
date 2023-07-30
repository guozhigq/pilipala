import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/fan.dart';
import 'package:pilipala/models/fans/result.dart';
import 'package:pilipala/utils/storage.dart';

class FansController extends GetxController {
  Box user = GStrorage.user;
  int pn = 1;
  int total = 0;
  RxList<FansItemModel> fansList = [FansItemModel()].obs;
  late int mid;
  late String name;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(
        Get.parameters['mid'] ?? user.get(UserBoxKey.userMid).toString());
    name = Get.parameters['name'] ?? user.get(UserBoxKey.userName);
  }

  Future queryFans(type) async {
    if (type == 'init') {
      pn = 1;
    }
    var res = await FanHttp.fans(
      vmid: mid,
      pn: pn,
      ps: 20,
      orderType: 'attention',
    );
    if (res['status']) {
      if (type == 'init') {
        fansList.value = res['data'].list;
        total = res['data'].total;
      } else if (type == 'onRefresh') {
        fansList.insertAll(0, res['data'].list);
      } else if (type == 'onLoad') {
        fansList.addAll(res['data'].list);
      }
      pn += 1;
    }
    return res;
  }
}
