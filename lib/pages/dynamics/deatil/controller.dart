import 'package:get/get.dart';
import 'package:pilipala/http/reply.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/models/video/reply/data.dart';
import 'package:pilipala/models/video/reply/item.dart';

class DynamicDetailController extends GetxController {
  DynamicDetailController(this.oid, this.type);
  int? oid;
  int? type;
  var item;
  int? floor;
  int currentPage = 0;
  bool isLoadingMore = false;
  RxString noMore = ''.obs;
  RxList<ReplyItemModel> replyList = [ReplyItemModel()].obs;
  RxInt acount = 0.obs;

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
    );
    if (res['status']) {
      res['data'] = ReplyData.fromJson(res['data']);
      acount.value = res['data'].page.acount;
      if (res['data'].replies.isNotEmpty) {
        currentPage = currentPage + 1;
        noMore.value = '加载中...';
        if (replyList.isEmpty) {
          noMore.value = '没有更多了';
          return;
        }
      } else {
        if (currentPage == 0) {
          noMore.value = '还没有评论';
        } else {
          noMore.value = '没有更多了';
          return;
        }
      }
      List<ReplyItemModel> replies = res['data'].replies;
      if (reqType == 'init') {
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
        replyList.value = replies;
      } else {
        replyList.addAll(replies);
      }
    }
    isLoadingMore = false;
    return res;
  }
}
