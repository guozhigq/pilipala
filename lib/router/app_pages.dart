import 'package:get/get.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/hot/index.dart';
import 'package:pilipala/pages/video/detail/index.dart';

class Routes {
  static final List<GetPage> getPages = [
    // 首页(推荐)
    GetPage(name: '/', page: () => const HomePage()),
    // 热门
    GetPage(name: '/hot', page: () => const HotPage()),
    // 视频详情
    GetPage(name: '/video', page: () => const VideoDetailPage()),
  ];
}
