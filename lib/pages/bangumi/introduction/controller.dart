import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/constants.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/bangumi/info.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/models/video_detail_res.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/id_utils.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:share_plus/share_plus.dart';

class BangumiIntroController extends GetxController {
  // 视频bvid
  String bvid = Get.parameters['bvid']!;
  var seasonId = Get.parameters['seasonId'] != null
      ? int.parse(Get.parameters['seasonId']!)
      : null;
  var epId = Get.parameters['epId'] != null
      ? int.parse(Get.parameters['epId']!)
      : null;

  // 是否预渲染 骨架屏
  bool preRender = false;

  // 视频详情 上个页面传入
  Map? videoItem = {};
  BangumiInfoModel? bangumiItem;

  // 请求状态
  RxBool isLoading = false.obs;

  // 视频详情 请求返回
  Rx<VideoDetailData> videoDetail = VideoDetailData().obs;
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
  Box user = GStrorage.user;
  bool userLogin = false;
  Rx<FavFolderData> favFolderData = FavFolderData().obs;
  List addMediaIdsNew = [];
  List delMediaIdsNew = [];
  // 关注状态 默认未关注
  RxMap followStatus = {}.obs;
  int _tempThemeValue = -1;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments.isNotEmpty) {
      if (Get.arguments.containsKey('bangumiItem')) {
        preRender = true;
        bangumiItem = Get.arguments['bangumiItem'];
        // bangumiItem!['pic'] = args.pic;
        // if (args.title is String) {
        //   videoItem!['title'] = args.title;
        // } else {
        //   String str = '';
        //   for (Map map in args.title) {
        //     str += map['text'];
        //   }
        //   videoItem!['title'] = str;
        // }
        // if (args.stat != null) {
        //   videoItem!['stat'] = args.stat;
        // }
        // videoItem!['pubdate'] = args.pubdate;
        // videoItem!['owner'] = args.owner;
      }
    }
    userLogin = user.get(UserBoxKey.userLogin) != null;
  }

  // 获取番剧简介&选集
  Future queryBangumiIntro() async {
    var result = await SearchHttp.bangumiInfo(seasonId: seasonId, epId: epId);
    if (result['status']) {
      bangumiDetail.value = result['data'];
    }
    if (userLogin) {
      // 获取点赞状态
      // queryHasLikeVideo();
      // 获取投币状态
      // queryHasCoinVideo();
      // 获取收藏状态
      // queryHasFavVideo();
      //
      // queryFollowStatus();
    }
    return result;
  }

  // 获取up主粉丝数
  Future queryUserStat() async {
    var result = await UserHttp.userStat(mid: videoDetail.value.owner!.mid!);
    if (result['status']) {
      userStat = result['data'];
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
    hasCoin.value = result["data"]['multiply'] == 0 ? false : true;
  }

  // 获取收藏状态
  Future queryHasFavVideo() async {
    var result = await VideoHttp.hasFavVideo(aid: IdUtils.bv2av(bvid));
    if (result['status']) {
      hasFav.value = result["data"]['favoured'];
    } else {
      hasFav.value = false;
    }
  }

  // 一键三连
  Future actionOneThree() async {
    if (user.get(UserBoxKey.userMid) == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    if (hasLike.value && hasCoin.value && hasFav.value) {
      // 已点赞、投币、收藏
      SmartDialog.showToast('🙏 UP已经收到了～');
      return false;
    }
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('一键三连 给UP送温暖'),
          actions: [
            TextButton(
                onPressed: () => SmartDialog.dismiss(),
                child: const Text('点错了')),
            TextButton(
              onPressed: () async {
                var result = await VideoHttp.oneThree(bvid: bvid);
                if (result['status']) {
                  hasLike.value = result["data"]["like"];
                  hasCoin.value = result["data"]["coin"];
                  hasFav.value = result["data"]["fav"];
                  SmartDialog.showToast('三连成功 🎉');
                } else {
                  SmartDialog.showToast(result['msg']);
                }
                SmartDialog.dismiss();
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }

  // （取消）点赞
  Future actionLikeVideo() async {
    var result = await VideoHttp.likeVideo(bvid: bvid, type: !hasLike.value);
    if (result['status']) {
      // hasLike.value = result["data"] == 1 ? true : false;
      if (!hasLike.value) {
        SmartDialog.showToast('点赞成功 👍');
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
    if (user.get(UserBoxKey.userMid) == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('选择投币个数'),
            contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
            content: StatefulBuilder(builder: (context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile(
                    value: 1,
                    title: const Text('1枚'),
                    groupValue: _tempThemeValue,
                    onChanged: (value) {
                      _tempThemeValue = value!;
                      Get.appUpdate();
                    },
                  ),
                  RadioListTile(
                    value: 2,
                    title: const Text('2枚'),
                    groupValue: _tempThemeValue,
                    onChanged: (value) {
                      _tempThemeValue = value!;
                      Get.appUpdate();
                    },
                  ),
                ],
              );
            }),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('取消')),
              TextButton(
                  onPressed: () async {
                    var res = await VideoHttp.coinVideo(
                        bvid: bvid, multiply: _tempThemeValue);
                    if (res['status']) {
                      SmartDialog.showToast('投币成功 👏');
                      hasCoin.value = true;
                      videoDetail.value.stat!.coin =
                          videoDetail.value.stat!.coin! + _tempThemeValue;
                    } else {
                      SmartDialog.showToast(res['msg']);
                    }
                    Get.back();
                  },
                  child: const Text('确定'))
            ],
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
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    var result = await VideoHttp.favVideo(
        aid: IdUtils.bv2av(bvid),
        addIds: addMediaIdsNew.join(','),
        delIds: delMediaIdsNew.join(','));
    if (result['status']) {
      if (result['data']['prompt']) {
        addMediaIdsNew = [];
        delMediaIdsNew = [];
        Get.back();
        // 重新获取收藏状态
        queryHasFavVideo();
        SmartDialog.showToast('✅ 操作成功');
      }
    }
  }

  // 分享视频
  Future actionShareVideo() async {
    var result = await Share.share('${HttpString.baseUrl}/video/$bvid')
        .whenComplete(() {});
    return result;
  }

  Future queryVideoInFolder() async {
    var result = await VideoHttp.videoInFolder(
        mid: user.get(UserBoxKey.userMid), rid: IdUtils.bv2av(bvid));
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
    var result = await VideoHttp.hasFollow(mid: videoDetail.value.owner!.mid!);
    if (result['status']) {
      followStatus.value = result['data'];
    }
    return result;
  }

  // 关注/取关up
  Future actionRelationMod() async {
    feedBack();
    if (user.get(UserBoxKey.userMid) == null) {
      SmartDialog.showToast('账号未登录');
      return;
    }
    int currentStatus = followStatus['attribute'];
    int actionStatus = 0;
    switch (currentStatus) {
      case 0:
        actionStatus = 1;
        break;
      case 2:
        actionStatus = 2;
        break;
      default:
        actionStatus = 0;
        break;
    }
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: Text(currentStatus == 0 ? '关注UP主?' : '取消关注UP主?'),
          actions: [
            TextButton(
                onPressed: () => SmartDialog.dismiss(),
                child: const Text('点错了')),
            TextButton(
              onPressed: () async {
                var result = await VideoHttp.relationMod(
                  mid: videoDetail.value.owner!.mid!,
                  act: actionStatus,
                  reSrc: 14,
                );
                if (result['status']) {
                  switch (currentStatus) {
                    case 0:
                      actionStatus = 2;
                      break;
                    case 2:
                      actionStatus = 0;
                      break;
                    default:
                      actionStatus = 0;
                      break;
                  }
                  followStatus['attribute'] = actionStatus;
                  followStatus.refresh();
                }
                SmartDialog.dismiss();
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }

  // 修改分P或番剧分集
  Future changeSeasonOrbangu(bvid, cid) async {
    VideoDetailController videoDetailCtr =
        Get.find<VideoDetailController>(tag: Get.arguments['heroTag']);
    videoDetailCtr.bvid = bvid;
    videoDetailCtr.cid = cid;
    videoDetailCtr.queryVideoUrl();
  }
}
