import 'package:get/get.dart';
import 'package:pilipala/pages/about/index.dart';
import 'package:pilipala/pages/blacklist/index.dart';
import 'package:pilipala/pages/dynamics/deatil/index.dart';
import 'package:pilipala/pages/dynamics/index.dart';
import 'package:pilipala/pages/fan/index.dart';
import 'package:pilipala/pages/fav/index.dart';
import 'package:pilipala/pages/favDetail/index.dart';
import 'package:pilipala/pages/follow/index.dart';
import 'package:pilipala/pages/history/index.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/hot/index.dart';
import 'package:pilipala/pages/later/index.dart';
import 'package:pilipala/pages/liveRoom/view.dart';
import 'package:pilipala/pages/member/index.dart';
import 'package:pilipala/pages/preview/index.dart';
import 'package:pilipala/pages/search/index.dart';
import 'package:pilipala/pages/searchResult/index.dart';
import 'package:pilipala/pages/setting/extra_setting.dart';
import 'package:pilipala/pages/setting/pages/color_select.dart';
import 'package:pilipala/pages/setting/pages/font_size_select.dart';
import 'package:pilipala/pages/setting/play_setting.dart';
import 'package:pilipala/pages/setting/privacy_setting.dart';
import 'package:pilipala/pages/setting/style_setting.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/pages/video/detail/replyReply/index.dart';
import 'package:pilipala/pages/webview/index.dart';
import 'package:pilipala/pages/setting/index.dart';
import 'package:pilipala/pages/media/index.dart';

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
    GetPage(name: '/searchResult', page: () => const SearchResultPage()),
    // 动态
    GetPage(name: '/dynamics', page: () => const DynamicsPage()),
    // 动态详情
    GetPage(name: '/dynamicDetail', page: () => const DynamicDetailPage()),
    // 关注
    GetPage(name: '/follow', page: () => const FollowPage()),
    // 粉丝
    GetPage(name: '/fan', page: () => const FansPage()),
    // 直播详情
    GetPage(name: '/liveRoom', page: () => const LiveRoomPage()),
    // 用户中心
    GetPage(name: '/member', page: () => const MemberPage()),
    // 二级回复
    GetPage(name: '/replyReply', page: () => const VideoReplyReplyPanel()),

    // 播放设置
    GetPage(name: '/playSetting', page: () => const PlaySetting()),
    // 外观设置
    GetPage(name: '/styleSetting', page: () => const StyleSetting()),
    // 隐私设置
    GetPage(name: '/privacySetting', page: () => const PrivacySetting()),
    // 其他设置
    GetPage(name: '/extraSetting', page: () => const ExtraSetting()),
    //
    GetPage(name: '/blackListPage', page: () => const BlackListPage()),
    GetPage(name: '/colorSetting', page: () => const ColorSelectPage()),
    GetPage(name: '/fontSizeSetting', page: () => const FontSizeSelectPage()),
    // 关于
    GetPage(name: '/about', page: () => const AboutPage()),
  ];
}
