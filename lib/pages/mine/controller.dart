import 'package:get/get.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/user/info.dart';

class MineController extends GetxController {
  UserInfoData? userInfo;

  @override
  void onInit() {
    super.onInit();
    // queryUserInfo();
  }

  Future queryUserInfo() async {
    var res = await UserHttp.userInfo();
  }
}
