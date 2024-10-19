import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/pages/video/detail/reply_reply/index.dart';
import 'package:pilipala/utils/app_scheme.dart';
import 'package:pilipala/utils/utils.dart';

class MessageUtils {
  // 回复我的、收到的赞点击
  static void onClickMessage(
      BuildContext context, Uri uri, Uri nativeUri, String type) async {
    final String path = uri.path;
    final String bvid = path.split('/').last;
    final String nativePath = nativeUri.path;
    final String oid = nativePath.split('/').last;
    final Map<String, String> queryParameters = nativeUri.queryParameters;
    final String? argCid = queryParameters['cid'];
    // final String? page = queryParameters['page'];
    final String? commentRootId = queryParameters['comment_root_id'];
    // final String? commentSecondaryId = queryParameters['comment_secondary_id'];
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
        debugPrint('commentRootId: $oid, $commentRootId');
        navigateToComment(
            context, oid, commentRootId!, ReplyType.video, nativeUri);
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
}
