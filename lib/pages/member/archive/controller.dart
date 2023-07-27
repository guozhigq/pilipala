import 'package:get/get.dart';
import 'package:pilipala/http/member.dart';

class ArchiveController extends GetxController {
  int? mid;
  int pn = 1;
  int count = 0;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
  }

  // 获取用户投稿
  Future getMemberArchive() async {
    var res = await MemberHttp.memberArchive(mid: mid, pn: pn);
    if (res['status']) {
      count = res['data'].page['count'];
      pn += 1;
    }
    return res;
  }
}
