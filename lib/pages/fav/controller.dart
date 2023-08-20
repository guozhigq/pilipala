import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/models/user/info.dart';
import 'package:pilipala/utils/storage.dart';

class FavController extends GetxController {
  Rx<FavFolderData> favFolderData = FavFolderData().obs;
  Box userInfoCache = GStrorage.userInfo;
  UserInfoData? userInfo;

  Future<dynamic> queryFavFolder() async {
    userInfo = userInfoCache.get('userInfoCache');
    if (userInfo == null) {
      return {'status': false, 'msg': '账号未登录'};
    }
    var res = await await UserHttp.userfavFolder(
      pn: 1,
      ps: 10,
      mid: userInfo!.mid!,
    );
    if (res['status']) {
      favFolderData.value = res['data'];
    }
    return res;
  }
}
