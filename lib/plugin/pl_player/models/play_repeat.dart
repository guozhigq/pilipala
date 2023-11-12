enum PlayRepeat {
  pause,
  listOrder,
  singleCycle,
  listCycle,
}

extension PlayRepeatExtension on PlayRepeat {
  static final List<String> _descList = [
    '播完暂停',
    '顺序播放',
    '单个循环',
    '列表循环',
  ];
  get description => _descList[index];

  static final List<double> _valueList = [
    1,
    2,
    3,
    4,
  ];
  get value => _valueList[index];
  get defaultValue => _valueList[1];
}
