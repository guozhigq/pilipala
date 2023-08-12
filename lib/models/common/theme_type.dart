enum ThemeType {
  light,
  dark,
  system,
}

extension ThemeTypeDesc on ThemeType {
  String get description => ['浅色', '深色', '跟随系统'][index];
}

extension ThemeTypeCode on ThemeType {
  int get code => [0, 1, 2][index];
}
