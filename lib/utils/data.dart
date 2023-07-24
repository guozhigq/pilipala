import 'package:hive/hive.dart';
import 'package:pilipala/http/user.dart';

import 'storage.dart';

class Data {
  static Future init() async {
    await historyStatus();
  }

  static Future historyStatus() async {
    Box localCache = GStrorage.localCache;
    var res = await UserHttp.historyStatus();
    localCache.put(LocalCacheKey.historyStatus, res.data['data']);
  }
}
