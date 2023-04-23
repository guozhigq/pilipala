import 'package:get/get.dart';
import 'package:pilipala/http/reply.dart';
import 'package:pilipala/models/video/reply/data.dart';

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
    if (res['status']) {
      res['data'] = ReplyData.fromJson(res['data']);
      print(res['data'].replies);
    }
    return res;
  }
}
