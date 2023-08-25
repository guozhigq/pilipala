import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/reply.dart';
import 'package:pilipala/models/common/reply_sort_type.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';

class VideoReplyController extends GetxController {
  VideoReplyController(
    this.aid,
    this.rpid,
    this.replyLevel,
  );
  final ScrollController scrollController = ScrollController();
  // 视频aid 请求时使用的oid
  int? aid;
  // 层级 2为楼中楼
  String? replyLevel;
  // rpid 请求楼中楼回复
  String? rpid;
  RxList<ReplyItemModel> replyList = [ReplyItemModel()].obs;
  // 当前页
  int currentPage = 0;
  bool isLoadingMore = false;
  RxString noMore = ''.obs;
  int ps = 20;
  RxInt count = 0.obs;
  // 当前回复的回复
  ReplyItemModel? currentReplyItem;

  ReplySortType _sortType = ReplySortType.time;
  RxString sortTypeTitle = ReplySortType.time.titles.obs;
  RxString sortTypeLabel = ReplySortType.time.labels.obs;

  Box setting = GStrorage.setting;

  @override
  void onInit() {
    super.onInit();
    int deaultReplySortIndex =
        setting.get(SettingBoxKey.replySortType, defaultValue: 0);
    _sortType = ReplySortType.values[deaultReplySortIndex];
    sortTypeTitle.value = _sortType.titles;
    sortTypeLabel.value = _sortType.labels;
  }

  Future queryReplyList({type = 'init'}) async {
    isLoadingMore = true;
    if (type == 'init') {
      currentPage = 0;
    }
    if (noMore.value == '没有更多了') {
      return;
    }
    var res = await ReplyHttp.replyList(
      oid: aid!,
      pageNum: currentPage + 1,
      ps: ps,
      type: ReplyType.video.index,
      sort: _sortType.index,
    );
    if (res['status']) {
      List<ReplyItemModel> replies = res['data'].replies;
      if (replies.isNotEmpty) {
        noMore.value = '加载中...';

        /// 第一页回复数小于20
        if (currentPage == 0 && replies.length < 20) {
          noMore.value = '没有更多了';
        }
        currentPage++;

        if (replyList.length == res['data'].page.acount) {
          noMore.value = '没有更多了';
        }
      } else {
        // 未登录状态replies可能返回null
        noMore.value = currentPage == 0 ? '还没有评论' : '没有更多了';
      }
      if (type == 'init') {
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
    count.value = res['data'].page.count;
    isLoadingMore = false;
    return res;
  }

  // 上拉加载
  Future onLoad() async {
    queryReplyList(type: 'onLoad');
  }

  // 排序搜索评论
  queryBySort() {
    EasyThrottle.throttle('queryBySort', const Duration(seconds: 1), () {
      feedBack();
      switch (_sortType) {
        case ReplySortType.time:
          _sortType = ReplySortType.like;
          break;
        case ReplySortType.like:
          _sortType = ReplySortType.reply;
          break;
        case ReplySortType.reply:
          _sortType = ReplySortType.time;
          break;
        default:
      }
      sortTypeTitle.value = _sortType.titles;
      sortTypeLabel.value = _sortType.labels;
      currentPage = 0;
      noMore.value = '';
      replyList.clear();
      queryReplyList(type: 'init');
    });
  }
}
