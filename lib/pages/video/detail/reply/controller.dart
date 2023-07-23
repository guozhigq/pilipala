import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/reply.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/common/reply_sort_type.dart';
import 'package:pilipala/models/common/reply_type.dart';
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
  int? aid;
  // 层级 2为楼中楼
  String? level;
  // rpid 请求楼中楼回复
  String? rpid;
  RxList<ReplyItemModel> replyList = [ReplyItemModel()].obs;
  // 当前页
  int currentPage = 0;
  bool isLoadingMore = false;
  RxString noMore = ''.obs;
  // 当前回复的回复
  ReplyItemModel? currentReplyItem;
  // 回复来源
  String replySource = 'main';
  // 根评论 id 回复楼中楼回复使用
  int? rPid;
  // 默认回复主楼
  String replyLevel = '0';

  ReplySortType sortType = ReplySortType.time;
  RxString sortTypeTitle = ReplySortType.time.titles.obs;
  RxString sortTypeLabel = ReplySortType.time.labels.obs;

  Future queryReplyList({type = 'init'}) async {
    isLoadingMore = true;
    var res = level == '1'
        ? await ReplyHttp.replyList(
            oid: aid!,
            pageNum: currentPage + 1,
            type: ReplyType.video.index,
            sort: sortType.index,
          )
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

  // 排序搜索评论
  queryBySort() {
    switch (sortType) {
      case ReplySortType.time:
        sortType = ReplySortType.like;
        break;
      case ReplySortType.like:
        sortType = ReplySortType.reply;
        break;
      case ReplySortType.reply:
        sortType = ReplySortType.time;
        break;
      default:
    }
    sortTypeTitle.value = sortType.titles;
    sortTypeLabel.value = sortType.labels;
    currentPage = 0;
    replyList.clear();
    queryReplyList(type: 'init');
  }
}
