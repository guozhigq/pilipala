import 'package:hive/hive.dart';
import 'package:pilipala/http/user.dart';

import 'storage.dart';

class Data {
  static Future init() async {
    await historyStatus();
  }

  static Future historyStatus() async {
    Box localCache = GStorage.localCache;
    Box userInfoCache = GStorage.userInfo;
    if (userInfoCache.get('userInfoCache') == null) {
      return;
    }
    var res = await UserHttp.historyStatus();
    localCache.put(LocalCacheKey.historyPause, res.data['data']);
  }
}
