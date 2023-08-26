enum PlaySpeed {
  pointTwoFive,
  pointFive,
  pointSevenFive,

  one,
  onePointTwoFive,
  onePointFive,
  onePointSevenFive,

  two,
  twoPointTwoFive,
  twoPointFive,
  twoPointSevenFive,

  twhree,
  threePointTwoFive,
  threePointFive,
  threePointSevenFive,

  four,
}

extension PlaySpeedExtension on PlaySpeed {
  static final List<String> _descList = [
    '0.25倍',
    '0.5倍',
    '0.75倍',
    '正常速度',
    '1.25倍',
    '1.5倍',
    '2.0倍',
    '2.25倍',
    '2.5倍',
    '2.75倍',
    '3.0倍',
    '3.25倍',
    '3.5倍',
    '3.75倍',
    '4.0倍'
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
    2.25,
    2.5,
    2.75,
    3.0,
    3.25,
    3.5,
    3.75,
    4.0,
  ];
  get value => _valueList[index];
  get defaultValue => _valueList[3];
}
