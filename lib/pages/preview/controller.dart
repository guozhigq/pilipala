import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

class PreviewController extends GetxController {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  RxInt initialPage = 0.obs;
  RxInt currentPage = 1.obs;
  RxList imgList = [].obs;
  bool storage = true;
  bool videos = true;
  bool photos = true;
  bool visiable = true;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      initialPage.value = Get.arguments['initialPage']!;
      currentPage.value = Get.arguments['initialPage']! + 1;
      imgList.value = Get.arguments['imgList'];
    }
  }

  requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      // Permission.photos
    ].request();

    final info = statuses[Permission.storage].toString();
    // final photosInfo = statuses[Permission.photos].toString();

    print('授权状态：$info');
  }

  // 图片保存
  void onSaveImg() async {
    var response = await Dio().get(imgList[initialPage.value],
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: "pic_vvex${DateTime.now().toString().split('-').join()}");
    if (result != null) {
      if (result['isSuccess']) {
        print('已保存到相册');
      }
    }
  }

  // 图片分享
  void onShareImg() async {
    requestPermission();
    var response = await Dio().get(imgList[initialPage.value],
        options: Options(responseType: ResponseType.bytes));
    final temp = await getTemporaryDirectory();
    String imgName =
        "pic_vvex${DateTime.now().toString().split('-').join()}.jpg";
    var path = '${temp.path}/$imgName';
    File(path).writeAsBytesSync(response.data);
    Share.shareXFiles([XFile(path)], subject: imgList[initialPage.value]);
  }
}
