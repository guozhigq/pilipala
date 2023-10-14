import 'package:get/get.dart';
import 'package:pilipala/http/member.dart';

class ArchiveController extends GetxController {
  ArchiveController(this.mid);
  int? mid;
  int pn = 1;
  int count = 0;
  RxMap<String, String> currentOrder = <String, String>{}.obs;
  List<Map<String, String>> orderList = [
    {'type': 'pubdate', 'label': '最新发布'},
    {'type': 'click', 'label': '最多播放'},
    {'type': 'stow', 'label': '最多收藏'},
  ];

  @override
  void onInit() {
    super.onInit();
    mid ??= int.parse(Get.parameters['mid']!);
    print('🐶🐶： $mid');
    currentOrder.value = orderList.first;
  }

  // 获取用户投稿
  Future getMemberArchive() async {
    var res = await MemberHttp.memberArchive(
        mid: mid, pn: pn, order: currentOrder['type']!);
    if (res['status']) {
      count = res['data'].page['count'];
      pn += 1;
    }
    return res;
  }

  toggleSort() async {
    pn = 1;
    int index = orderList.indexOf(currentOrder.value);
    if (index == orderList.length - 1) {
      currentOrder.value = orderList.first;
    } else {
      currentOrder.value = orderList[index + 1];
    }
  }
}
