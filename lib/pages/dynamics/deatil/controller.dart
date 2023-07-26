import 'package:get/get.dart';
import 'package:pilipala/http/reply.dart';
import 'package:pilipala/models/common/reply_sort_type.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/utils/feed_back.dart';

class DynamicDetailController extends GetxController {
  DynamicDetailController(this.oid, this.type);
  int? oid;
  int? type;
  dynamic item;
  int? floor;
  int currentPage = 0;
  bool isLoadingMore = false;
  RxString noMore = ''.obs;
  RxList<ReplyItemModel> replyList = [ReplyItemModel()].obs;
  RxInt acount = 0.obs;

  ReplySortType sortType = ReplySortType.time;
  RxString sortTypeTitle = ReplySortType.time.titles.obs;
  RxString sortTypeLabel = ReplySortType.time.labels.obs;

  @override
  void onInit() {
    super.onInit();
    item = Get.arguments['item'];
    floor = Get.arguments['floor'];
    if (floor == 1) {
      acount.value =
          int.parse(item!.modules!.moduleStat!.comment!.count ?? '0');
    }
  }

  Future queryReplyList({reqType = 'init'}) async {
    if (reqType == 'init') {
      currentPage = 0;
    }
    var res = await ReplyHttp.replyList(
      oid: oid!,
      pageNum: currentPage + 1,
      type: type!,
      sort: sortType.index,
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
    replyList.clear();
    queryReplyList(reqType: 'init');
  }
}
