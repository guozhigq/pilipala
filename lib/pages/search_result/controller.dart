import 'package:get/get.dart';

class SearchResultController extends GetxController {
  String? keyword;
  int tabIndex = 0;

  @override
  void onInit() {
    super.onInit();
    if (Get.parameters.keys.isNotEmpty) {
      keyword = Get.parameters['keyword'];
    }
  }
}
