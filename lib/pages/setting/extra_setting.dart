import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/common/dynamics_type.dart';
import 'package:pilipala/models/common/reply_sort_type.dart';
import 'package:pilipala/utils/storage.dart';

import 'widgets/switch_item.dart';

class ExtraSetting extends StatefulWidget {
  const ExtraSetting({super.key});

  @override
  State<ExtraSetting> createState() => _ExtraSettingState();
}

class _ExtraSettingState extends State<ExtraSetting> {
  Box setting = GStrorage.setting;
  late dynamic defaultReplySort;
  late dynamic defaultDynamicType;

  @override
  void initState() {
    super.initState();
    // 默认优先显示最新评论
    defaultReplySort =
        setting.get(SettingBoxKey.replySortType, defaultValue: 0);
    // 优先展示全部动态 all
    defaultDynamicType =
        setting.get(SettingBoxKey.defaultDynamicType, defaultValue: 0);
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
          '其他设置',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        children: [
          SetSwitchItem(
            title: '大家都在搜',
            subTitle: '是否展示「大家都在搜」',
            setKey: SettingBoxKey.enableHotKey,
            defaultVal: true,
            callFn: (val) => {SmartDialog.showToast('下次启动时生效')},
          ),
          const SetSwitchItem(
            title: '快速收藏',
            subTitle: '点按收藏至默认，长按选择文件夹',
            setKey: SettingBoxKey.enableQuickFav,
            defaultVal: false,
          ),
          ListTile(
            dense: false,
            title: Text('评论展示', style: titleStyle),
            subtitle: Text(
              '当前优先展示「${ReplySortType.values[defaultReplySort].titles}」',
              style: subTitleStyle,
            ),
            trailing: PopupMenuButton(
              initialValue: defaultReplySort,
              icon: const Icon(Icons.more_vert_outlined, size: 22),
              onSelected: (item) {
                defaultReplySort = item;
                setting.put(SettingBoxKey.replySortType, item);
                setState(() {});
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                for (var i in ReplySortType.values) ...[
                  PopupMenuItem(
                    value: i.index,
                    child: Text(i.titles),
                  ),
                ]
              ],
            ),
          ),
          ListTile(
            dense: false,
            title: Text('动态展示', style: titleStyle),
            subtitle: Text(
              '当前优先展示「${DynamicsType.values[defaultDynamicType].labels}」',
              style: subTitleStyle,
            ),
            trailing: PopupMenuButton(
              initialValue: defaultDynamicType,
              icon: const Icon(Icons.more_vert_outlined, size: 22),
              onSelected: (item) {
                defaultDynamicType = item;
                setting.put(SettingBoxKey.defaultDynamicType, item);
                setState(() {});
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                for (var i in DynamicsType.values) ...[
                  PopupMenuItem(
                    value: i.index,
                    child: Text(i.labels),
                  ),
                ]
              ],
            ),
          ),
          const SetSwitchItem(
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
