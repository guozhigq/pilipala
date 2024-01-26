import 'package:flutter/cupertino.dart';
import 'storage.dart';
class Grid {
  static double maxRowWidth = GStrorage.setting.get(SettingBoxKey.maxRowWidth, defaultValue: 240.0) as double;

  static double calculateActualWidth(BuildContext context, double maxCrossAxisExtent, double crossAxisSpacing) {
    double screenWidth = MediaQuery.of(context).size.width;
    int columnCount = ((screenWidth - crossAxisSpacing) / (maxCrossAxisExtent + crossAxisSpacing)).ceil();
    double columnWidth = (screenWidth - crossAxisSpacing) ~/ columnCount - crossAxisSpacing;
    return columnWidth;
  }
}
