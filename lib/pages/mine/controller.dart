import 'package:get/get.dart';
import 'package:pilipala/http/user.dart';

class MineController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // queryUserInfo();
  }

  Future queryUserInfo() async {
    var res = await UserHttp.userInfo();
  }
}
