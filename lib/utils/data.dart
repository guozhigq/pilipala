import 'package:hive/hive.dart';
import 'package:pilipala/http/user.dart';

import 'storage.dart';

class Data {
  static Future init() async {
    await historyStatus();
  }

  static Future historyStatus() async {
    Box localCache = GStrorage.localCache;
    Box user = GStrorage.user;
    if (user.get(UserBoxKey.userMid) == null) {
      return;
    }
    var res = await UserHttp.historyStatus();
    localCache.put(LocalCacheKey.historyPause, res.data['data']);
  }
}
