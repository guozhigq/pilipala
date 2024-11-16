import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/html.dart';
import 'package:pilipala/http/reply.dart';
import 'package:pilipala/models/common/reply_sort_type.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';

class DynamicDetailController extends GetxController {
  DynamicDetailController(this.oid, this.type);
  int? oid;
  int? type;
  dynamic item;
  int? floor;
  String nextOffset = "";
  bool isLoadingMore = false;
  RxString noMore = ''.obs;
  RxList<ReplyItemModel> replyList = <ReplyItemModel>[].obs;
  RxInt acount = 0.obs;
  final ScrollController scrollController = ScrollController();

  ReplySortType _sortType = ReplySortType.time;
  RxString sortTypeTitle = ReplySortType.time.titles.obs;
  RxString sortTypeLabel = ReplySortType.time.labels.obs;
  Box setting = GStorage.setting;
  RxInt replyReqCode = 200.obs;
  bool isEnd = false;

  @override
  void onInit() {
    super.onInit();
    item = Get.arguments['item'];
    floor = Get.arguments['floor'];
    if (floor == 1) {
      acount.value =
          int.parse(item!.modules!.moduleStat!.comment!.count ?? '0');
    }
    int defaultReplySortIndex =
        setting.get(SettingBoxKey.replySortType, defaultValue: 0);
    if (defaultReplySortIndex == 2) {
      setting.put(SettingBoxKey.replySortType, 0);
      defaultReplySortIndex = 0;
    }
    _sortType = ReplySortType.values[defaultReplySortIndex];
    sortTypeTitle.value = _sortType.titles;
    sortTypeLabel.value = _sortType.labels;
  }

  Future queryReplyList({reqType = 'init'}) async {
    if (isLoadingMore || noMore.value == '没有更多了' || isEnd) {
      return;
    }
    isLoadingMore = true;
    if (reqType == 'init') {
      nextOffset = '';
      noMore.value = '';
    }
    var res = await ReplyHttp.replyList(
      oid: oid!,
      nextOffset: nextOffset,
      type: type!,
      sort: _sortType.index,
    );
    if (res['status']) {
      List<ReplyItemModel> replies = res['data'].replies;
      isEnd = res['data'].cursor.isEnd ?? false;
      acount.value = res['data'].cursor.allCount;
      nextOffset = res['data'].cursor.paginationReply.nextOffset ?? "";
      if (replies.isNotEmpty) {
        noMore.value = isEnd ? '没有更多了' : '加载中...';
      } else {
        noMore.value =
            replyList.isEmpty && nextOffset == "" ? '还没有评论' : '没有更多了';
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
    replyReqCode.value = res['code'];
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
    replyList.clear();
    queryReplyList(reqType: 'init');
  }

  // 根据jumpUrl获取动态html
  reqHtmlByOpusId(int id) async {
    var res = await HtmlHttp.reqHtml(id, 'opus');
    oid = res['commentId'];
  }

  // 上拉加载
  Future onLoad() async {
    queryReplyList(reqType: 'onLoad');
  }

  Future removeReply(int? rpid, int? frpid) async {
    // 移除一楼评论
    if (rpid != null) {
      replyList.removeWhere((item) {
        return item.rpid == rpid;
      });
    }

    /// TODO 移除二楼评论
  }
}
