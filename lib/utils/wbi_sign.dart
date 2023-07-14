// Wbi签名 用于生成 REST API 请求中的 w_rid 和 wts 字段
// https://github.com/SocialSisterYi/bilibili-API-collect/blob/master/docs/misc/sign/wbi.md
// import md5 from 'md5'
// import axios from 'axios'
import 'package:pilipala/http/index.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class WbiSign {
  List mixinKeyEncTab = [
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
  String getMixinKey(orig) {
    String temp = '';
    for (int i = 0; i < mixinKeyEncTab.length; i++) {
      temp += orig.split('')[mixinKeyEncTab[i]];
    }
    return temp.substring(0, 32);
  }

  // 为请求参数进行 wbi 签名
  String encWbi(params, imgKey, subKey) {
    String mixinKey = getMixinKey(imgKey + subKey);
    DateTime now = DateTime.now();
    int currTime = (now.millisecondsSinceEpoch / 1000).round();
    RegExp chrFilter = RegExp(r"[!\'\(\)*]");
    List query = [];
    Map newParams = Map.from(params)..addAll({"wts": currTime}); // 添加 wts 字段
    // 按照 key 重排参数
    List keys = newParams.keys.toList()..sort();
    for (var i in keys) {
      query.add(
          '${Uri.encodeComponent(i)}=${Uri.encodeComponent(newParams[i].toString().replaceAll(chrFilter, ''))}');
    }
    String queryStr = query.join('&');
    String wbiSign =
        md5.convert(utf8.encode(queryStr + mixinKey)).toString(); // 计算 w_rid
    print('w_rid: $wbiSign');
    return '$queryStr&w_rid=$wbiSign';
  }

  // 获取最新的 img_key 和 sub_key
  static Future<Map<String, dynamic>> getWbiKeys() async {
    var resp =
        await Request().get('https://api.bilibili.com/x/web-interface/nav');
    var jsonContent = resp.data['data'];

    String imgUrl = jsonContent['wbi_img']['img_url'];
    String subUrl = jsonContent['wbi_img']['sub_url'];
    return {
      'imgKey': imgUrl
          .substring(imgUrl.lastIndexOf('/') + 1, imgUrl.length)
          .split('.')[0],
      'subKey': subUrl
          .substring(subUrl.lastIndexOf('/') + 1, subUrl.length)
          .split('.')[0]
    };
  }

  makSign(Map<String, dynamic> params) async {
    // params 为需要加密的请求参数
    Map<String, dynamic> wbiKeys = await getWbiKeys();
    String query = encWbi(params, wbiKeys['imgKey'], wbiKeys['subKey']);
    return query;
  }
}
