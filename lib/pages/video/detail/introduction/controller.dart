import 'dart:async';

// import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/models/user/info.dart';
import 'package:pilipala/models/video/ai.dart';
import 'package:pilipala/models/video/tags.dart';
import 'package:pilipala/models/video_detail_res.dart';
import 'package:pilipala/pages/video/detail/controller.dart';
import 'package:pilipala/pages/video/detail/reply/index.dart';
import 'package:pilipala/plugin/pl_player/models/play_repeat.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/global_data_cache.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../common/pages_bottom_sheet.dart';
import '../../../../models/common/video_episode_type.dart';
import '../../../../utils/drawer.dart';
import '../related/index.dart';
import 'widgets/group_panel.dart';

class VideoIntroController extends GetxController {
  VideoIntroController({required this.bvid});
  // 视频bvid
  String bvid;
  // 视频详情 请求返回
  Rx<VideoDetailData> videoDetail = VideoDetailData().obs;
  // up主粉丝数
  RxInt follower = 0.obs;
  // 是否点赞
  RxBool hasLike = false.obs;
  // 是否投币
  RxBool hasCoin = false.obs;
  // 是否收藏
  RxBool hasFav = false.obs;
  // 是否不喜欢
  RxBool hasDisLike = false.obs;
  Box userInfoCache = GStorage.userInfo;
  bool userLogin = false;
  Rx<FavFolderData> favFolderData = FavFolderData().obs;
  List addMediaIdsNew = [];
  List delMediaIdsNew = [];
  // 关注状态 默认未关注
  RxMap followStatus = {}.obs;
  RxInt lastPlayCid = 0.obs;
  UserInfoData? userInfo;
  RxList<VideoTagItem> videoTags = <VideoTagItem>[].obs;

  // 同时观看
  bool isShowOnlineTotal = false;
  RxString total = '1'.obs;
  Timer? timer;
  bool isPaused = false;
  String heroTag = '';
  late ModelResult modelResult;
  PersistentBottomSheetController? bottomSheetController;
  late bool enableRelatedVideo;
  UgcSeason? ugcSeason;
  RxList<Part> pages = <Part>[].obs;

  @override
  void onInit() {
    super.onInit();
    userInfo = userInfoCache.get('userInfoCache');
    try {
      heroTag = Get.arguments['heroTag'];
    } catch (_) {}
    userLogin = userInfo != null;
    lastPlayCid.value = int.parse(Get.parameters['cid']!);
    isShowOnlineTotal =
        setting.get(SettingBoxKey.enableOnlineTotal, defaultValue: false);
    if (isShowOnlineTotal) {
      queryOnlineTotal();
      startTimer(); // 在页面加载时启动定时器
    }
    enableRelatedVideo =
        setting.get(SettingBoxKey.enableRelatedVideo, defaultValue: true);
    queryVideoTag();
  }

  // 获取视频简介&分p
  Future queryVideoIntro({String? cover, String? type, int? cid}) async {
    var result = await VideoHttp.videoIntro(bvid: bvid);
    if (result['status']) {
      videoDetail.value = result['data']!;
      ugcSeason = result['data']!.ugcSeason;
      pages.value = result['data']!.pages!;
      if (type == null) {
        lastPlayCid.value = cid ?? videoDetail.value.cid!;
      }
      final VideoDetailController videoDetailCtr =
          Get.find<VideoDetailController>(tag: heroTag);
      videoDetailCtr.tabs.value = [
        '简介',
        if (GlobalDataCache.enableComment.contains('video'))
          '评论 ${result['data']?.stat?.reply}'
      ];
      videoDetailCtr.cover.value = cover ?? result['data'].pic ?? '';
      // 获取到粉丝数再返回
      await queryUserStat();
    }
    if (userLogin) {
      // 获取点赞状态
      queryHasLikeVideo();
      // 获取投币状态
      queryHasCoinVideo();
      // 获取收藏状态
      queryHasFavVideo();
      //
      queryFollowStatus();
    }
    return result;
  }

  // 获取up主粉丝数
  Future queryUserStat() async {
    var result = await UserHttp.userStat(mid: videoDetail.value.owner!.mid!);
    if (result['status']) {
      follower.value = result['data']['follower'];
    }
  }

  // 获取点赞状态
  Future queryHasLikeVideo() async {
    var result = await VideoHttp.hasLikeVideo(bvid: bvid);
    // data	num	被点赞标志	0：未点赞  1：已点赞
    hasLike.value = result["data"] == 1 ? true : false;
  }

  // 获取投币状态
  Future queryHasCoinVideo() async {
    var result = await VideoHttp.hasCoinVideo(bvid: bvid);
    if (result['status']) {
      hasCoin.value = result["data"]['multiply'] == 0 ? false : true;
    }
  }

  // 获取收藏状态
  Future queryHasFavVideo() async {
    /// fix 延迟查询
    await Future.delayed(const Duration(milliseconds: 200));
    var result = await VideoHttp.hasFavVideo(aid: IdUtils.bv2av(bvid));
    if (result['status']) {
      hasFav.value = result["data"]['favoured'];
    } else {
      hasFav.value = false;
    }
  }

  // 一键三连
  Future actionOneThree() async {
    if (userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    if (hasLike.value && hasCoin.value && hasFav.value) {
      // 已点赞、投币、收藏
      SmartDialog.showToast('UP已经收到了～');
      return false;
    }
    var result = await VideoHttp.oneThree(bvid: bvid);
    if (result['status']) {
      hasLike.value = result["data"]["like"];
      hasCoin.value = result["data"]["coin"];
      hasFav.value = result["data"]["fav"];
      SmartDialog.showToast('三连成功');
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  // （取消）点赞
  Future actionLikeVideo() async {
    if (userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    var result = await VideoHttp.likeVideo(bvid: bvid, type: !hasLike.value);
    if (result['status']) {
      if (!hasLike.value) {
        SmartDialog.showToast('点赞成功');
        hasLike.value = true;
        videoDetail.value.stat!.like = videoDetail.value.stat!.like! + 1;
      } else if (hasLike.value) {
        SmartDialog.showToast('取消赞');
        hasLike.value = false;
        videoDetail.value.stat!.like = videoDetail.value.stat!.like! - 1;
      }
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [1, 2]
                  .map(
                    (e) => ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text('$e 枚'),
                      ),
                      onTap: () async {
                        var res =
                            await VideoHttp.coinVideo(bvid: bvid, multiply: e);
                        if (res['status']) {
                          SmartDialog.showToast('投币成功');
                          hasCoin.value = true;
                          videoDetail.value.stat!.coin =
                              videoDetail.value.stat!.coin! + e;
                        } else {
                          SmartDialog.showToast(res['msg']);
                        }
                        Get.back();
                      },
                    ),
                  )
                  .toList(),
            ),
          );
        });
  }

  // （取消）收藏
  Future actionFavVideo({type = 'choose'}) async {
    // 收藏至默认文件夹
    if (type == 'default') {
      await queryVideoInFolder();
      int defaultFolderId = favFolderData.value.list!.first.id!;
      int favStatus = favFolderData.value.list!.first.favState!;
      var result = await VideoHttp.favVideo(
        aid: IdUtils.bv2av(bvid),
        addIds: favStatus == 0 ? '$defaultFolderId' : '',
        delIds: favStatus == 1 ? '$defaultFolderId' : '',
      );
      if (result['status']) {
        // 重新获取收藏状态
        await queryHasFavVideo();
        SmartDialog.showToast('操作成功');
      } else {
        SmartDialog.showToast(result['msg']);
      }
      return;
    }
    try {
      for (var i in favFolderData.value.list!.toList()) {
        if (i.favState == 1) {
          addMediaIdsNew.add(i.id);
        } else {
          delMediaIdsNew.add(i.id);
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    SmartDialog.showLoading(msg: '请求中');
    var result = await VideoHttp.favVideo(
        aid: IdUtils.bv2av(bvid),
        addIds: addMediaIdsNew.join(','),
        delIds: delMediaIdsNew.join(','));
    SmartDialog.dismiss();
    if (result['status']) {
      addMediaIdsNew = [];
      delMediaIdsNew = [];
      Get.back();
      // 重新获取收藏状态
      await queryHasFavVideo();
      SmartDialog.showToast('操作成功');
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  // 分享视频
  Future actionShareVideo() async {
    var result = await Share.share(
            '${videoDetail.value.title} UP主: ${videoDetail.value.owner!.name!} - ${HttpString.baseUrl}/video/$bvid')
        .whenComplete(() {});
    return result;
  }

  Future queryVideoInFolder() async {
    var result = await VideoHttp.videoInFolder(
        mid: userInfo!.mid!, rid: IdUtils.bv2av(bvid));
    if (result['status']) {
      favFolderData.value = result['data'];
    }
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

  // 查询关注状态
  Future queryFollowStatus() async {
    if (videoDetail.value.owner == null) {
      return;
    }
    var result = await VideoHttp.hasFollow(mid: videoDetail.value.owner!.mid!);
    if (result['status']) {
      followStatus.value = result['data'];
    }
    return result;
  }

  // 关注/取关up
  Future actionRelationMod() async {
    feedBack();
    if (userInfo == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    final int currentStatus = followStatus['attribute'];
    if (currentStatus == 128) {
      modifyRelation('block', currentStatus);
    } else {
      modifyRelation('follow', currentStatus);
    }
  }

  // 操作用户关系
  Future modifyRelation(String actionType, int currentStatus) async {
    final int mid = videoDetail.value.owner!.mid!;
    String contentText;
    int act;
    if (actionType == 'follow') {
      contentText = currentStatus != 0 ? '确定取消关注UP主?' : '确定关注UP主?';
      act = currentStatus != 0 ? 2 : 1;
    } else if (actionType == 'block') {
      contentText = '确定从黑名单移除UP主?';
      act = 6;
    } else {
      return;
    }

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        final Color outline = Theme.of(Get.context!).colorScheme.outline;
        return AlertDialog(
          title: const Text('提示'),
          content: Text(contentText),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text('点错了', style: TextStyle(color: outline)),
            ),
            TextButton(
              onPressed: () => modifyRelationFetch(
                context,
                mid,
                act,
                currentStatus,
                actionType,
              ),
              child: const Text('确定'),
            )
          ],
        );
      },
    );
  }

  // 操作用户关系Future
  Future modifyRelationFetch(
    BuildContext context,
    mid,
    act,
    currentStatus,
    actionType,
  ) async {
    var res = await VideoHttp.relationMod(mid: mid, act: act, reSrc: 11);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    if (res['status']) {
      if (actionType == 'follow') {
        final Map<int, int> statusMap = {
          0: 2,
          2: 0,
        };
        late int actionStatus;
        actionStatus = statusMap[currentStatus] ?? 0;
        followStatus['attribute'] = actionStatus;
        if (currentStatus == 0 && Get.context!.mounted) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: const Text('关注成功'),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: '设置分组',
                onPressed: setFollowGroup,
              ),
              showCloseIcon: true,
            ),
          );
        } else {
          SmartDialog.showToast('取消关注成功');
        }
      } else if (actionType == 'block') {
        followStatus['attribute'] = 0;
        SmartDialog.showToast('取消拉黑成功');
      }
      followStatus.refresh();
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  // 修改分P或番剧分集
  Future changeSeasonOrbangu(
    String bvid,
    int cid,
    int? aid,
    String? cover,
  ) async {
    // 重新获取视频资源
    final VideoDetailController videoDetailCtr =
        Get.find<VideoDetailController>(tag: heroTag);
    if (enableRelatedVideo) {
      final ReleatedController releatedCtr =
          Get.find<ReleatedController>(tag: heroTag);
      releatedCtr.bvid = bvid;
      releatedCtr.queryRelatedVideo();
    }

    videoDetailCtr
      ..bvid = bvid
      ..oid.value = aid ?? IdUtils.bv2av(bvid)
      ..cid.value = cid
      ..danmakuCid.value = cid
      ..cover.value = cover ?? ''
      ..queryVideoUrl()
      ..clearSubtitleContent();
    await videoDetailCtr.getSubtitle();
    videoDetailCtr.setSubtitleContent();
    // 重新请求评论
    try {
      /// 未渲染回复组件时可能异常
      if (GlobalDataCache.enableComment.contains('video')) {
        final VideoReplyController videoReplyCtr =
            Get.find<VideoReplyController>(tag: heroTag);
        videoReplyCtr.aid = aid;
        videoReplyCtr.queryReplyList(type: 'init');
      }
    } catch (_) {}
    this.bvid = bvid;
    // 点击切换时，优先取当前cid
    await queryVideoIntro(cover: cover, cid: cid);
  }

  void startTimer() {
    const duration = Duration(seconds: 10); // 设置定时器间隔为10秒
    timer = Timer.periodic(duration, (Timer timer) {
      if (!isPaused) {
        queryOnlineTotal(); // 定时器回调函数，发起请求
      }
    });
  }

  // 查看同时在看人数
  Future queryOnlineTotal() async {
    var result = await VideoHttp.onlineTotal(
      aid: IdUtils.bv2av(bvid),
      bvid: bvid,
      cid: lastPlayCid.value,
    );
    if (result['status']) {
      total.value = result['data']['total'];
    }
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel(); // 销毁页面时取消定时器
    }
    super.onClose();
  }

  /// 列表循环或者顺序播放时，自动播放下一个
  void nextPlay() {
    final List episodes = [];
    bool isPages = false;
    late String cover;
    final VideoDetailController videoDetailCtr =
        Get.find<VideoDetailController>(tag: heroTag);

    /// 优先稍后再看、收藏夹
    if (videoDetailCtr.isWatchLaterVisible.value) {
      episodes.addAll(videoDetailCtr.mediaList);
    } else if (videoDetail.value.ugcSeason != null) {
      final UgcSeason ugcSeason = videoDetail.value.ugcSeason!;
      final List<SectionItem> sections = ugcSeason.sections!;
      for (int i = 0; i < sections.length; i++) {
        final List<EpisodeItem> episodesList = sections[i].episodes!;
        episodes.addAll(episodesList);
      }
    } else if (pages.isNotEmpty) {
      isPages = true;
      episodes.addAll(pages);
    }

    final int currentIndex =
        episodes.indexWhere((e) => e.cid == lastPlayCid.value);
    int nextIndex = currentIndex + 1;
    cover = episodes[nextIndex].cover;
    final PlayRepeat platRepeat = videoDetailCtr.plPlayerController.playRepeat;

    int cid = episodes[nextIndex].cid!;
    while (cid == -1) {
      nextIndex += 1;
      SmartDialog.showToast('当前视频暂不支持播放，自动跳过');
      cid = episodes[nextIndex].cid!;
    }

    // 列表循环
    if (nextIndex >= episodes.length) {
      if (platRepeat == PlayRepeat.listCycle) {
        nextIndex = 0;
      }
      if (platRepeat == PlayRepeat.listOrder) {
        return;
      }
    }
    final String rBvid = isPages ? bvid : episodes[nextIndex].bvid;
    final int rAid = isPages ? IdUtils.bv2av(bvid) : episodes[nextIndex].aid!;
    changeSeasonOrbangu(rBvid, cid, rAid, cover);
  }

  // 设置关注分组
  void setFollowGroup() async {
    final mediaQueryData = MediaQuery.of(Get.context!);
    final contentHeight = mediaQueryData.size.height - kToolbarHeight;
    final double initialChildSize =
        (contentHeight - Get.width * 9 / 16) / contentHeight;
    await showModalBottomSheet(
      context: Get.context!,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: 0,
          maxChildSize: 1,
          snap: true,
          expand: false,
          snapSizes: [initialChildSize],
          builder: (BuildContext context, ScrollController scrollController) {
            return GroupPanel(
              mid: videoDetail.value.owner!.mid!,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  // ai总结
  Future aiConclusion() async {
    SmartDialog.showLoading(msg: '正在生成ai总结');
    final res = await VideoHttp.aiConclusion(
      bvid: bvid,
      cid: lastPlayCid.value,
      upMid: videoDetail.value.owner!.mid!,
    );
    SmartDialog.dismiss();
    if (res['status']) {
      modelResult = res['data'].modelResult;
    } else {
      SmartDialog.showToast("当前视频暂不支持AI视频总结");
    }
    return res;
  }

  hiddenEpisodeBottomSheet() {
    bottomSheetController?.close();
  }

  // 播放器底栏 选集 回调
  void showEposideHandler() {
    late List episodes;
    int currentEpisodeIndex = 0;
    VideoEpidoesType dataType = VideoEpidoesType.videoEpisode;
    if (videoDetail.value.ugcSeason != null) {
      dataType = VideoEpidoesType.videoEpisode;
      final List<SectionItem> sections = videoDetail.value.ugcSeason!.sections!;
      for (int i = 0; i < sections.length; i++) {
        final List<EpisodeItem> episodesList = sections[i].episodes!;
        for (int j = 0; j < episodesList.length; j++) {
          if (episodesList[j].cid == lastPlayCid.value) {
            currentEpisodeIndex = i;
            episodes = episodesList;
            continue;
          }
        }
      }
    }
    if (pages.length > 1) {
      dataType = VideoEpidoesType.videoPart;
      episodes = pages;
    }

    DrawerUtils.showRightDialog(
      child: EpisodeBottomSheet(
        episodes: episodes,
        currentCid: lastPlayCid.value,
        dataType: dataType,
        sheetHeight: Get.size.height,
        isFullScreen: true,
        ugcSeason: ugcSeason,
        currentEpisodeIndex: currentEpisodeIndex,
        changeFucCall: (item, index) {
          if (dataType == VideoEpidoesType.videoEpisode) {
            changeSeasonOrbangu(
                IdUtils.av2bv(item.aid), item.cid, item.aid, item.cover);
          }
          if (dataType == VideoEpidoesType.videoPart) {
            changeSeasonOrbangu(bvid, item.cid, null, item.cover);
          }
          SmartDialog.dismiss();
        },
      ).buildShowContent(),
    );
  }

  //
  oneThreeDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('是否一键三连'),
          actions: [
            TextButton(
              onPressed: () => navigator!.pop(),
              child: Text(
                '取消',
                style: TextStyle(
                    color: Theme.of(Get.context!).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                actionOneThree();
                navigator!.pop();
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }

  // 获取视频标签
  void queryVideoTag() async {
    var result = await VideoHttp.getVideoTag(bvid: bvid);
    if (result['status']) {
      videoTags.value = result['data'];
    }
  }
}
