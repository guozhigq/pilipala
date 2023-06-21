import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/reply.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/models/video/reply/data.dart';
import 'package:pilipala/models/video/reply/item.dart';

class VideoReplyController extends GetxController {
  VideoReplyController(this.aid, this.rpid, this.level);
  final ScrollController scrollController = ScrollController();
  // 视频aid 请求时使用的oid
  String? aid;
  // 层级 2为楼中楼
  String? level;
  // rpid 请求楼中楼回复
  String? rpid;
  RxList<ReplyItemModel> replyList = [ReplyItemModel()].obs;
  // 当前页
  int currentPage = 0;
  bool isLoadingMore = false;
  RxString noMore = ''.obs;
  RxBool autoFocus = false.obs;
  // 当前回复的回复
  ReplyItemModel? currentReplyItem;
  // 回复来源
  String replySource = 'main';
  // 根评论 id 回复楼中楼回复使用
  int? rPid;
  // 默认回复主楼
  String replyLevel = '0';

  Future queryReplyList({type = 'init'}) async {
    isLoadingMore = true;
    var res = level == '1'
        ? await ReplyHttp.replyList(
            oid: aid!, pageNum: currentPage + 1, type: 1)
        : await ReplyHttp.replyReplyList(
            oid: aid!, root: rpid!, pageNum: currentPage + 1, type: 1);
    if (res['status']) {
      res['data'] = ReplyData.fromJson(res['data']);
      if (res['data'].replies.isNotEmpty) {
        currentPage = currentPage + 1;
        noMore.value = '加载中';
        if (replyList.length == res['data'].page.acount) {
          noMore.value = '没有更多了';
        }
      } else {
        if (currentPage == 0) {
          noMore.value = '还没有评论';
        } else {
          noMore.value = '没有更多了';
          return;
        }
      }
      if (type == 'init') {
        List<ReplyItemModel> replies = res['data'].replies;
        // 添加置顶回复
        if (res['data'].upper.top != null) {
          bool flag = false;
          for (var i = 0; i < res['data'].topReplies.length; i++) {
            if (res['data'].topReplies[i].rpid == res['data'].upper.top.rpid) {
              flag = true;
            }
          }
          if (!flag) {
            replies.insert(0, res['data'].upper.top);
          }
        }
        replies.insertAll(0, res['data'].topReplies);
        res['data'].replies = replies;
        replyList.value = res['data'].replies!;
      } else {
        replyList.addAll(res['data'].replies!);
        res['data'].replies.addAll(replyList);
      }
    }
    isLoadingMore = false;
    return res;
  }

  // 上拉加载
  Future onLoad() async {
    queryReplyList(type: 'onLoad');
  }

  wakeUpReply() {
    autoFocus.value = true;
  }

  // 发表评论
  Future submitReplyAdd() async {
    var result = await VideoHttp.replyAdd(
      type: ReplyType.video,
      oid: int.parse(aid!),
      root: replyLevel == '0'
          ? 0
          : replyLevel == '1'
              ? currentReplyItem!.rpid
              : rPid,
      parent: replyLevel == '0'
          ? 0
          : replyLevel == '1'
              ? currentReplyItem!.rpid
              : currentReplyItem!.rpid,
      message: replyLevel == '2'
          ? ' 回复 @${currentReplyItem!.member!.uname!} : 2楼31'
          : '2楼31',
    );
    if (result['status']) {
      SmartDialog.showToast(result['data']['success_toast']);
    } else {
      SmartDialog.showToast(result['message']);
    }
  }
}
