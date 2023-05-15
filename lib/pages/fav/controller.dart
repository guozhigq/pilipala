import 'package:get/get.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/utils/storage.dart';

class FavController extends GetxController {
  Rx<FavFolderData> favFolderData = FavFolderData().obs;

  Future<dynamic> queryFavFolder() async {
    var res = await await UserHttp.userfavFolder(
      pn: 1,
      ps: 10,
      mid: GStrorage.user.get(UserBoxKey.userMid),
    );
    favFolderData.value = res['data'];
    return res;
  }
}
