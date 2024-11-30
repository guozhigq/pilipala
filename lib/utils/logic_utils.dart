class LogicUtils {
  // 收藏夹是否公开
  static bool isPublic(int attr) {
    return (attr & 1) == 0;
  }
}
