import 'package:get/get.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/pages/searchPanel/index.dart';

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
