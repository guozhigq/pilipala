import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
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
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      await permissionDialog('提示', '存储权限未授权');
      return false;
    } else {
      return true;
    }
  }

  // 获取相册权限
  static Future<bool> requestPhotoPer() async {
    await Permission.photos.request();
    PermissionStatus status = await Permission.photos.status;
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      await permissionDialog('提示', '相册权限未授权');
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> downloadImg(String imgUrl,
      {String imgType = 'cover'}) async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          if (!await requestStoragePer()) {
            return false;
          }
        } else {
          if (!await requestPhotoPer()) {
            return false;
          }
        }
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
        SmartDialog.showToast('「${'$picName.$imgSuffix'}」已保存 ');
        return true;
      } else {
        await permissionDialog('保存失败', '相册权限未授权');
        return false;
      }
    } catch (err) {
      SmartDialog.dismiss();
      SmartDialog.showToast(err.toString());
      return false;
    }
  }

  static Future permissionDialog(String title, String content,
      {Function? onGranted}) async {
    await SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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
  }
}
