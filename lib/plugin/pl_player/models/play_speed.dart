enum PlaySpeed {
  pointTwoFive,
  pointFive,
  pointSevenFive,

  one,
  onePointTwoFive,
  onePointFive,
  onePointSevenFive,

  two,
}

extension PlaySpeedExtension on PlaySpeed {
  static final List<String> _descList = [
    '0.25',
    '0.5',
    '0.75',
    '正常',
    '1.25',
    '1.5',
    '1.75',
    '2.0',
  ];
  get description => _descList[index];

  static final List<double> _valueList = [
    0.25,
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    1.75,
    2.0,
  ];
  get value => _valueList[index];
  get defaultValue => _valueList[3];
}
