import 'dart:io';

import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:pilipala/utils/storage.dart';

void DisableBatteryOpt() async {
  if (!Platform.isAndroid) {
    return;
  }
  // 本地缓存中读取 是否禁用了电池优化 默认未禁用
  bool isDisableBatteryOptLocal =
      GStorage.localCache.get('isDisableBatteryOptLocal', defaultValue: false);
  if (!isDisableBatteryOptLocal) {
    final isBatteryOptimizationDisabled =
        await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    if (isBatteryOptimizationDisabled == false) {
      final hasDisabled = await DisableBatteryOptimization
          .showDisableBatteryOptimizationSettings();
      // 设置为已禁用
      GStorage.localCache.put('isDisableBatteryOptLocal', hasDisabled == true);
    }
  }

  bool isManufacturerBatteryOptimizationDisabled = GStorage.localCache
      .get('isManufacturerBatteryOptimizationDisabled', defaultValue: false);
  if (!isManufacturerBatteryOptimizationDisabled) {
    final isManBatteryOptimizationDisabled = await DisableBatteryOptimization
        .isManufacturerBatteryOptimizationDisabled;
    if (isManBatteryOptimizationDisabled == false) {
      final hasDisabled = await DisableBatteryOptimization
          .showDisableManufacturerBatteryOptimizationSettings(
        "当前设备可能有额外的电池优化",
        "按照步骤操作以禁用电池优化，以保证应用在后台正常运行",
      );
      // 设置为已禁用
      GStorage.localCache.put(
          'isManufacturerBatteryOptimizationDisabled', hasDisabled == true);
    }
  }
}
