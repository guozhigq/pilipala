import 'package:get/get.dart';
import 'package:pilipala/http/html.dart';

class HtmlRenderController extends GetxController {
  late String id;
  late Map response;

  @override
  void onInit() {
    super.onInit();
    id = Get.parameters['id']!;
  }

  Future reqHtml() async {
    var res = await HtmlHttp.reqHtml(id);
    response = res;
    return res;
  }
}
