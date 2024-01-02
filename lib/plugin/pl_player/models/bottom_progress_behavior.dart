// ignore: camel_case_types
enum BtmProgresBehavior {
  alwaysShow,
  alwaysHide,
  onlyShowFullScreen,
  onlyHideFullScreen,
}

extension BtmProgresBehaviorDesc on BtmProgresBehavior {
  String get description => ['始终展示', '始终隐藏', '仅全屏时展示', '仅全屏时隐藏'][index];
}

extension BtmProgresBehaviorCode on BtmProgresBehavior {
  static final List<int> _codeList = [0, 1, 2, 3];
  int get code => _codeList[index];

  static BtmProgresBehavior? fromCode(int code) {
    final index = _codeList.indexOf(code);
    if (index != -1) {
      return BtmProgresBehavior.values[index];
    }
    return null;
  }
}
