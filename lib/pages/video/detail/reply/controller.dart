import 'package:get/get.dart';
import 'package:pilipala/http/reply.dart';

class VideoReplyController extends GetxController {
  // 视频aid
  String aid = Get.parameters['aid']!;

  @override
  void onInit() {
    super.onInit();
    queryReplyList();
  }

  Future queryReplyList() async {
    var res = await ReplyHttp.replyList(oid: aid, pageNum: 1, type: 1);
  }
}
