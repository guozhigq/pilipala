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
  late int channelType;

  @override
  void onInit() {
    item = Get.arguments;
    final parameters = Get.parameters;
    if (parameters.isNotEmpty) {
      seasonId = int.tryParse(parameters['seasonId'] ?? '') ?? 0;
      heroTag = parameters['heroTag'] ?? '';
      channelType = int.tryParse(parameters['type'] ?? '') ?? 0;
    }
    super.onInit();
  }

  Future<dynamic> queryUserSeasonList({type = 'init'}) async {
    if (type == 'onLoad' && subList.length >= mediaCount) {
      loadingText.value = '没有更多了';
      return;
    }
    isLoadingMore = true;
    var res = channelType == 21
        ? await UserHttp.userSeasonList(
            seasonId: seasonId,
            ps: 20,
            pn: currentPage,
          )
        : await UserHttp.userResourceList(
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
    queryUserSeasonList(type: 'onLoad');
  }
}
