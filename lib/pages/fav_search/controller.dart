import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/user/fav_detail.dart';

import '../../http/video.dart';

class FavSearchController extends GetxController {
  final ScrollController scrollController = ScrollController();
  Rx<TextEditingController> controller = TextEditingController().obs;
  final FocusNode searchFocusNode = FocusNode();
  RxString searchKeyWord = ''.obs; // 搜索词
  String hintText = '请输入已收藏视频名称'; // 默认
  RxBool loadingStatus = false.obs; // 加载状态
  RxString loadingText = '加载中...'.obs; // 加载提示
  bool hasMore = false;
  late int searchType;
  late int mediaId;

  int currentPage = 1; // 当前页
  int count = 0; // 总数
  RxList<FavDetailItemData> favList = <FavDetailItemData>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchType = int.parse(Get.parameters['searchType']!);
    mediaId = int.parse(Get.parameters['mediaId']!);
  }

  // 清空搜索
  void onClear() {
    if (searchKeyWord.value.isNotEmpty && controller.value.text != '') {
      controller.value.clear();
      searchKeyWord.value = '';
    } else {
      Get.back();
    }
  }

  void onChange(value) {
    searchKeyWord.value = value;
  }

  //  提交搜索内容
  void submit() {
    loadingStatus.value = true;
    currentPage = 1;
    searchFav();
  }

  // 搜索收藏夹视频
  Future searchFav({type = 'init'}) async {
    var res = await await UserHttp.userFavFolderDetail(
      pn: currentPage,
      ps: 20,
      mediaId: mediaId,
      keyword: searchKeyWord.value,
      type: searchType,
    );
    if (res['status']) {
      if (currentPage == 1 && type == 'init') {
        favList.value = res['data'].medias;
      } else if (type == 'onLoad') {
        favList.addAll(res['data'].medias);
      }
      hasMore = res['data'].hasMore;
    }
    currentPage += 1;
    loadingStatus.value = false;
  }

  onLoad() {
    if (!hasMore) return;
    searchFav(type: 'onLoad');
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
}
