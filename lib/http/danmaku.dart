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
}
