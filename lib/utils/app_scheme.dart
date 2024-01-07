import 'package:appscheme/appscheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import '../http/search.dart';
import '../models/common/search_type.dart';
import 'id_utils.dart';
import 'utils.dart';

class PiliSchame {
  static AppScheme appScheme = AppSchemeImpl.getInstance()!;
  static Future<void> init() async {
    ///
    final SchemeEntity? value = await appScheme.getInitScheme();
    if (value != null) {
      _routePush(value);
    }

    /// 完整链接进入 b23.无效
    appScheme.getLatestScheme().then((SchemeEntity? value) {
      if (value != null) {
        _fullPathPush(value);
      }
    });

    /// 注册从外部打开的Scheme监听信息 #
    appScheme.registerSchemeListener().listen((SchemeEntity? event) {
      if (event != null) {
        _routePush(event);
      }
    });
  }

  /// 路由跳转
  static void _routePush(value) async {
    final String scheme = value.scheme;
    final String host = value.host;
    final String path = value.path;

    if (scheme == 'bilibili') {
      // bilibili://root
      if (host == 'root') {
        Navigator.popUntil(
            Get.context!, (Route<dynamic> route) => route.isFirst);
      }

      // bilibili://space/{uid}
      else if (host == 'space') {
        final String mid = path.split('/').last;
        Get.toNamed<dynamic>(
          '/member?mid=$mid',
          arguments: <String, dynamic>{'face': null},
        );
      }

      // bilibili://video/{aid}
      else if (host == 'video') {
        String pathQuery = path.split('/').last;
        final numericRegex = RegExp(r'^[0-9]+$');
        if (numericRegex.hasMatch(pathQuery)) {
          pathQuery = 'AV$pathQuery';
        }
        Map map = IdUtils.matchAvorBv(input: pathQuery);
        if (map.containsKey('AV')) {
          _videoPush(map['AV'], null);
        } else if (map.containsKey('BV')) {
          _videoPush(null, map['BV']);
        } else {
          SmartDialog.showToast('投稿匹配失败');
        }
      }

      // bilibili://live/{roomid}
      else if (host == 'live') {
        final String roomId = path.split('/').last;
        Get.toNamed<dynamic>('/liveRoom?roomid=$roomId',
            arguments: <String, String?>{'liveItem': null, 'heroTag': roomId});
      }

      // bilibili://bangumi/season/${ssid}
      else if (host == 'bangumi') {
        if (path.startsWith('/season')) {
          final String seasonId = path.split('/').last;
          _bangumiPush(int.parse(seasonId));
        }
      }
      // 专栏 bilibili://opus/detail/883089655985078289
      else if (host == 'opus') {
        if (path.startsWith('/detail')) {
          var opusId = path.split('/').last;
          Get.toNamed(
            '/webview',
            parameters: {
              'url': 'https://www.bilibili.com/opus/$opusId',
              'type': 'url',
              'pageTitle': '',
            },
          );
        }
      } else if (host == 'search') {
        Get.toNamed('/searchResult', parameters: {'keyword': ''});
      }
    }
  }

  // 投稿跳转
  static Future<void> _videoPush(int? aidVal, String? bvidVal) async {
    SmartDialog.showLoading<dynamic>(msg: '获取中...');
    try {
      int? aid = aidVal;
      String? bvid = bvidVal;
      if (aidVal == null) {
        aid = IdUtils.bv2av(bvidVal!);
      }
      if (bvidVal == null) {
        bvid = IdUtils.av2bv(aidVal!);
      }
      final int cid = await SearchHttp.ab2c(bvid: bvidVal, aid: aidVal);
      final String heroTag = Utils.makeHeroTag(aid);
      SmartDialog.dismiss<dynamic>().then(
        // ignore: always_specify_types
        (e) => Get.toNamed<dynamic>('/video?bvid=$bvid&cid=$cid',
            arguments: <String, String?>{
              'pic': null,
              'heroTag': heroTag,
            }),
      );
    } catch (e) {
      SmartDialog.showToast('video获取失败: $e');
    }
  }

  // 番剧跳转
  static Future<void> _bangumiPush(int seasonId) async {
    SmartDialog.showLoading<dynamic>(msg: '获取中...');
    try {
      var result = await SearchHttp.bangumiInfo(seasonId: seasonId, epId: null);
      if (result['status']) {
        var bangumiDetail = result['data'];
        final int cid = bangumiDetail.episodes!.first.cid;
        final String bvid = IdUtils.av2bv(bangumiDetail.episodes!.first.aid);
        final String heroTag = Utils.makeHeroTag(cid);
        var epId = bangumiDetail.episodes!.first.id;
        SmartDialog.dismiss().then(
          (e) => Get.toNamed(
            '/video?bvid=$bvid&cid=$cid&epId=$epId',
            arguments: <String, dynamic>{
              'pic': bangumiDetail.cover,
              'heroTag': heroTag,
              'videoType': SearchType.media_bangumi,
            },
          ),
        );
      }
    } catch (e) {
      SmartDialog.showToast('番剧获取失败：$e');
    }
  }

  static Future<void> _fullPathPush(SchemeEntity value) async {
    // https://m.bilibili.com/bangumi/play/ss39708
    // https | m.bilibili.com | /bangumi/play/ss39708
    // final String scheme = value.scheme!;
    final String host = value.host!;
    final String? path = value.path;
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
      final String area = path.split('/')[1];
      switch (area) {
        case 'bangumi':
          // print('番剧');
          final String seasonId = path.split('/').last;
          _bangumiPush(matchNum(seasonId).first);
          break;
        case 'video':
          // print('投稿');
          final Map<String, dynamic> map = IdUtils.matchAvorBv(input: path);
          if (map.containsKey('AV')) {
            _videoPush(map['AV']! as int, null);
          } else if (map.containsKey('BV')) {
            _videoPush(null, map['BV'] as String);
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
    final RegExp regExp = RegExp(r'\d+');
    final Iterable<Match> matches = regExp.allMatches(str);

    return matches.map((Match match) => int.parse(match.group(0)!)).toList();
  }
}
