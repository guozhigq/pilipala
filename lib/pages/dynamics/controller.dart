import 'package:get/get.dart';
import 'package:pilipala/http/dynamics.dart';
import 'package:pilipala/models/dynamics/result.dart';

class DynamicsController extends GetxController {
  int page = 1;
  String reqType = 'all';
  String? offset;
  RxList<DynamicItemModel>? dynamicsList = [DynamicItemModel()].obs;

  Future queryFollowDynamic({type = 'init'}) async {
    var res = await DynamicsHttp.followDynamic(
      page: page,
      type: reqType,
      offset: offset,
    );
    if (res['status']) {
      if (type == 'init') {
        dynamicsList!.value = res['data'].items;
      } else {
        dynamicsList!.addAll(res['data'].items);
      }
      offset = res['data'].offset;
    }
    return res;
  }
}
