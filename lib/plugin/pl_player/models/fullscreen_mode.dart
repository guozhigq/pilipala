// 全屏模式
enum FullScreenMode {
  // 根据内容自适应
  auto,
  // 始终竖屏
  vertical,
  // 始终横屏
  horizontal,
  // 屏幕长宽比<1.25或为竖屏视频时竖屏，否则横屏
  ratio,
}

extension FullScreenModeDesc on FullScreenMode {
  String get description => ['按视频方向（默认）', '强制竖屏', '强制横屏', '屏幕长宽比<1.25或为竖屏视频时竖屏，否则横屏'][index];
}

extension FullScreenModeCode on FullScreenMode {
  static final List<int> _codeList = [0, 1, 2, 3];
  int get code => _codeList[index];

  static FullScreenMode? fromCode(int code) {
    final index = _codeList.indexOf(code);
    if (index != -1) {
      return FullScreenMode.values[index];
    }
    return null;
  }
}
