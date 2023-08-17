import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/services.dart';

//横屏
/// 低版本xcode不支持auto_orientation
Future<void> landScape() async {
  if (Platform.isAndroid || Platform.isIOS) {
    await AutoOrientation.landscapeAutoMode(forceSensor: true);
  }
}

//竖屏
Future<void> verticalScreen() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

Future<void> enterFullScreen() async {
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
}

//退出全屏显示
Future<void> exitFullScreen() async {
  late SystemUiMode mode;
  if ((Platform.isAndroid &&
          (await DeviceInfoPlugin().androidInfo).version.sdkInt >= 29) ||
      !Platform.isAndroid) {
    mode = SystemUiMode.edgeToEdge;
  } else {
    mode = SystemUiMode.manual;
  }
  await SystemChrome.setEnabledSystemUIMode(mode,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
}
