// ignore_for_file: avoid_print

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../pages/mine/controller.dart';
import 'api.dart';

class AnonymityInterceptor extends Interceptor {
  static const List<String> anonymityList = [
    Api.videoUrl,
    Api.videoIntro,
    Api.relatedList,
    Api.replyList,
    Api.replyReplyList,
    Api.searchSuggest,
    Api.searchByType,
    Api.heartBeat,
    Api.ab2c,
    Api.bangumiInfo,
    Api.liveRoomInfo,
    Api.onlineTotal,
    Api.webDanmaku,
    Api.dynamicDetail,
    Api.aiConclusion,
    Api.getMemberViewApi,
    Api.getSeasonDetailApi,
  ];


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (MineController.anonymity) {
      String uri = options.uri.toString();
      for (var i in anonymityList) {
        // 如果请求的url包含无痕列表中的url，则清空cookie
        // 但需要保证匹配到url的后半部分不再出现/符号，否则会误伤
        int index = uri.indexOf(i);
        if (index == -1) continue;
        if (uri.lastIndexOf('/') >= index + i.length) continue;
        //SmartDialog.showToast('触发无痕模式\n\n$i\n\n${options.uri}');
        options.headers[HttpHeaders.cookieHeader] = "";
        if(options.data != null && options.data.csrf != null) {
          options.data.csrf = "";
        }
        break;
      }
    }
    handler.next(options);
  }
}
