import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/models/msg/reply.dart';
import 'package:pilipala/pages/video/detail/reply_reply/index.dart';
import 'package:pilipala/utils/app_scheme.dart';
import 'package:pilipala/utils/utils.dart';

class MessageUtils {
  // 回复我的、收到的赞点击
  static void onClickMessage(
    BuildContext context,
    Uri uri,
    Uri nativeUri,
    String type,
    ReplyContentItem? item,
  ) async {
    final String path = uri.path;
    final String bvid = path.split('/').last;
    String? sourceType;
    final String nativePath = nativeUri.path;
    String oid = nativePath.split('/').last;
    final Map<String, String> queryParameters = nativeUri.queryParameters;
    final String? argCid = queryParameters['cid'];
    // final String? page = queryParameters['page'];
    String? commentRootId = queryParameters['comment_root_id'];
    // final String? commentSecondaryId = queryParameters['comment_secondary_id'];
    if (nativePath.contains('detail')) {
      // 动态详情
      sourceType = 'opus';
      oid = item?.subjectId!.toString() ?? nativePath.split('/')[3];
      commentRootId = item?.sourceId!.toString() ?? nativePath.split('/')[4];
    }
    switch (type) {
      case 'video':
      case 'danmu':
        try {
          final int cid = argCid != null
              ? int.parse(argCid)
              : await SearchHttp.ab2c(bvid: bvid);
          final String heroTag = Utils.makeHeroTag(bvid);
          Get.toNamed<dynamic>(
            '/video?bvid=$bvid&cid=$cid',
            arguments: <String, String?>{
              'pic': '',
              'heroTag': heroTag,
            },
          );
        } catch (e) {
          SmartDialog.showToast('视频可能失效了$e');
        }
        break;
      case 'reply':
      case 'dynamic':
        debugPrint('commentRootId: $oid, $commentRootId');
        navigateToComment(
          context,
          oid,
          commentRootId!,
          sourceType == 'opus' ? ReplyType.dynamics : ReplyType.video,
          nativeUri,
        );
        break;
      default:
        break;
    }
  }

  // 跳转查看评论
  static void navigateToComment(
    BuildContext context,
    String oid,
    String rpid,
    ReplyType replyType,
    Uri nativeUri,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('评论详情'),
            actions: [
              IconButton(
                tooltip: '查看原内容',
                onPressed: () {
                  PiliSchame.routePush(nativeUri);
                },
                icon: const Icon(Icons.open_in_new_outlined),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: VideoReplyReplyPanel(
            oid: int.tryParse(oid),
            rpid: int.tryParse(rpid),
            source: 'routePush',
            replyType: replyType,
            firstFloor: null,
            showRoot: true,
          ),
        ),
      ),
    );
  }

  // 匹配链接
  Map<String, String> extractLinks(String text) {
    Map<String, String> result = {};
    String message = '';
    // 是否匹配到bv
    RegExp bvRegex = RegExp(r'bv1[\d\w]{9}', caseSensitive: false);
    final Iterable<RegExpMatch> bvMatches = bvRegex.allMatches(text);
    for (var match in bvMatches) {
      result[match.group(0)!] =
          'https://www.bilibili.com/video/${match.group(0)!}';
    }

    // 定义正则表达式
    RegExp regex = RegExp(
        r'(?:(?:(?:http:\/\/|https:\/\/)(?:[a-zA-Z0-9_.-]+\.)*(?:bilibili|biligame)\.com(?:\/[/.$*?~=#!%@&\-\w]*)?)|(?:(?:http:\/\/|https:\/\/)(?:[a-zA-Z0-9_.-]+\.)*(?:acg|b23)\.tv(?:\/[/.$*?~=#!%@&\-\w]*)?)|(?:(?:http:\/\/|https:\/\/)dl\.(?:hdslb)\.com(?:\/[/.$*?~=#!%@&\-\w]*)?))');
    // 链接文字
    RegExp linkTextRegex = RegExp(r"#\{(.*?)\}");
    final Iterable<RegExpMatch> matches = regex.allMatches(text);
    int lastMatchEnd = 0;
    if (matches.isNotEmpty) {
      for (var match in matches) {
        final int start = match.start;
        final int end = match.end;
        String str = text.substring(lastMatchEnd, start);
        final Iterable<RegExpMatch> linkTextMatches =
            linkTextRegex.allMatches(str);

        if (linkTextMatches.isNotEmpty) {
          for (var linkTextMatch in linkTextMatches) {
            if (linkTextMatch.group(1) != null) {
              String linkText = linkTextMatch.group(1)!;
              str = str
                  .replaceAll(linkTextMatch.group(0)!, linkText)
                  .replaceAll('{', '')
                  .replaceAll('}', '');
              result[linkText] = match.group(0)!;
            }
            print('str: $str');
            message += str;
          }
        } else {
          message += '$str查看详情';
          result['查看详情'] = match.group(0)!;
        }
        lastMatchEnd = end;
      }
      // 处理剩余的未匹配部分
      if (lastMatchEnd < text.length) {
        message += text.substring(lastMatchEnd + 1);
      }
      result['message'] = message;
    } else {
      result['message'] = text;
    }
    return result;
  }
}
