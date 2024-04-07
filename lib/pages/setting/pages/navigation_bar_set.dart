import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/common/tab_type.dart';
import 'package:pilipala/utils/storage.dart';

import '../../../models/common/nav_bar_config.dart';

class NavigationBarSetPage extends StatefulWidget {
  const NavigationBarSetPage({super.key});

  @override
  State<NavigationBarSetPage> createState() => _NavigationbarSetPageState();
}

class _NavigationbarSetPageState extends State<NavigationBarSetPage> {
  Box settingStorage = GStrorage.setting;
  late List defaultNavTabs;
  late List<int> navBarSort;

  @override
  void initState() {
    super.initState();
    defaultNavTabs = defaultNavigationBars;
    navBarSort = settingStorage
        .get(SettingBoxKey.navBarSort, defaultValue: [0, 1, 2, 3]);
    // 对 tabData 进行排序
    defaultNavTabs.sort((a, b) {
      int indexA = navBarSort.indexOf(a['id']);
      int indexB = navBarSort.indexOf(b['id']);

      // 如果类型在 sortOrder 中不存在，则放在末尾
      if (indexA == -1) indexA = navBarSort.length;
      if (indexB == -1) indexB = navBarSort.length;

      return indexA.compareTo(indexB);
    });
  }

  void saveEdit() {
    List<int> sortedTabbar = defaultNavTabs
        .where((i) => navBarSort.contains(i['id']))
        .map<int>((i) => i['id'])
        .toList();
    settingStorage.put(SettingBoxKey.navBarSort, sortedTabbar);
    SmartDialog.showToast('保存成功，下次启动时生效');
  }

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final tabsItem = defaultNavTabs.removeAt(oldIndex);
      defaultNavTabs.insert(newIndex, tabsItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    final listTiles = [
      for (int i = 0; i < defaultNavTabs.length; i++) ...[
        CheckboxListTile(
          key: Key(defaultNavTabs[i]['label']),
          value: navBarSort.contains(defaultNavTabs[i]['id']),
          onChanged: (bool? newValue) {
            int tabTypeId = defaultNavTabs[i]['id'];
            if (!newValue!) {
              navBarSort.remove(tabTypeId);
            } else {
              navBarSort.add(tabTypeId);
            }
            setState(() {});
          },
          title: Text(defaultNavTabs[i]['label']),
          secondary: const Icon(Icons.drag_indicator_rounded),
          enabled: defaultNavTabs[i]['id'] != 0,
        )
      ]
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navbar编辑'),
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
