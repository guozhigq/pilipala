enum PlayRepeat {
  pause,
  listOrder,
  singleCycle,
  listCycle,
}

extension PlayRepeatExtension on PlayRepeat {
  static final List<String> _descList = <String>[
    '播完暂停',
    '顺序播放',
    '单个循环',
    '列表循环',
  ];
  String get description => _descList[index];

  static final List<double> _valueList = [
    1,
    2,
    3,
    4,
  ];
  double get value => _valueList[index];
  double get defaultValue => _valueList[1];
}
