import 'package:get/get.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/models/common/search_type.dart';

class SearchResultController extends GetxController {
  String? keyword;
  int tabIndex = 0;
  RxList searchTabs = [].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.parameters.keys.isNotEmpty) {
      keyword = Get.parameters['keyword'];
    }
    searchTabs.value = SearchType.values
        .map((type) => {'label': type.label, 'id': type.type})
        .toList();
    querySearchCount();
  }

  Future querySearchCount() async {
    var result = await SearchHttp.searchCount(keyword: keyword!);
    if (result['status']) {
      for (var i in searchTabs) {
        final count = result['data'].topTList[i['id']];
        i['count'] = count > 99 ? '99+' : count.toString();
      }
      searchTabs.refresh();
    }
    return result;
  }
}
