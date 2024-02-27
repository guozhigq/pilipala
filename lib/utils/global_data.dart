import '../models/common/index.dart';

class GlobalData {
  int imgQuality = 10;
  FullScreenGestureMode fullScreenGestureMode =
      FullScreenGestureMode.values.last;

  // 私有构造函数
  GlobalData._();

  // 单例实例
  static final GlobalData _instance = GlobalData._();

  // 获取全局实例
  factory GlobalData() => _instance;
}
