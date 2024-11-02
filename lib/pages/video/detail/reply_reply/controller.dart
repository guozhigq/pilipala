import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/reply.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/models/video/reply/item.dart';

class VideoReplyReplyController extends GetxController {
  VideoReplyReplyController(this.aid, this.rpid, this.replyType, this.showRoot);
  final ScrollController scrollController = ScrollController();
  // 视频aid 请求时使用的oid
  int? aid;
  // rpid 请求楼中楼回复
  String? rpid;
  ReplyType? replyType;
  bool showRoot = false;
  ReplyItemModel? rootReply;
  RxList<ReplyItemModel> replyList = <ReplyItemModel>[].obs;
  // 当前页
  int currentPage = 1;
  bool isLoadingMore = false;
  RxString noMore = ''.obs;
  // 当前回复的回复
  ReplyItemModel? currentReplyItem;

  @override
  void onInit() {
    super.onInit();
    currentPage = 1;
  }

  Future queryReplyList({type = 'init', currentReply}) async {
    if (type == 'init') {
      currentPage = 1;
    }
    if (isLoadingMore) {
      return;
    }
    isLoadingMore = true;
    final res = await ReplyHttp.replyReplyList(
      oid: aid!,
      root: rpid!,
      pageNum: currentPage,
      type: (replyType ?? ReplyType.video).index,
    );
    if (res['status']) {
      final List<ReplyItemModel> replies = res['data'].replies;
      ReplyItemModel? root = res['data'].root;
      if (replies.isNotEmpty) {
        noMore.value = '加载中...';
        if (replies.length == res['data'].page.count) {
          noMore.value = '没有更多了';
        }
        // currentPage++;
      } else {
        // 未登录状态replies可能返回null
        noMore.value = currentPage == 1 ? '还没有评论' : '没有更多了';
      }
      if (type == 'init' && currentPage == 1) {
        replyList.value = replies;
      } else {
        // 每次回复之后，翻页请求有且只有相同的一条回复数据
        if (replies.length == 1 && replies.last.rpid == replyList.last.rpid) {
          return;
        }
        replyList.addAll(replies);
      }
      if (showRoot && root != null) {
        rootReply = root;
      }
    }
    if (replyList.isNotEmpty && currentReply != null) {
      int indexToRemove =
          replyList.indexWhere((item) => currentReply.rpid == item.rpid);
      // 如果找到了指定ID的项，则移除
      if (indexToRemove != -1) {
        replyList.removeAt(indexToRemove);
      }
      if (currentPage == 1 && type == 'init') {
        replyList.insert(0, currentReply);
      }
    }
    currentPage += 1;
    isLoadingMore = false;
    return res;
  }

  @override
  void onClose() {
    currentPage = 0;
    super.onClose();
  }
}
