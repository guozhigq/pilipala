import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/reply.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/models/video/reply/data.dart';
import 'package:pilipala/models/video/reply/item.dart';

class VideoReplyReplyController extends GetxController {
  VideoReplyReplyController(this.aid, this.rpid, this.replyType);
  final ScrollController scrollController = ScrollController();
  // 视频aid 请求时使用的oid
  int? aid;
  // rpid 请求楼中楼回复
  String? rpid;
  ReplyType replyType = ReplyType.video;
  RxList<ReplyItemModel> replyList = [ReplyItemModel()].obs;
  // 当前页
  int currentPage = 0;
  bool isLoadingMore = false;
  RxBool noMore = false.obs;
  // 当前回复的回复
  ReplyItemModel? currentReplyItem;

  // 根评论 id 回复楼中楼回复使用
  int? rPid;
  // 默认回复主楼
  String replyLevel = '0';

  @override
  void onInit() {
    super.onInit();
    currentPage = 0;
  }

  // 上拉加载
  Future onLoad() async {
    queryReplyList(type: 'onLoad');
  }

  Future queryReplyList({type = 'init'}) async {
    if (type == 'init') {
      currentPage = 0;
    }
    isLoadingMore = true;
    var res = await ReplyHttp.replyReplyList(
        oid: aid!,
        root: rpid!,
        pageNum: currentPage + 1,
        type: replyType.index);
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
        // if (res['data'].upper.top != null) {
        //   bool flag = false;
        //   for (var i = 0; i < res['data'].topReplies.length; i++) {
        //     if (res['data'].topReplies[i].rpid == res['data'].upper.top.rpid) {
        //       flag = true;
        //     }
        //   }
        //   if (!flag) {
        //     replies.insert(0, res['data'].upper.top);
        //   }
        // }
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

  @override
  void onClose() {
    currentPage = 0;
    super.onClose();
  }
}
