import 'package:get/get.dart';
import 'package:pilipala/pages/fav/index.dart';
import 'package:pilipala/pages/favDetail/index.dart';
import 'package:pilipala/pages/history/index.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/hot/index.dart';
import 'package:pilipala/pages/later/index.dart';
import 'package:pilipala/pages/preview/index.dart';
import 'package:pilipala/pages/search/index.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/pages/webview/index.dart';
import 'package:pilipala/pages/setting/index.dart';
import 'package:pilipala/pages/media/index.dart';

import '../pages/searchResult/index.dart';

class Routes {
  static final List<GetPage> getPages = [
    // 首页(推荐)
    GetPage(name: '/', page: () => const HomePage()),
    // 热门
    GetPage(name: '/hot', page: () => const HotPage()),
    // 视频详情
    GetPage(name: '/video', page: () => const VideoDetailPage()),
    // 图片预览
    GetPage(
      name: '/preview',
      page: () => const ImagePreview(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
      showCupertinoParallax: false,
    ),
    //
    GetPage(name: '/webview', page: () => const WebviewPage()),
    // 设置
    GetPage(name: '/setting', page: () => const SettingPage()),
    //
    GetPage(name: '/media', page: () => const MediaPage()),
    //
    GetPage(name: '/fav', page: () => const FavPage()),
    //
    GetPage(name: '/favDetail', page: () => const FavDetailPage()),
    // 稍后再看
    GetPage(name: '/later', page: () => const LaterPage()),
    // 历史记录
    GetPage(name: '/history', page: () => const HistoryPage()),
    // 搜索页面
    GetPage(name: '/search', page: () => const SearchPage()),
    // 搜索结果
    GetPage(name: '/searchResult', page: () => const SearchResultPage())
  ];
}
