import 'package:get/get.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/video_detail_res.dart';
import 'package:pilipala/pages/video/detail/controller.dart';

class VideoIntroController extends GetxController {
  // 视频aid
  String aid = Get.parameters['aid']!;

  // 是否预渲染 骨架屏
  bool preRender = false;

  // 视频详情 上个页面传入
  Map? videoItem = {};

  // 请求状态
  RxBool isLoading = false.obs;

  // 视频详情 请求返回
  Rx<VideoDetailData> videoDetail = VideoDetailData().obs;

  // 请求返回的信息
  String responseMsg = '请求异常';

  // up主粉丝数
  Map userStat = {'follower': '-'};

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments.isNotEmpty) {
      if (Get.arguments.containsKey('videoItem')) {
        preRender = true;
        var args = Get.arguments['videoItem'];
        videoItem!['pic'] = args.pic;
        videoItem!['title'] = args.title;
        videoItem!['stat'] = args.stat;
        videoItem!['pubdate'] = args.pubdate;
        videoItem!['owner'] = args.owner;
      }
    }
  }

  // 获取视频简介
  Future queryVideoIntro() async {
    var result = await VideoHttp.videoIntro(aid: aid);
    if (result['status']) {
      videoDetail.value = result['data']!;
      Get.find<VideoDetailController>(tag: Get.arguments['heroTag'])
          .tabs
          .value = ['简介', '评论 ${result['data']!.stat!.reply}'];
    } else {
      responseMsg = result['msg'];
    }
    // 获取到粉丝数再返回
    await queryUserStat();
    return result;
  }

  // 获取up主粉丝数
  Future queryUserStat() async {
    var result = await UserHttp.userStat(mid: videoDetail.value.owner!.mid!);
    if (result['status']) {
      userStat = result['data'];
    }
  }
}
