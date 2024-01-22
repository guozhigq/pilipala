import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/common/tab_type.dart';
import 'package:pilipala/utils/storage.dart';

class TabbarSetPage extends StatefulWidget {
  const TabbarSetPage({super.key});

  @override
  State<TabbarSetPage> createState() => _TabbarSetPageState();
}

class _TabbarSetPageState extends State<TabbarSetPage> {
  Box settingStorage = GStrorage.setting;
  late List defaultTabs;
  late List<String> tabbarSort;

  @override
  void initState() {
    super.initState();
    defaultTabs = tabsConfig;
    tabbarSort = settingStorage.get(SettingBoxKey.tabbarSort,
        defaultValue: ['live', 'rcmd', 'hot', 'bangumi']);
  }

  void saveEdit() {
    List<String> sortedTabbar = defaultTabs
        .where((i) => tabbarSort.contains((i['type'] as TabType).id))
        .map<String>((i) => (i['type'] as TabType).id)
        .toList();
    if (sortedTabbar.isEmpty) {
      SmartDialog.showToast('请至少设置一项！');
      return;
    }
    settingStorage.put(SettingBoxKey.tabbarSort, sortedTabbar);
    SmartDialog.showToast('保存成功，下次启动时生效');
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final tabsItem = defaultTabs.removeAt(oldIndex);
      defaultTabs.insert(newIndex, tabsItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    final listTiles = [
      for (int i = 0; i < defaultTabs.length; i++) ...[
        CheckboxListTile(
          key: Key(defaultTabs[i]['label']),
          value: tabbarSort.contains((defaultTabs[i]['type'] as TabType).id),
          onChanged: (bool? newValue) {
            String tabTypeId = (defaultTabs[i]['type'] as TabType).id;
            if (!newValue!) {
              tabbarSort.remove(tabTypeId);
            } else {
              tabbarSort.add(tabTypeId);
            }
            setState(() {});
          },
          title: Text(defaultTabs[i]['label']),
          secondary: const Icon(Icons.drag_indicator_rounded),
        )
      ]
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabbar编辑'),
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
