import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/common.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/user/fav_detail.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/pages/fav/index.dart';
import 'package:pilipala/utils/utils.dart';

import 'widget/invalid_video_card.dart';

class FavDetailController extends GetxController {
  FavFolderItemData? item;
  RxString title = ''.obs;

  int? mediaId;
  late String heroTag;
  int currentPage = 1;
  bool isLoadingMore = false;
  RxMap favInfo = {}.obs;
  RxList<FavDetailItemData> favList = <FavDetailItemData>[].obs;
  RxString loadingText = '加载中...'.obs;
  RxInt mediaCount = 0.obs;
  late String isOwner;
  late bool hasMore = true;

  @override
  void onInit() {
    item = Get.arguments;
    title.value = item!.title!;
    if (Get.parameters.keys.isNotEmpty) {
      mediaId = int.parse(Get.parameters['mediaId']!);
      heroTag = Get.parameters['heroTag']!;
      isOwner = Get.parameters['isOwner']!;
    }
    super.onInit();
  }

  Future<dynamic> queryUserFavFolderDetail({type = 'init'}) async {
    if (type == 'onLoad' && !hasMore) {
      loadingText.value = '没有更多了';
      return;
    }
    isLoadingMore = true;
    var res = await UserHttp.userFavFolderDetail(
      pn: currentPage,
      ps: 20,
      mediaId: mediaId!,
    );
    if (res['status']) {
      favInfo.value = res['data'].info;
      hasMore = res['data'].hasMore;
      if (currentPage == 1 && type == 'init') {
        favList.value = res['data'].medias;
        mediaCount.value = res['data'].info['media_count'];
      } else if (type == 'onLoad') {
        favList.addAll(res['data'].medias);
      }
      if (!hasMore) {
        loadingText.value = '没有更多了';
      }
      currentPage += 1;
    }
    isLoadingMore = false;
    return res;
  }

  onCancelFav(int id) async {
    var result = await VideoHttp.favVideo(
        aid: id, addIds: '', delIds: mediaId.toString());
    if (result['status']) {
      List dataList = favList;
      for (var i in dataList) {
        if (i.id == id) {
          dataList.remove(i);
          break;
        }
      }
      SmartDialog.showToast('取消收藏');
    }
  }

  onLoad() {
    queryUserFavFolderDetail(type: 'onLoad');
  }

  onDelFavFolder() async {
    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('确定删除这个收藏夹吗？'),
          actions: [
            TextButton(
              onPressed: () async {
                SmartDialog.dismiss();
              },
              child: Text(
                '点错了',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                var res = await UserHttp.delFavFolder(mediaIds: mediaId!);
                SmartDialog.dismiss();
                SmartDialog.showToast(res['status'] ? '操作成功' : res['msg']);
                if (res['status']) {
                  FavController favController = Get.find<FavController>();
                  await favController.removeFavFolder(mediaIds: mediaId!);
                  Get.back();
                }
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
  }

  onEditFavFolder() async {
    var res = await Get.toNamed(
      '/favEdit',
      arguments: {
        'mediaId': mediaId.toString(),
        'title': item!.title,
        'intro': item!.intro,
        'cover': item!.cover,
        'privacy': [22, 0].contains(item!.attr) ? 0 : 1,
      },
    );
    if (res != null) {
      title.value = res['title'];
    }
  }

  Future toViewPlayAll() async {
    final FavDetailItemData firstItem = favList.first;
    final String heroTag = Utils.makeHeroTag(firstItem.bvid);
    Get.toNamed(
      '/video?bvid=${firstItem.bvid}&cid=${firstItem.cid}',
      arguments: {
        'videoItem': firstItem,
        'heroTag': heroTag,
        'sourceType': 'fav',
        'mediaId': favInfo['id'],
        'oid': firstItem.id,
        'favTitle': favInfo['title'],
        'favInfo': favInfo,
        'count': favInfo['media_count'],
      },
    );
  }

  // 查看无效视频信息
  Future toViewInvalidVideo(FavDetailItemData item) async {
    SmartDialog.showLoading(msg: '加载中...');
    var res = await CommonHttp.fixVideoPicAndTitle(aid: item.id!);
    SmartDialog.dismiss();
    if (res['status']) {
      showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        builder: (context) {
          return InvalidVideoCard(videoInfo: res['data']);
        },
      );
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }
}
