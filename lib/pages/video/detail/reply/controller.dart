import 'package:easy_debounce/easy_throttle.dart';
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
  // 视频aid 请求时使用的oid
  int? aid;
  // 层级 2为楼中楼
  String? replyLevel;
  // rpid 请求楼中楼回复
  String? rpid;
  RxList<ReplyItemModel> replyList = <ReplyItemModel>[].obs;
  String nextOffset = "";
  bool isLoadingMore = false;
  RxString noMore = ''.obs;
  RxInt count = 0.obs;
  // 当前回复的回复
  ReplyItemModel? currentReplyItem;

  ReplySortType _sortType = ReplySortType.time;
  RxString sortTypeTitle = ReplySortType.time.titles.obs;
  RxString sortTypeLabel = ReplySortType.time.labels.obs;

  Box setting = GStorage.setting;
  RxInt replyReqCode = 200.obs;
  bool isEnd = false;

  @override
  void onInit() {
    super.onInit();
    int defaultReplySortIndex =
        setting.get(SettingBoxKey.replySortType, defaultValue: 0) as int;
    if (defaultReplySortIndex == 2) {
      setting.put(SettingBoxKey.replySortType, 0);
      defaultReplySortIndex = 0;
    }
    _sortType = ReplySortType.values[defaultReplySortIndex];
    sortTypeTitle.value = _sortType.titles;
    sortTypeLabel.value = _sortType.labels;
  }

  Future<dynamic> queryReplyList({type = 'init'}) async {
    if (isLoadingMore || noMore.value == '没有更多了' || isEnd) {
      return;
    }
    isLoadingMore = true;
    if (type == 'init') {
      nextOffset = '';
      noMore.value = '';
    }
    final res = await ReplyHttp.replyList(
      oid: aid!,
      nextOffset: nextOffset,
      type: ReplyType.video.index,
      sort: _sortType.index,
    );
    if (res['status']) {
      final List<ReplyItemModel> replies = res['data'].replies;
      isEnd = res['data'].cursor.isEnd ?? false;
      nextOffset = res['data'].cursor.paginationReply.nextOffset ?? "";
      if (replies.isNotEmpty) {
        noMore.value = isEnd ? '没有更多了' : '加载中...';
      } else {
        noMore.value =
            replyList.isEmpty && nextOffset == "" ? '还没有评论' : '没有更多了';
      }
      if (type == 'init') {
        // 添加置顶回复
        if (res['data'].upper.top != null) {
          final bool flag = res['data'].topReplies.any((ReplyItemModel reply) =>
              reply.rpid == res['data'].upper.top.rpid) as bool;
          if (!flag) {
            replies.insert(0, res['data'].upper.top);
          }
        }
        replies.insertAll(0, res['data'].topReplies);
        count.value = res['data'].cursor.allCount;
        replyList.value = replies;
      } else {
        replyList.addAll(replies);
      }
    }
    replyReqCode.value = res['code'];
    isLoadingMore = false;
    return res;
  }

  // 上拉加载
  Future onLoad() async {
    queryReplyList(type: 'onLoad');
  }

  // 下拉刷新
  Future onRefresh() async {
    nextOffset = "";
    noMore.value = '';
    isEnd = false;
    queryReplyList(type: 'init');
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
          _sortType = ReplySortType.time;
          break;
        default:
      }
      isLoadingMore = false;
      isEnd = false;
      sortTypeTitle.value = _sortType.titles;
      sortTypeLabel.value = _sortType.labels;
      nextOffset = "";
      noMore.value = '';
      replyList.clear();
      queryReplyList(type: 'init');
    });
  }

  // 移除评论
  Future removeReply(int? rpid, int? frpid) async {
    // 移除一楼评论
    if (rpid != null) {
      replyList.removeWhere((item) {
        return item.rpid == rpid;
      });
    }
    // 移除二楼评论
    if (frpid != 0 && frpid != null) {
      replyList.value = replyList.map((item) {
        if (item.rpid! == frpid) {
          item.replies!.removeWhere((reply) => reply.rpid == rpid);
          // 【共xx条回复】
          if (item.replyControl != null &&
              item.replyControl!.entryTextNum! >= 1) {
            item.replyControl!.entryTextNum =
                item.replyControl!.entryTextNum! - 1;
            item.rcount = item.replyControl!.entryTextNum;
          }
          return item;
        } else {
          return item;
        }
      }).toList();
    }
  }
}
