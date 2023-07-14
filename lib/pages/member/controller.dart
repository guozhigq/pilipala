import 'package:get/get.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/utils/wbi_sign.dart';

class MemberController extends GetxController {
  late int mid;

  @override
  void onInit() {
    super.onInit();
    mid = int.parse(Get.parameters['mid']!);
    getInfo();
  }

  getInfo() async {
    String params = await WbiSign().makSign({
      'mid': mid,
      'token': '',
      'platform': 'web',
      'web_location': 1550101,
    });
    params = '?$params';
    var res = await MemberHttp.memberInfo(params: params);
    if (res['status']) {
      print(res['data']);
    }
  }
}
