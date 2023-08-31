import 'package:appscheme/appscheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/common/search_type.dart';

import 'id_utils.dart';
import 'utils.dart';

class PiliSchame {
  static AppScheme appScheme = AppSchemeImpl.getInstance() as AppScheme;
  static void init() async {
    ///
    SchemeEntity? value = await appScheme.getInitScheme();
    if (value != null) {
      _routePush(value);
    }

    /// 完整链接进入 b23.无效
    appScheme.getLatestScheme().then((value) {
      if (value != null) {
        _fullPathPush(value);
      }
    });

    /// 注册从外部打开的Scheme监听信息 #
    appScheme.registerSchemeListener().listen((event) {
      if (event != null) {
        _routePush(event);
      }
    });
  }

  /// 路由跳转
  static void _routePush(value) async {
    String scheme = value.scheme;
    String host = value.host;
    String path = value.path;

    if (scheme == 'bilibili') {
      // bilibili://root
      if (host == 'root') {
        Navigator.popUntil(Get.context!, (route) => route.isFirst);
      }

      // bilibili://space/{uid}
      else if (host == 'space') {
        var mid = path.split('/').last;
        Get.toNamed(
          '/member?mid=$mid',
          arguments: {'face': null},
        );
      }

      // bilibili://video/{aid}
      else if (host == 'video') {
        var pathQuery = path.split('/').last;
        int aid = int.parse(pathQuery);
        _videoPush(aid, null);
      }

      // bilibili://live/{roomid}
      else if (host == 'live') {
        var roomId = path.split('/').last;
        Get.toNamed('/liveRoom?roomid=$roomId',
            arguments: {'liveItem': null, 'heroTag': roomId.toString()});
      }

      // bilibili://bangumi/season/${ssid}
      else if (host == 'bangumi') {
        if (path.startsWith('/season')) {
          var seasonId = path.split('/').last;
          _bangumiPush(int.parse(seasonId));
        }
      }
    }
  }

  // 投稿跳转
  static void _videoPush(int? aidVal, String? bvidVal) async {
    SmartDialog.showLoading(msg: '获取中...');
    try {
      int? aid = aidVal;
      String? bvid = bvidVal;
      if (aidVal == null) {
        aid = IdUtils.bv2av(bvidVal!);
      }
      if (bvidVal == null) {
        bvid = IdUtils.av2bv(aidVal!);
      }
      int cid = await SearchHttp.ab2c(bvid: bvidVal, aid: aidVal);
      String heroTag = Utils.makeHeroTag(aid);
      SmartDialog.dismiss().then(
        (e) => Get.toNamed('/video?bvid=$bvid&cid=$cid', arguments: {
          'pic': null,
          'heroTag': heroTag,
        }),
      );
    } catch (e) {
      SmartDialog.showToast('video获取失败：${e.toString()}');
    }
  }

  // 番剧跳转
  static void _bangumiPush(int seasonId) async {
    SmartDialog.showLoading(msg: '获取中...');
    try {
      var result = await SearchHttp.bangumiInfo(seasonId: seasonId, epId: null);
      if (result['status']) {
        var bangumiDetail = result['data'];
        int cid = bangumiDetail.episodes!.first.cid;
        String bvid = IdUtils.av2bv(bangumiDetail.episodes!.first.aid);
        String heroTag = Utils.makeHeroTag(cid);
        var epId = bangumiDetail.episodes!.first.id;
        SmartDialog.dismiss().then(
          (e) => Get.toNamed(
            '/video?bvid=$bvid&cid=$cid&epId=$epId',
            arguments: {
              'pic': bangumiDetail.cover,
              'heroTag': heroTag,
              'videoType': SearchType.media_bangumi,
            },
          ),
        );
      }
    } catch (e) {
      SmartDialog.showToast('番剧获取失败：${e.toString()}');
    }
  }

  static void _fullPathPush(value) async {
    // https://m.bilibili.com/bangumi/play/ss39708
    // https | m.bilibili.com | /bangumi/play/ss39708
    String scheme = value.scheme!;
    String host = value.host!;
    String? path = value.path;
    // Map<String, String> query = value.query!;
    if (host.startsWith('live.bilibili')) {
      int roomId = int.parse(path!.split('/').last);
      // print('直播');
      Get.toNamed('/liveRoom?roomid=$roomId',
          arguments: {'liveItem': null, 'heroTag': roomId.toString()});
      return;
    }
    if (host.startsWith('space.bilibili')) {
      print('个人空间');
      return;
    }
    if (path != null) {
      String area = path.split('/')[1];
      switch (area) {
        case 'bangumi':
          // print('番剧');
          String seasonId = path.split('/').last;
          _bangumiPush(matchNum(seasonId).first);
          break;
        case 'video':
          // print('投稿');
          Map map = IdUtils.matchAvorBv(input: path);
          if (map.containsKey('AV')) {
            _videoPush(map['AV'], null);
          } else if (map.containsKey('BV')) {
            _videoPush(null, map['BV']);
          } else {
            SmartDialog.showToast('投稿匹配失败');
          }
          break;
        case 'read':
          print('专栏');
          break;
        case 'space':
          print('个人空间');
          break;
      }
    }
  }

  static List<int> matchNum(String str) {
    RegExp regExp = RegExp(r'\d+');
    Iterable<Match> matches = regExp.allMatches(str);

    return matches.map((match) => int.parse(match.group(0)!)).toList();
  }
}
