import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:pilipala/models/read/opus.dart';
import 'package:pilipala/models/read/read.dart';
import 'package:pilipala/utils/wbi_sign.dart';
import 'index.dart';

class ReadHttp {
  static List<String> extractScriptContents(String htmlContent) {
    RegExp scriptRegExp = RegExp(r'<script>([\s\S]*?)<\/script>');
    Iterable<Match> matches = scriptRegExp.allMatches(htmlContent);
    List<String> scriptContents = [];
    for (Match match in matches) {
      String scriptContent = match.group(1)!;
      scriptContents.add(scriptContent);
    }
    return scriptContents;
  }

  // 解析专栏 opus格式
  static Future parseArticleOpus({required String id}) async {
    var res = await Request().get('https://www.bilibili.com/opus/$id', extra: {
      'ua': 'pc',
    });
    String? headContent = parse(res.data).head?.outerHtml;
    var document = parse(headContent);
    var linkTags = document.getElementsByTagName('link');
    bool isCv = false;
    String cvId = '';
    for (var linkTag in linkTags) {
      var attributes = linkTag.attributes;
      if (attributes.containsKey('rel') &&
          attributes['rel'] == 'canonical' &&
          attributes.containsKey('data-vue-meta') &&
          attributes['data-vue-meta'] == 'true') {
        final String cvHref = linkTag.attributes['href']!;
        RegExp regex = RegExp(r'cv(\d+)');
        RegExpMatch? match = regex.firstMatch(cvHref);
        if (match != null) {
          cvId = match.group(1)!;
        } else {
          print('No match found.');
        }
        isCv = true;
        break;
      }
    }
    String scriptContent =
        extractScriptContents(parse(res.data).body!.outerHtml)[0];
    int startIndex = scriptContent.indexOf('{');
    int endIndex = scriptContent.lastIndexOf('};');
    String jsonContent = scriptContent.substring(startIndex, endIndex + 1);
    // 解析JSON字符串为Map
    Map<String, dynamic> jsonData = json.decode(jsonContent);
    return {
      'status': true,
      'data': OpusDataModel.fromJson(jsonData),
      'isCv': isCv,
      'cvId': cvId,
    };
  }

  // 解析专栏 cv格式
  static Future parseArticleCv({required String id}) async {
    var res = await Request().get(
      'https://www.bilibili.com/read/cv$id',
      extra: {'ua': 'pc'},
      options: Options(
        headers: {
          'cookie': 'opus-goback=1',
        },
      ),
    );
    String scriptContent =
        extractScriptContents(parse(res.data).body!.outerHtml)[0];
    int startIndex = scriptContent.indexOf('{');
    int endIndex = scriptContent.lastIndexOf('};');
    String jsonContent = scriptContent.substring(startIndex, endIndex + 1);
    // 解析JSON字符串为Map
    Map<String, dynamic> jsonData = json.decode(jsonContent);
    return {
      'status': true,
      'data': ReadDataModel.fromJson(jsonData),
    };
  }

  //
  static Future getViewInfo({required String id}) async {
    Map params = await WbiSign().makSign({
      'id': id,
      'mobi_app': 'pc',
      'from': 'web',
      'gaia_source': 'main_web',
      'web_location': 333.976,
    });
    var res = await Request().get(
      Api.getViewInfo,
      data: {
        'id': id,
        'mobi_app': 'pc',
        'from': 'web',
        'gaia_source': 'main_web',
        'web_location': 333.976,
        'w_rid': params['w_rid'],
        'wts': params['wts'],
      },
    );
    if (res.data['code'] == 0) {
      return {
        'status': true,
        'data': res.data['data'],
      };
    } else {
      return {
        'status': false,
        'data': [],
        'msg': res.data['message'],
      };
    }
  }
}
