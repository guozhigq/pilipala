// Wbi签名 用于生成 REST API 请求中的 w_rid 和 wts 字段
// https://github.com/SocialSisterYi/bilibili-API-collect/blob/master/docs/misc/sign/wbi.md
// import md5 from 'md5'
// import axios from 'axios'
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import '../http/index.dart';
import 'storage.dart';

class WbiSign {
  static Box<dynamic> localCache = GStrorage.localCache;
  final List<int> mixinKeyEncTab = <int>[
    46,
    47,
    18,
    2,
    53,
    8,
    23,
    32,
    15,
    50,
    10,
    31,
    58,
    3,
    45,
    35,
    27,
    43,
    5,
    49,
    33,
    9,
    42,
    19,
    29,
    28,
    14,
    39,
    12,
    38,
    41,
    13,
    37,
    48,
    7,
    16,
    24,
    55,
    40,
    61,
    26,
    17,
    0,
    1,
    60,
    51,
    30,
    4,
    22,
    25,
    54,
    21,
    56,
    59,
    6,
    63,
    57,
    62,
    11,
    36,
    20,
    34,
    44,
    52
  ];
  // 对 imgKey 和 subKey 进行字符顺序打乱编码
  String getMixinKey(String orig) {
    String temp = '';
    for (int i = 0; i < mixinKeyEncTab.length; i++) {
      temp += orig[mixinKeyEncTab[i]];
    }
    return temp.substring(0, 32);
  }

  // 为请求参数进行 wbi 签名
  Map<String, dynamic> encWbi(
      Map<String, dynamic> params, String imgKey, String subKey) {
    final String mixinKey = getMixinKey(imgKey + subKey);
    final DateTime now = DateTime.now();
    final int currTime = (now.millisecondsSinceEpoch / 1000).round();
    final RegExp chrFilter = RegExp(r"[!\'\(\)*]");
    final List<String> query = <String>[];
    final Map<String, dynamic> newParams = Map.from(params)
      ..addAll({"wts": currTime}); // 添加 wts 字段
    // 按照 key 重排参数
    final List<String> keys = newParams.keys.toList()..sort();
    for (String i in keys) {
      query.add(
          '${Uri.encodeComponent(i)}=${Uri.encodeComponent(newParams[i].toString().replaceAll(chrFilter, ''))}');
    }
    final String queryStr = query.join('&');
    final String wbiSign =
        md5.convert(utf8.encode(queryStr + mixinKey)).toString(); // 计算 w_rid
    return {'w_rid': wbiSign,'wts': currTime.toString()};
  }

  // 获取最新的 img_key 和 sub_key 可以从缓存中获取
  static Future<Map<String, dynamic>> getWbiKeys() async {
    final DateTime nowDate = DateTime.now();
    if (localCache.get(LocalCacheKey.wbiKeys) != null &&
        DateTime.fromMillisecondsSinceEpoch(
                    localCache.get(LocalCacheKey.timeStamp) as int)
                .day ==
            nowDate.day) {
      final Map cacheWbiKeys = localCache.get('wbiKeys');
      return Map<String, dynamic>.from(cacheWbiKeys);
    }
    var resp =
        await Request().get('https://api.bilibili.com/x/web-interface/nav');
    var jsonContent = resp.data['data'];

    final String imgUrl = jsonContent['wbi_img']['img_url'];
    final String subUrl = jsonContent['wbi_img']['sub_url'];
    final Map<String, dynamic> wbiKeys = {
      'imgKey': imgUrl
          .substring(imgUrl.lastIndexOf('/') + 1, imgUrl.length)
          .split('.')[0],
      'subKey': subUrl
          .substring(subUrl.lastIndexOf('/') + 1, subUrl.length)
          .split('.')[0]
    };
    localCache.put(LocalCacheKey.wbiKeys, wbiKeys);
    localCache.put(LocalCacheKey.timeStamp, nowDate.millisecondsSinceEpoch);
    return wbiKeys;
  }

  Future<Map<String, dynamic>> makSign(Map<String, dynamic> params) async {
    // params 为需要加密的请求参数
    final Map<String, dynamic> wbiKeys = await getWbiKeys();
    final Map<String, dynamic> query = params
      ..addAll(encWbi(params, wbiKeys['imgKey'], wbiKeys['subKey']));
    return query;
  }
}
