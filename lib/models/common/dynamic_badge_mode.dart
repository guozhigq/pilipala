enum DynamicBadgeMode { hidden, point, number }

extension DynamicBadgeModeDesc on DynamicBadgeMode {
  String get description => ['隐藏', '红点', '数字'][index];
}

extension DynamicBadgeModeCode on DynamicBadgeMode {
  int get code => [0, 1, 2][index];
}
