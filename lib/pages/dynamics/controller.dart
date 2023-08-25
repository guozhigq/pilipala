// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/dynamics.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/bangumi/info.dart';
import 'package:pilipala/models/common/dynamics_type.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/models/dynamics/up.dart';
import 'package:pilipala/models/live/item.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:pilipala/utils/utils.dart';

class DynamicsController extends GetxController {
  int page = 1;
  String? offset = '';
  RxList<DynamicItemModel> dynamicsList = [DynamicItemModel()].obs;
  Rx<DynamicsType> dynamicsType = DynamicsType.values[0].obs;
  RxString dynamicsTypeLabel = '全部'.obs;
  final ScrollController scrollController = ScrollController();
  Rx<FollowUpModel> upData = FollowUpModel().obs;
  // 默认获取全部动态
  RxInt mid = (-1).obs;
  Rx<UpItem> upInfo = UpItem().obs;
  List filterTypeList = [
    {
      'label': DynamicsType.all.labels,
      'value': DynamicsType.all,
      'enabled': true
    },
    {
      'label': DynamicsType.video.labels,
      'value': DynamicsType.video,
      'enabled': true
    },
    {
      'label': DynamicsType.pgc.labels,
      'value': DynamicsType.pgc,
      'enabled': true
    },
    {
      'label': DynamicsType.article.labels,
      'value': DynamicsType.article,
      'enabled': true
    },
  ];
  bool flag = false;
  RxInt initialValue = 0.obs;
  Box userInfoCache = GStrorage.userInfo;
  RxBool userLogin = false.obs;
  var userInfo;
  RxBool isLoadingDynamic = false.obs;
  Box setting = GStrorage.setting;

  @override
  void onInit() {
    userInfo = userInfoCache.get('userInfoCache');
    userLogin.value = userInfo != null;
    super.onInit();
    initialValue.value =
        setting.get(SettingBoxKey.defaultDynamicType, defaultValue: 0);
    dynamicsType = DynamicsType.values[initialValue.value].obs;
  }

  Future queryFollowDynamic({type = 'init'}) async {
    if (!userLogin.value) {
      return {'status': false, 'msg': '账号未登录'};
    }
    if (type == 'init') {
      dynamicsList.clear();
    }
    // 下拉刷新数据渲染时会触发onLoad
    if (type == 'onLoad' && page == 1) {
      return;
    }
    isLoadingDynamic.value = true;
    var res = await DynamicsHttp.followDynamic(
      page: type == 'init' ? 1 : page,
      type: dynamicsType.value.values,
      offset: offset,
      mid: mid.value,
    );
    isLoadingDynamic.value = false;
    if (res['status']) {
      if (type == 'onLoad' && res['data'].items.isEmpty) {
        SmartDialog.showToast('没有更多了');
        return;
      }
      if (type == 'init') {
        dynamicsList.value = res['data'].items;
      } else {
        dynamicsList.addAll(res['data'].items);
      }
      offset = res['data'].offset;
      page++;
    }
    return res;
  }

  onSelectType(value) async {
    dynamicsType.value = filterTypeList[value]['value'];
    dynamicsList.value = [DynamicItemModel()];
    page = 1;
    initialValue.value = value;
    await queryFollowDynamic();
    scrollController.jumpTo(0);
  }

  pushDetail(item, floor, {action = 'all'}) async {
    feedBack();

    /// 点击评论action 直接查看评论
    if (action == 'comment') {
      Get.toNamed('/dynamicDetail',
          arguments: {'item': item, 'floor': floor, 'action': action});
      return false;
    }
    switch (item!.type) {
      /// 转发的动态
      case 'DYNAMIC_TYPE_FORWARD':
        Get.toNamed('/dynamicDetail',
            arguments: {'item': item, 'floor': floor});
        break;

      /// 图文动态查看
      case 'DYNAMIC_TYPE_DRAW':
        Get.toNamed('/dynamicDetail',
            arguments: {'item': item, 'floor': floor});
        break;
      case 'DYNAMIC_TYPE_AV':
        String bvid = item.modules.moduleDynamic.major.archive.bvid;
        String cover = item.modules.moduleDynamic.major.archive.cover;
        try {
          int cid = await SearchHttp.ab2c(bvid: bvid);
          Get.toNamed('/video?bvid=$bvid&cid=$cid',
              arguments: {'pic': cover, 'heroTag': bvid});
        } catch (err) {
          SmartDialog.showToast(err.toString());
        }
        break;

      /// 专栏文章查看
      case 'DYNAMIC_TYPE_ARTICLE':
        String title = item.modules.moduleDynamic.major.opus.title;
        String url = item.modules.moduleDynamic.major.opus.jumpUrl;
        Get.toNamed(
          '/webview',
          parameters: {'url': 'https:$url', 'type': 'note', 'pageTitle': title},
        );
        break;
      case 'DYNAMIC_TYPE_PGC':
        print('番剧');
        SmartDialog.showToast('暂未支持的类型，请联系开发者');
        break;

      /// 纯文字动态查看
      case 'DYNAMIC_TYPE_WORD':
        print('纯文本');
        Get.toNamed('/dynamicDetail',
            arguments: {'item': item, 'floor': floor});
        break;
      case 'DYNAMIC_TYPE_LIVE_RCMD':
        DynamicLiveModel liveRcmd = item.modules.moduleDynamic.major.liveRcmd;
        ModuleAuthorModel author = item.modules.moduleAuthor;
        LiveItemModel liveItem = LiveItemModel.fromJson({
          'title': liveRcmd.title,
          'uname': author.name,
          'cover': liveRcmd.cover,
          'mid': author.mid,
          'face': author.face,
          'roomid': liveRcmd.roomId,
          'watched_show': liveRcmd.watchedShow,
        });
        Get.toNamed('/liveRoom?roomid=${liveItem.roomId}', arguments: {
          'liveItem': liveItem,
          'heroTag': liveItem.roomId.toString()
        });
        break;

      /// 合集查看
      case 'DYNAMIC_TYPE_UGC_SEASON':
        DynamicArchiveModel ugcSeason =
            item.modules.moduleDynamic.major.ugcSeason;
        int aid = ugcSeason.aid!;
        String bvid = IdUtils.av2bv(aid);
        String cover = ugcSeason.cover!;
        int cid = await SearchHttp.ab2c(bvid: bvid);
        Get.toNamed('/video?bvid=$bvid&cid=$cid',
            arguments: {'pic': cover, 'heroTag': bvid});
        break;

      /// 番剧查看
      case 'DYNAMIC_TYPE_PGC_UNION':
        print('DYNAMIC_TYPE_PGC_UNION 番剧');
        DynamicArchiveModel pgc = item.modules.moduleDynamic.major.pgc;
        if (pgc.epid != null) {
          SmartDialog.showLoading(msg: '获取中...');
          var res = await SearchHttp.bangumiInfo(epId: pgc.epid);
          SmartDialog.dismiss();
          if (res['status']) {
            EpisodeItem episode = res['data'].episodes.first;
            String bvid = episode.bvid!;
            int cid = episode.cid!;
            String pic = episode.cover!;
            String heroTag = Utils.makeHeroTag(cid);
            Get.toNamed(
              '/video?bvid=$bvid&cid=$cid&seasonId=${res['data'].seasonId}',
              arguments: {
                'pic': pic,
                'heroTag': heroTag,
                'videoType': SearchType.media_bangumi,
                'bangumiItem': res['data'],
              },
            );
          }
        }
        break;
    }
  }

  Future queryFollowUp({type = 'init'}) async {
    if (!userLogin.value) {
      return {'status': false, 'msg': '账号未登录'};
    }
    if (type == 'init') {
      upData.value.upList = [];
      upData.value.liveUsers = LiveUsers();
    }
    var res = await DynamicsHttp.followUp();
    if (res['status']) {
      upData.value = res['data'];
      if (upData.value.upList!.isEmpty) {
        mid.value = -1;
      }
    }
    return res;
  }

  onSelectUp(mid) async {
    dynamicsType.value = DynamicsType.values[0];
    dynamicsList.value = [DynamicItemModel()];
    page = 1;
    queryFollowDynamic();
  }

  onRefresh() async {
    page = 1;
    print('onRefresh');
    await queryFollowUp();
    await queryFollowDynamic();
  }

  // 返回顶部并刷新
  void animateToTop() async {
    if (scrollController.offset >=
        MediaQuery.of(Get.context!).size.height * 5) {
      scrollController.jumpTo(0);
    } else {
      await scrollController.animateTo(0,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  // 重置搜索
  void resetSearch() {
    mid.value = -1;
    dynamicsType.value = DynamicsType.values[0];
    initialValue.value = 0;
    SmartDialog.showToast('还原默认加载');
    dynamicsList.value = [DynamicItemModel()];
    queryFollowDynamic();
  }
}
