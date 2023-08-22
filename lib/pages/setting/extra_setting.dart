import 'package:flutter/material.dart';
import 'package:pilipala/utils/storage.dart';

import 'widgets/switch_item.dart';

class ExtraSetting extends StatefulWidget {
  const ExtraSetting({super.key});

  @override
  State<ExtraSetting> createState() => _ExtraSettingState();
}

class _ExtraSettingState extends State<ExtraSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          '其他设置',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        children: const [
          SetSwitchItem(
            title: '检查更新',
            subTitle: '每次启动时检查是否需要更新',
            setKey: SettingBoxKey.autoUpdate,
            defaultVal: false,
          ),
        ],
      ),
    );
  }
}
