import 'package:hive/hive.dart';
import 'package:pilipala/utils/storage.dart';
import '../models/common/index.dart';

Box setting = GStrorage.setting;

class GlobalData {
  int imgQuality = 10;
  FullScreenGestureMode fullScreenGestureMode =
      FullScreenGestureMode.values.last;
  bool enablePlayerControlAnimation = true;
  final bool enableMYBar =
      setting.get(SettingBoxKey.enableMYBar, defaultValue: true);

  // 私有构造函数
  GlobalData._();

  // 单例实例
  static final GlobalData _instance = GlobalData._();

  // 获取全局实例
  factory GlobalData() => _instance;
}
