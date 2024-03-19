import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/html.dart';
import 'package:pilipala/http/reply.dart';
import 'package:pilipala/models/common/reply_sort_type.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';

class HtmlRenderController extends GetxController {
  late String id;
  late String dynamicType;
  late int type;
  RxInt oid = (-1).obs;
  late Map response;
  int? floor;
  int currentPage = 0;
  bool isLoadingMore = false;
  RxString noMore = ''.obs;
  RxList<ReplyItemModel> replyList = <ReplyItemModel>[].obs;
  RxInt acount = 0.obs;
  final ScrollController scrollController = ScrollController();

  ReplySortType _sortType = ReplySortType.time;
  RxString sortTypeTitle = ReplySortType.time.titles.obs;
  RxString sortTypeLabel = ReplySortType.time.labels.obs;
  Box setting = GStrorage.setting;

  @override
  void onInit() {
    super.onInit();
    id = Get.parameters['id']!;
    dynamicType = Get.parameters['dynamicType']!;
    type = dynamicType == 'picture' ? 11 : 12;
  }

  // 请求动态内容
  Future reqHtml(id) async {
    late dynamic res;
    if (dynamicType == 'opus' || dynamicType == 'picture') {
      res = await HtmlHttp.reqHtml(id, dynamicType);
    } else {
      res = await HtmlHttp.reqReadHtml(id, dynamicType);
    }
    response = res;
    oid.value = res['commentId'];
    return res;
  }

  // 请求评论
  Future queryReplyList({reqType = 'init'}) async {
    var res = await ReplyHttp.replyList(
      oid: oid.value,
      pageNum: currentPage + 1,
      type: type,
      sort: _sortType.index,
    );
    if (res['status']) {
      List<ReplyItemModel> replies = res['data'].replies;
      acount.value = res['data'].page.acount;
      if (replies.isNotEmpty) {
        currentPage++;
        noMore.value = '加载中...';
        if (replies.length < 20) {
          noMore.value = '没有更多了';
        }
      } else {
        noMore.value = currentPage == 0 ? '还没有评论' : '没有更多了';
      }
      if (reqType == 'init') {
        // 添加置顶回复
        if (res['data'].upper.top != null) {
          bool flag = res['data']
              .topReplies
              .any((reply) => reply.rpid == res['data'].upper.top.rpid);
          if (!flag) {
            replies.insert(0, res['data'].upper.top);
          }
        }
        replies.insertAll(0, res['data'].topReplies);
        replyList.value = replies;
      } else {
        replyList.addAll(replies);
      }
    }
    isLoadingMore = false;
    return res;
  }

  // 排序搜索评论
  queryBySort() {
    feedBack();
    switch (_sortType) {
      case ReplySortType.time:
        _sortType = ReplySortType.like;
        break;
      case ReplySortType.like:
        _sortType = ReplySortType.time;
        break;
      default:
    }
    sortTypeTitle.value = _sortType.titles;
    sortTypeLabel.value = _sortType.labels;
    currentPage = 0;
    replyList.clear();
    queryReplyList(reqType: 'init');
  }
}
