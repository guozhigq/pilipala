import 'package:get/get.dart';
import 'package:pilipala/http/user.dart';

import '../../models/user/sub_detail.dart';
import '../../models/user/sub_folder.dart';

class SubDetailController extends GetxController {
  late SubFolderItemData item;

  late int seasonId;
  late String heroTag;
  int currentPage = 1;
  bool isLoadingMore = false;
  Rx<DetailInfo> subInfo = DetailInfo().obs;
  RxList<SubDetailMediaItem> subList = <SubDetailMediaItem>[].obs;
  RxString loadingText = '加载中...'.obs;
  int mediaCount = 0;

  @override
  void onInit() {
    item = Get.arguments;
    if (Get.parameters.keys.isNotEmpty) {
      seasonId = int.parse(Get.parameters['seasonId']!);
      heroTag = Get.parameters['heroTag']!;
    }
    super.onInit();
  }

  Future<dynamic> queryUserSubFolderDetail({type = 'init'}) async {
    if (type == 'onLoad' && subList.length >= mediaCount) {
      loadingText.value = '没有更多了';
      return;
    }
    isLoadingMore = true;
    var res = await UserHttp.userSubFolderDetail(
      seasonId: seasonId,
      ps: 20,
      pn: currentPage,
    );
    if (res['status']) {
      subInfo.value = res['data'].info;
      if (currentPage == 1 && type == 'init') {
        subList.value = res['data'].medias;
        mediaCount = res['data'].info.mediaCount;
      } else if (type == 'onLoad') {
        subList.addAll(res['data'].medias);
      }
      if (subList.length >= mediaCount) {
        loadingText.value = '没有更多了';
      }
    }
    currentPage += 1;
    isLoadingMore = false;
    return res;
  }

  onLoad() {
    queryUserSubFolderDetail(type: 'onLoad');
  }
}
