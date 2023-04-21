import 'package:get/get.dart';
import 'package:pilipala/http/api.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/models/video_detail_res.dart';

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

  Future queryVideoDetail() async {
    var res = await Request().get(Api.videoDetail, data: {
      'aid': aid,
    });
    VideoDetailResponse result = VideoDetailResponse.fromJson(res.data);
    videoDetail.value = result.data!;
    // await Future.delayed(const Duration(seconds: 3));
    return true;
  }
}
