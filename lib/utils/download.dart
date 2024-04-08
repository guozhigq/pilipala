import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';

class DownloadUtils {
  // 获取存储权限
  static Future<bool> requestStoragePer() async {
    await Permission.storage.request();
    PermissionStatus status = await Permission.storage.status;
    if (status == PermissionStatus.denied) {
      SmartDialog.show(
        useSystem: true,
        animationType: SmartAnimationType.centerFade_otherSlide,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('提示'),
            content: const Text('存储权限未授权'),
            actions: [
              TextButton(
                onPressed: () async {
                  openAppSettings();
                },
                child: const Text('去授权'),
              )
            ],
          );
        },
      );
      return false;
    } else {
      return true;
    }
  }

  // 获取相册权限
  static Future<bool> requestPhotoPer() async {
    await Permission.photos.request();
    PermissionStatus status = await Permission.photos.status;
    if (status == PermissionStatus.denied) {
      SmartDialog.show(
        useSystem: true,
        animationType: SmartAnimationType.centerFade_otherSlide,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('提示'),
            content: const Text('相册权限未授权'),
            actions: [
              TextButton(
                onPressed: () async {
                  openAppSettings();
                },
                child: const Text('去授权'),
              )
            ],
          );
        },
      );
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> downloadImg(String imgUrl,
      {String imgType = 'cover'}) async {
    try {
      if (!await requestPhotoPer()) {
        return false;
      }
      SmartDialog.showLoading(msg: '保存中');
      var response = await Dio()
          .get(imgUrl, options: Options(responseType: ResponseType.bytes));
      final String imgSuffix = imgUrl.split('.').last;
      String picName =
          "plpl_${imgType}_${DateTime.now().toString().replaceAll(RegExp(r'[- :]'), '').split('.').first}";
      final SaveResult result = await SaverGallery.saveImage(
        Uint8List.fromList(response.data),
        name: '$picName.$imgSuffix',
        // 保存到 PiliPala文件夹
        androidRelativePath: "Pictures/PiliPala",
        androidExistNotSave: false,
      );
      SmartDialog.dismiss();
      if (result.isSuccess) {
        await SmartDialog.showToast('「${'$picName.$imgSuffix'}」已保存 ');
      }
      return true;
    } catch (err) {
      SmartDialog.dismiss();
      SmartDialog.showToast(err.toString());
      return true;
    }
  }
}
