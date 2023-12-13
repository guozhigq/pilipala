import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pilipala/http/index.dart';
import 'package:pilipala/models/danmaku/dm.pb.dart';

import 'constants.dart';

class DanmakaHttp {
  // 获取视频弹幕
  static Future queryDanmaku({
    required int cid,
    required int segmentIndex,
  }) async {
    // 构建参数对象
    Map<String, int> params = {
      'type': 1,
      'oid': cid,
      'segment_index': segmentIndex,
    };
    var response = await Request().get(
      Api.webDanmaku,
      data: params,
      extra: {'resType': ResponseType.bytes},
    );
    return DmSegMobileReply.fromBuffer(response.data);
  }
  static Future shootDanmaku({
    int type = 1,//弹幕类选择(1：视频弹幕 2：漫画弹幕)
    required int oid,// 视频cid
    required String msg,//弹幕文本(长度小于 100 字符)
    int mode = 1,// 弹幕类型(1：滚动弹幕 4：底端弹幕 5：顶端弹幕 6：逆向弹幕(不能使用） 7：高级弹幕 8：代码弹幕（不能使用） 9：BAS弹幕（pool必须为2）)
    // String? aid,// 稿件avid
    // String? bvid,// bvid与aid必须有一个
    required String bvid,
    int? progress,// 弹幕出现在视频内的时间（单位为毫秒，默认为0）
    int? color,// 弹幕颜色(默认白色，16777215）
    int? fontsize,// 弹幕字号（默认25）
    int? pool,// 弹幕池选择（0：普通池 1：字幕池 2：特殊池（代码/BAS弹幕）默认普通池，0）
    //int? rnd,// 当前时间戳*1000000（若无此项，则发送弹幕冷却时间限制为90s；若有此项，则发送弹幕冷却时间限制为5s）
    int? colorful,//60001：专属渐变彩色（需要会员）
    int? checkbox_type,//是否带 UP 身份标识（0：普通；4：带有标识）
    // String? csrf,//CSRF Token（位于 Cookie）	Cookie 方式必要
    // String? access_key,//	APP 登录 Token		APP 方式必要
  }) async {
    // 构建参数对象
    // assert(aid != null || bvid != null);
    // assert(csrf != null || access_key != null);
    assert(msg.length < 100);
    // 构建参数对象
    var params = <String, dynamic>{
      'type': type,
      'oid': oid,
      'msg': msg,
      'mode': mode,
      //'aid': aid,
      'bvid': bvid,
      'progress': progress,
      'color': color,
      'fontsize': fontsize,
      'pool': pool,
      'rnd': DateTime.now().microsecondsSinceEpoch,
      'colorful': colorful,
      'checkbox_type': checkbox_type,
      'csrf': await Request.getCsrf(),
      // 'access_key': access_key,
    }..removeWhere((key, value) => value == null);

    var response = await Request().post(
      Api.shootDanmaku,
      data: params,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (response.statusCode != 200) {
      return {
        'status': false,
        'data': [],
        'msg': '弹幕发送失败，状态码:${response.statusCode}',
      };
    }
    if (response.data['code'] == 0) {
      return {
        'status': true,
        'data': response.data['data'],
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': "${response.data['code']}: ${response.data['message']}",
      };
    }
  }
}
