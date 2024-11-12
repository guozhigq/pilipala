import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/utils/global_data_cache.dart';

import '../../../models/common/gesture_mode.dart';
import '../../../utils/storage.dart';
import '../widgets/select_dialog.dart';
import '../widgets/switch_item.dart';

class PlayGesturePage extends StatefulWidget {
  const PlayGesturePage({super.key});

  @override
  State<PlayGesturePage> createState() => _PlayGesturePageState();
}

class _PlayGesturePageState extends State<PlayGesturePage> {
  Box setting = GStorage.setting;
  late int fullScreenGestureMode;

  @override
  void initState() {
    super.initState();
    fullScreenGestureMode = setting.get(SettingBoxKey.fullScreenGestureMode,
        defaultValue: FullScreenGestureMode.fromBottomtoTop.index);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.titleMedium!;
    TextStyle subTitleStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(color: Theme.of(context).colorScheme.outline);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          '手势设置',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            dense: false,
            title: Text('全屏手势', style: titleStyle),
            subtitle: Text(
              '通过手势快速进入全屏',
              style: subTitleStyle,
            ),
            onTap: () async {
              String? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<String>(
                      title: '全屏手势',
                      value: FullScreenGestureMode
                          .values[fullScreenGestureMode].values,
                      values: FullScreenGestureMode.values.map((e) {
                        return {'title': e.labels, 'value': e.values};
                      }).toList());
                },
              );
              if (result != null) {
                GlobalDataCache().fullScreenGestureMode = FullScreenGestureMode
                    .values
                    .firstWhere((element) => element.values == result);
                fullScreenGestureMode =
                    GlobalDataCache().fullScreenGestureMode.index;
                setting.put(
                    SettingBoxKey.fullScreenGestureMode, fullScreenGestureMode);
                SmartDialog.showToast('设置成功');
                setState(() {});
              }
            },
          ),
          const SetSwitchItem(
            title: '双击快退/快进',
            subTitle: '左侧双击快退，右侧双击快进',
            setKey: SettingBoxKey.enableQuickDouble,
            defaultVal: true,
          ),
        ],
      ),
    );
  }
}
