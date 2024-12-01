import 'package:pilipala/models/common/invalid_video.dart';
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/models/sponsor_block/segment.dart';

import 'index.dart';

class CommonHttp {
  static final RegExp spmPrefixExp =
      RegExp(r'<meta name="spm_prefix" content="([^"]+?)">');
  static Future unReadDynamic() async {
    var res = await Request().get(Api.getUnreadDynamic,
        data: {'alltype_offset': 0, 'video_offset': '', 'article_offset': 0});
    if (res.data['code'] == 0) {
      return {'status': true, 'data': res.data['data']['dyn_basic_infos']};
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }

  static Future querySkipSegments({required String bvid}) async {
    var res = await Request().getWithoutCookie(Api.getSkipSegments, data: {
      'videoID': bvid,
    });
    if (res.data is List && res.data.isNotEmpty) {
      try {
        return {
          'status': true,
          'data': res.data
              .map<SegmentDataModel>((e) => SegmentDataModel.fromJson(e))
              .toList(),
        };
      } catch (err) {
        return {
          'status': false,
          'data': [],
          'msg': 'sponsorBlock数据解析失败: $err',
        };
      }
    } else {
      return {
        'status': false,
        'data': [],
      };
    }
  }

  static Future fixVideoPicAndTitle({required int aid}) async {
    var res = await Request().getWithoutCookie(Api.fixTitleAndPic, data: {
      'id': aid,
    });
    if (res != null) {
      if (res.data['code'] == -404) {
        return {
          'status': false,
          'data': null,
          'msg': '没有相关信息',
        };
      } else {
        return {
          'status': true,
          'data': InvalidVideoModel.fromJson(res.data),
        };
      }
    } else {
      return {
        'status': false,
        'data': null,
        'msg': '没有相关信息',
      };
    }
  }

  static Future buvidActivate() async {
    try {
      // 获取 HTML 数据
      var html = await Request().get(Api.dynamicSpmPrefix);

      // 提取 spmPrefix
      String spmPrefix = spmPrefixExp.firstMatch(html.data)?.group(1) ?? '';

      // 生成随机 PNG 结束部分
      Random rand = Random();
      String randPngEnd = base64.encode(
        List<int>.generate(32, (_) => rand.nextInt(256))
          ..addAll(List<int>.filled(4, 0))
          ..addAll([73, 69, 78, 68])
          ..addAll(List<int>.generate(4, (_) => rand.nextInt(256))),
      );

      // 构建 JSON 数据
      String jsonData = json.encode({
        '3064': 1,
        '39c8': '$spmPrefix.fp.risk',
        '3c43': {
          'adca': 'Linux',
          'bfe9': randPngEnd.substring(randPngEnd.length - 50),
        },
      });

      // 发送 POST 请求
      await Request().post(
        Api.activateBuvidApi,
        data: {'payload': jsonData},
        options: Options(contentType: 'application/json'),
      );
    } catch (err) {
      debugPrint('buvidActivate error: $err');
    }
  }
}
