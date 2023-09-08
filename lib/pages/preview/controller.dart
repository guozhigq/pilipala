import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class PreviewController extends GetxController {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  RxInt initialPage = 0.obs;
  RxInt currentPage = 1.obs;
  RxList imgList = [].obs;
  bool storage = true;
  bool videos = true;
  bool photos = true;
  String currentImgUrl = '';

  requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      // Permission.photos
    ].request();

    statuses[Permission.storage].toString();
    // final photosInfo = statuses[Permission.photos].toString();
  }

  // 图片分享
  void onShareImg() async {
    SmartDialog.showLoading();
    var response = await Dio().get(imgList[initialPage.value],
        options: Options(responseType: ResponseType.bytes));
    final temp = await getTemporaryDirectory();
    SmartDialog.dismiss();
    String imgName =
        "plpl_pic_${DateTime.now().toString().split('-').join()}.jpg";
    var path = '${temp.path}/$imgName';
    File(path).writeAsBytesSync(response.data);
    Share.shareXFiles([XFile(path)], subject: imgList[initialPage.value]);
  }

  void onChange(int index) {
    initialPage.value = index;
    currentPage.value = index + 1;
    currentImgUrl = imgList[index];
  }
}
