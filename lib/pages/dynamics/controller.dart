import 'package:get/get.dart';
import 'package:pilipala/http/dynamics.dart';
import 'package:pilipala/models/dynamics/result.dart';

class DynamicsController extends GetxController {
  int page = 1;
  String? offset = '';
  RxList<DynamicItemModel>? dynamicsList = [DynamicItemModel()].obs;
  RxString dynamicsType = 'all'.obs;
  RxString dynamicsTypeLabel = '全部'.obs;

  Future queryFollowDynamic({type = 'init'}) async {
    var res = await DynamicsHttp.followDynamic(
      page: type == 'init' ? 1 : page,
      type: dynamicsType.value,
      offset: offset,
    );
    if (res['status']) {
      if (type == 'init') {
        dynamicsList!.value = res['data'].items;
      } else {
        dynamicsList!.addAll(res['data'].items);
      }
      offset = res['data'].offset;
      page++;
    }
    return res;
  }

  onSelectType(value, label) {
    dynamicsType.value = value;
    dynamicsTypeLabel.value = label;
    queryFollowDynamic();
  }

  pushDetail(item, floor) {
    switch (item!.type) {
      case 'DYNAMIC_TYPE_FORWARD':
        print('转发的动态');
        Get.toNamed('/dynamicDetail',
            arguments: {'item': item, 'floor': floor});
        break;
      case 'DYNAMIC_TYPE_DRAW':
        Get.toNamed('/dynamicDetail',
            arguments: {'item': item, 'floor': floor});
        break;
      case 'DYNAMIC_TYPE_AV':
        print('视频');
        break;
      case 'DYNAMIC_TYPE_ARTICLE':
        print('文章/专栏');
        break;
      case 'DYNAMIC_TYPE_PGC':
        print('番剧');
        break;
      case 'DYNAMIC_TYPE_WORD':
        print('纯文本');
        Get.toNamed('/dynamicDetail',
            arguments: {'item': item, 'floor': floor});
        break;
    }
  }
}
