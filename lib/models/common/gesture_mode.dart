enum FullScreenGestureMode {
  /// 从上滑到下
  fromToptoBottom,

  /// 从下滑到上
  fromBottomtoTop,
}

extension FullScreenGestureModeExtension on FullScreenGestureMode {
  String get values => ['fromToptoBottom', 'fromBottomtoTop'][index];
  String get labels => ['从上往下滑进入全屏', '从下往上滑进入全屏'][index];
}
