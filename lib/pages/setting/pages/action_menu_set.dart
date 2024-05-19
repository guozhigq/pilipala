import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/common/action_type.dart';
import '../../../utils/storage.dart';

class ActionMenuSetPage extends StatefulWidget {
  const ActionMenuSetPage({super.key});

  @override
  State<ActionMenuSetPage> createState() => _ActionMenuSetPageState();
}

class _ActionMenuSetPageState extends State<ActionMenuSetPage> {
  Box settingStorage = GStrorage.setting;
  late List<String> actionTypeSort;
  late List<Map> allLabels;

  @override
  void initState() {
    super.initState();
    actionTypeSort = settingStorage.get(SettingBoxKey.actionTypeSort,
        defaultValue: ['like', 'coin', 'collect', 'watchLater', 'share']);
    allLabels = actionMenuConfig;
    allLabels.sort((a, b) {
      int indexA = actionTypeSort.indexOf((a['value'] as ActionType).value);
      int indexB = actionTypeSort.indexOf((b['value'] as ActionType).value);
      if (indexA == -1) indexA = actionTypeSort.length;
      if (indexB == -1) indexB = actionTypeSort.length;
      return indexA.compareTo(indexB);
    });
  }

  void saveEdit() {
    List<String> sortedTabbar = allLabels
        .where((i) => actionTypeSort.contains((i['value'] as ActionType).value))
        .map<String>((i) => (i['value'] as ActionType).value)
        .toList();
    settingStorage.put(SettingBoxKey.actionTypeSort, sortedTabbar);
    SmartDialog.showToast('保存成功，下次启动时生效');
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final tabsItem = allLabels.removeAt(oldIndex);
      allLabels.insert(newIndex, tabsItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    final listTiles = [
      for (int i = 0; i < allLabels.length; i++) ...[
        CheckboxListTile(
          key: Key((allLabels[i]['value'] as ActionType).value),
          value: actionTypeSort
              .contains((allLabels[i]['value'] as ActionType).value),
          onChanged: (bool? newValue) {
            String actionTypeId = (allLabels[i]['value'] as ActionType).value;
            if (!newValue!) {
              actionTypeSort.remove(actionTypeId);
            } else {
              actionTypeSort.add(actionTypeId);
            }
            setState(() {});
          },
          title: Row(
            children: [
              allLabels[i]['icon'],
              const SizedBox(width: 8),
              Text(allLabels[i]['label']),
            ],
          ),
          secondary: const Icon(Icons.drag_indicator_rounded),
        )
      ]
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('视频操作菜单'),
        actions: [
          TextButton(onPressed: () => saveEdit(), child: const Text('保存')),
          const SizedBox(width: 12)
        ],
      ),
      body: ReorderableListView(
        onReorder: onReorder,
        physics: const NeverScrollableScrollPhysics(),
        footer: SizedBox(
          height: MediaQuery.of(context).padding.bottom + 30,
        ),
        children: listTiles,
      ),
    );
  }
}
