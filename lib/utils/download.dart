import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';

class DownloadUtils {
  // 获取存储权限
  static requestStoragePer() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.photos,
    ].request();
    statuses[Permission.storage].toString();
  }

  static Future<bool> downloadImg(String imgUrl,
      {String imgType = 'cover'}) async {
    try {
      await requestStoragePer();
      SmartDialog.showLoading(msg: '保存中');
      var response = await Dio()
          .get(imgUrl, options: Options(responseType: ResponseType.bytes));
      String picName =
          "plpl_${imgType}_${DateTime.now().toString().split('-').join()}";
      final SaveResult result = await SaverGallery.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: picName,
        // 保存到 PiliPala文件夹
        androidRelativePath: "Pictures/PiliPala",
        androidExistNotSave: false,
      );
      SmartDialog.dismiss();
      if (result.isSuccess) {
        await SmartDialog.showToast('「$picName」已保存 ');
      }
      return true;
    } catch (err) {
      SmartDialog.dismiss();
      SmartDialog.showToast(err.toString());
      return true;
    }
  }
}
