import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/reply.dart';
import 'package:pilipala/models/video/reply/data.dart';
import 'package:pilipala/models/video/reply/item.dart';

class VideoReplyController extends GetxController {
  VideoReplyController(
    this.aid,
    this.rpid,
    this.level,
  );
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
  RxBool noMore = false.obs;

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
        noMore.value = false;
      } else {
        if (currentPage == 0) {
        } else {
          noMore.value = true;
          return;
        }
      }
      if (res['data'].replies.length >= res['data'].page.count) {
        noMore.value = true;
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
}
