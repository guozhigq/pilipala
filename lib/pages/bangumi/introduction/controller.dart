import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/bangumi.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/bangumi/info.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/pages/video/detail/reply/index.dart';
import 'package:pilipala/plugin/pl_player/models/play_repeat.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:share_plus/share_plus.dart';

import '../../../common/pages_bottom_sheet.dart';
import '../../../models/common/video_episode_type.dart';
import '../../../utils/drawer.dart';

class BangumiIntroController extends GetxController {
  // 视频bvid
  String bvid = Get.parameters['bvid']!;
  var seasonId = Get.parameters['seasonId'] != null
      ? int.tryParse(Get.parameters['seasonId']!)
      : null;
  var epId = Get.parameters['epId'] != null
      ? int.tryParse(Get.parameters['epId']!)
      : null;

  // 请求状态
  RxBool isLoading = false.obs;

  // 视频详情 请求返回
  Rx<BangumiInfoModel> bangumiDetail = BangumiInfoModel().obs;

  // 请求返回的信息
  String responseMsg = '请求异常';

  // up主粉丝数
  Map userStat = {'follower': '-'};

  // 是否点赞
  RxBool hasLike = false.obs;
  // 是否投币
  RxBool hasCoin = false.obs;
  // 是否收藏
  RxBool hasFav = false.obs;
  Box userInfoCache = GStorage.userInfo;
  bool userLogin = false;
  Rx<FavFolderData> favFolderData = FavFolderData().obs;
  List addMediaIdsNew = [];
  List delMediaIdsNew = [];
  // 追番状态  1想看 2在看 3已看
  RxBool isFollowed = false.obs;
  RxInt followStatus = 1.obs;
  int _tempThemeValue = -1;
  var userInfo;
  PersistentBottomSheetController? bottomSheetController;
  List<Map<String, dynamic>> followStatusList = [
    {'title': '标记为 「想看」', 'status': 1},
    {'title': '标记为 「在看」', 'status': 2},
    {'title': '标记为 「已看」', 'status': 3},
    {'title': '取消追番', 'status': -1},
  ];

  @override
  void onInit() {
    super.onInit();
    print('bangumi: ${Get.parameters.toString()}');
    userInfo = userInfoCache.get('userInfoCache');
    userLogin = userInfo != null;
    if (userLogin && seasonId != null) {
      bangumiStatus();
    }
  }

  // 获取番剧简介&选集
  Future queryBangumiIntro() async {
    if (userLogin) {
      // 获取点赞投币收藏状态
      bangumiActionStatus();
    }
    var result = await SearchHttp.bangumiInfo(seasonId: seasonId, epId: epId);
    if (result['status']) {
      bangumiDetail.value = result['data'];
      epId = bangumiDetail.value.episodes!.first.id;
    }
    return result;
  }

  // 获取番剧点赞投币收藏状态
  Future bangumiActionStatus() async {
    var result = await BangumiHttp.bangumiActionStatus(epId: epId!);
    if (result['status']) {
      hasLike.value = result['data']['like'] == 1;
      hasCoin.value = result['data']['coin_number'] != 0;
      hasFav.value = result['data']['favorite'] == 1;
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  // （取消）点赞
  Future actionLikeVideo() async {
    var result = await VideoHttp.likeVideo(bvid: bvid, type: !hasLike.value);
    if (result['status']) {
      SmartDialog.showToast(!hasLike.value ? '点赞成功' : '取消赞');
      hasLike.value = !hasLike.value;
      bangumiDetail.value.stat!['likes'] =
          bangumiDetail.value.stat!['likes'] + (!hasLike.value ? 1 : -1);
      hasLike.refresh();
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  // 投币
  Future actionCoinVideo() async {
    if (userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('选择投币个数'),
            contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [1, 2]
                    .map(
                      (e) => RadioListTile(
                        value: e,
                        title: Text('$e枚'),
                        groupValue: _tempThemeValue,
                        onChanged: (value) async {
                          _tempThemeValue = value!;
                          setState(() {});
                          var res = await VideoHttp.coinVideo(
                              bvid: bvid, multiply: _tempThemeValue);
                          if (res['status']) {
                            SmartDialog.showToast('投币成功');
                            hasCoin.value = true;
                            bangumiDetail.value.stat!['coins'] =
                                bangumiDetail.value.stat!['coins'] +
                                    _tempThemeValue;
                          } else {
                            SmartDialog.showToast(res['msg']);
                          }
                          Get.back();
                        },
                      ),
                    )
                    .toList(),
              );
            }),
          );
        });
  }

  // （取消）收藏
  Future actionFavVideo() async {
    try {
      for (var i in favFolderData.value.list!.toList()) {
        if (i.favState == 1) {
          addMediaIdsNew.add(i.id);
        } else {
          delMediaIdsNew.add(i.id);
        }
      }
    } catch (_) {}
    var result = await VideoHttp.favVideo(
        aid: IdUtils.bv2av(bvid),
        addIds: addMediaIdsNew.join(','),
        delIds: delMediaIdsNew.join(','));
    if (result['status']) {
      addMediaIdsNew = [];
      delMediaIdsNew = [];
      // 重新获取收藏状态
      bangumiActionStatus();
      SmartDialog.showToast('操作成功');
      Get.back();
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  // 分享视频
  Future actionShareVideo() async {
    var result = await Share.share('${HttpString.baseUrl}/video/$bvid')
        .whenComplete(() {});
    return result;
  }

  // 选择文件夹
  onChoose(bool checkValue, int index) {
    feedBack();
    List<FavFolderItemData> datalist = favFolderData.value.list!;
    for (var i = 0; i < datalist.length; i++) {
      if (i == index) {
        datalist[i].favState = checkValue == true ? 1 : 0;
        datalist[i].mediaCount = checkValue == true
            ? datalist[i].mediaCount! + 1
            : datalist[i].mediaCount! - 1;
      }
    }
    favFolderData.value.list = datalist;
    favFolderData.refresh();
  }

  // 修改分P或番剧分集
  Future changeSeasonOrbangu(bvid, cid, aid, cover) async {
    // 重新获取视频资源
    VideoDetailController videoDetailCtr =
        Get.find<VideoDetailController>(tag: Get.arguments['heroTag']);
    videoDetailCtr.bvid = bvid;
    videoDetailCtr.cid.value = cid;
    videoDetailCtr.danmakuCid.value = cid;
    videoDetailCtr.oid.value = aid;
    videoDetailCtr.cover.value = cover;
    videoDetailCtr.queryVideoUrl();
    videoDetailCtr.getSubtitle();
    videoDetailCtr.setSubtitleContent();
    // 重新请求评论
    try {
      /// 未渲染回复组件时可能异常
      VideoReplyController videoReplyCtr =
          Get.find<VideoReplyController>(tag: Get.arguments['heroTag']);
      videoReplyCtr.aid = aid;
      videoReplyCtr.queryReplyList(type: 'init');
    } catch (_) {}
  }

  // 追番
  Future bangumiAdd() async {
    var result = await VideoHttp.bangumiAdd(
        seasonId: seasonId ?? bangumiDetail.value.seasonId);
    if (result['status']) {
      followStatus.value = 2;
      isFollowed.value = true;
    }
    SmartDialog.showToast(result['msg']);
  }

  // 取消追番
  Future bangumiDel() async {
    var result = await VideoHttp.bangumiDel(
        seasonId: seasonId ?? bangumiDetail.value.seasonId);
    if (result['status']) {
      isFollowed.value = false;
    }
    SmartDialog.showToast(result['msg']);
  }

  Future queryVideoInFolder() async {
    var result = await VideoHttp.videoInFolder(
        mid: userInfo.mid, rid: IdUtils.bv2av(bvid));
    if (result['status']) {
      favFolderData.value = result['data'];
    }
    return result;
  }

  /// 列表循环或者顺序播放时，自动播放下一个
  void nextPlay() {
    late List episodes;
    if (bangumiDetail.value.episodes != null) {
      episodes = bangumiDetail.value.episodes!;
    }
    VideoDetailController videoDetailCtr =
        Get.find<VideoDetailController>(tag: Get.arguments['heroTag']);
    int currentIndex =
        episodes.indexWhere((e) => e.cid == videoDetailCtr.cid.value);
    int nextIndex = currentIndex + 1;
    PlayRepeat platRepeat = videoDetailCtr.plPlayerController.playRepeat;
    // 列表循环
    if (platRepeat == PlayRepeat.listCycle) {
      if (nextIndex == episodes.length - 1) {
        nextIndex = 0;
      }
    }
    if (nextIndex <= episodes.length - 1 &&
        platRepeat == PlayRepeat.listOrder) {}

    int cid = episodes[nextIndex].cid!;
    String bvid = episodes[nextIndex].bvid!;
    int aid = episodes[nextIndex].aid!;
    String cover = episodes[nextIndex].cover!;
    changeSeasonOrbangu(bvid, cid, aid, cover);
  }

  // 播放器底栏 选集 回调
  void showEposideHandler() {
    late List episodes = bangumiDetail.value.episodes!;
    VideoEpidoesType dataType = VideoEpidoesType.bangumiEpisode;
    if (episodes.isEmpty) {
      return;
    }
    VideoDetailController videoDetailCtr =
        Get.find<VideoDetailController>(tag: Get.arguments['heroTag']);
    DrawerUtils.showRightDialog(
      child: EpisodeBottomSheet(
        episodes: episodes,
        currentCid: videoDetailCtr.cid.value,
        dataType: dataType,
        sheetHeight: Get.size.height,
        isFullScreen: true,
        changeFucCall: (item, index) {
          changeSeasonOrbangu(item.bvid, item.cid, item.aid, item.cover);
          SmartDialog.dismiss();
        },
      ).buildShowContent(),
    );
  }

  hiddenEpisodeBottomSheet() {
    bottomSheetController?.close();
  }

  // 获取追番状态
  Future bangumiStatus() async {
    var result = await BangumiHttp.bangumiStatus(seasonId: seasonId!);
    if (result['status']) {
      followStatus.value = result['data']['followStatus'];
      isFollowed.value = result['data']['isFollowed'];
    }
    return result;
  }

  // 更新追番状态
  Future updateBangumiStatus(int status) async {
    Get.back();
    if (status == -1) {
      bangumiDel();
    } else {
      var result = await BangumiHttp.bangumiStatus(seasonId: seasonId!);
      if (result['status']) {
        followStatus.value = status;
        final title = followStatusList.firstWhere(
          (e) => e['status'] == status,
          orElse: () => {'title': '未知状态'},
        )['title'];
        SmartDialog.showToast('追番状态$title');
      } else {
        SmartDialog.showToast(result['msg']);
      }
      return result;
    }
  }
}
