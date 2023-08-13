// 全屏模式
enum FullScreenMode {
  // 根据内容自适应
  auto,
  // 始终竖屏
  vertical,
  // 始终横屏
  horizontal
}

extension FullScreenModeDesc on FullScreenMode {
  String get description => ['自适应', '始终竖屏', '始终横屏'][index];
}

extension FullScreenModeCode on FullScreenMode {
  static final List<int> _codeList = [0, 1, 2];
  int get code => _codeList[index];

  static FullScreenMode? fromCode(int code) {
    final index = _codeList.indexOf(code);
    if (index != -1) {
      return FullScreenMode.values[index];
    }
    return null;
  }
}
