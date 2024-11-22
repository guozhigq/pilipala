import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'storage.dart';

Box<dynamic> setting = GStorage.setting;
void feedBack() {
  // 设置中是否开启
  final bool enable =
      setting.get(SettingBoxKey.feedBackEnable, defaultValue: false) as bool;
  if (enable) {
    HapticFeedback.lightImpact();
  }
}
