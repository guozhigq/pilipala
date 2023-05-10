import 'package:pilipala/http/api.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/models/user/info.dart';
import 'package:pilipala/models/user/stat.dart';

class UserHttp {
  static Future<dynamic> userStat({required int mid}) async {
    var res = await Request().get(Api.userStat, data: {'vmid': mid});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']};
    } else {
      return {'status': false};
    }
  }

  static Future<dynamic> userInfo() async {
    var res = await Request().get(Api.userInfo);
    if (res.data['code'] == 0) {
      UserInfoData data = UserInfoData.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'msg': res.data['message']};
    }
  }

  static Future<dynamic> userStatOwner() async {
    var res = await Request().get(Api.userStatOwner);
    if (res.data['code'] == 0) {
      UserStat data = UserStat.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }

  // 收藏夹
  static Future<dynamic> userfavFolder({
    required int pn,
    required int ps,
    required int mid,
  }) async {
    var res = await Request().get(Api.userFavFolder, data: {
      'pn': pn,
      'ps': ps,
      'up_mid': mid,
    });
    if (res.data['code'] == 0) {
      FavFolderData data = FavFolderData.fromJson(res.data['data']);
      return {'status': true, 'data': data};
    } else {
      return {'status': false, 'data': [], 'msg': res.data['message']};
    }
  }
}
