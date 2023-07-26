import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/utils/storage.dart';

Box setting = GStrorage.setting;
void feedBack() {
  // 设置中是否开启
  bool enable = setting.get(SettingBoxKey.feedBackEnable, defaultValue: false);
  if (enable) {
    HapticFeedback.lightImpact();
  }
}
