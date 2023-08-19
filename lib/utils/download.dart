import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadUtils {
  // 获取存储全县
  static requestStoragePer() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.photos,
    ].request();
    statuses[Permission.storage].toString();
  }

  static Future<bool> downloadImg(String imgUrl) async {
    await requestStoragePer();
    SmartDialog.showLoading(msg: '保存中');
    var response = await Dio()
        .get(imgUrl, options: Options(responseType: ResponseType.bytes));
    String picName =
        "plpl_cover_${DateTime.now().toString().split('-').join()}.png";
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 100,
      name: picName,
    );
    SmartDialog.dismiss();
    if (result != null) {
      if (result['isSuccess']) {
        // ignore: avoid_print
        await SmartDialog.showToast('「$picName」已保存 ');
      }
    }
    return true;
  }
}
