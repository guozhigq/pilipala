import 'package:get/get.dart';
import 'package:pilipala/http/member.dart';

class MemberDynamicPanelController extends GetxController {
  MemberDynamicPanelController(this.mid);
  int? mid;
  String offset = '';
  int count = 0;

  @override
  void onInit() {
    super.onInit();
    mid ??= int.parse(Get.parameters['mid']!);
  }

  Future getMemberDynamic() async {
    var res = await MemberHttp.memberDynamic(
      offset: offset,
      mid: mid,
    );
    if (res['status']) {
      offset = res['data'].offset;
    }
    return res;
  }
}
