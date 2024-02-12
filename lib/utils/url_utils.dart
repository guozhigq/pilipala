import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../http/search.dart';
import 'id_utils.dart';
import 'utils.dart';

class UrlUtils {
  // 302重定向路由截取
  static Future<String> parseRedirectUrl(String url) async {
    late String redirectUrl;
    final dio = Dio();
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) {
      return status == 200 || status == 301 || status == 302;
    };
    final response = await dio.get(url);
    if (response.statusCode == 302) {
      redirectUrl = response.headers['location']?.first as String;
      if (redirectUrl.endsWith('/')) {
        redirectUrl = redirectUrl.substring(0, redirectUrl.length - 1);
      }
    } else {
      if (url.endsWith('/')) {
        url = url.substring(0, url.length - 1);
      }
      return url;
    }
    return redirectUrl;
  }

  // 匹配url路由跳转
  static matchUrlPush(
    String pathSegment,
    String title,
    String redirectUrl,
  ) async {
    final Map matchRes = IdUtils.matchAvorBv(input: pathSegment);
    if (matchRes.containsKey('BV')) {
      final String bv = matchRes['BV'];
      final int cid = await SearchHttp.ab2c(bvid: bv);
      final String heroTag = Utils.makeHeroTag(bv);
      await Get.toNamed(
        '/video?bvid=$bv&cid=$cid',
        arguments: <String, String?>{
          'pic': '',
          'heroTag': heroTag,
        },
      );
    } else {
      await Get.toNamed(
        '/webview',
        parameters: {
          'url': redirectUrl,
          'type': 'url',
          'pageTitle': title,
        },
      );
    }
  }
}
