import 'package:get/get.dart';

class SearchResultController extends GetxController {
  String? keyword;
  List tabs = [
    {'label': '综合', 'id': ''},
    {'label': '视频', 'id': ''},
    {'label': '番剧', 'id': ''},
    {'label': '直播', 'id': ''},
    {'label': '专栏', 'id': ''},
    {'label': '用户', 'id': ''}
  ];

  @override
  void onInit() {
    super.onInit();
    if (Get.parameters.keys.isNotEmpty) {
      keyword = Get.parameters['keyword'];
    }
  }
}
