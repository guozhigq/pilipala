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
  static Box localCache = GStrorage.localCache;
  late dynamic defaultReplySort;
  late dynamic defaultDynamicType;
  late dynamic enableSystemProxy;
  late String defaultSystemProxyHost;
  late String defaultSystemProxyPort;

  @override
  void initState() {
    super.initState();
    // 默认优先显示最新评论
    defaultReplySort =
        setting.get(SettingBoxKey.replySortType, defaultValue: 0);
    // 优先展示全部动态 all
    defaultDynamicType =
        setting.get(SettingBoxKey.defaultDynamicType, defaultValue: 0);
    enableSystemProxy =
        setting.get(SettingBoxKey.enableSystemProxy, defaultValue: false);
    defaultSystemProxyHost =
        localCache.get(LocalCacheKey.systemProxyHost, defaultValue: '');
    defaultSystemProxyPort =
        localCache.get(LocalCacheKey.systemProxyPort, defaultValue: '');
  }

  // 设置代理
  void twoFADialog() {
    var systemProxyHost = '';
    var systemProxyPort = '';

    SmartDialog.show(
      useSystem: true,
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('设置代理'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              TextField(
                decoration: InputDecoration(
                  isDense: true,
                  labelText: defaultSystemProxyHost != ''
                      ? defaultSystemProxyHost
                      : '请输入Host，使用 . 分割',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  hintText: defaultSystemProxyHost,
                ),
                onChanged: (e) {
                  systemProxyHost = e;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: defaultSystemProxyPort != ''
                      ? defaultSystemProxyPort
                      : '请输入Port',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  hintText: defaultSystemProxyPort,
                ),
                onChanged: (e) {
                  systemProxyPort = e;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                SmartDialog.dismiss();
              },
              child: Text(
                '取消',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                localCache.put(LocalCacheKey.systemProxyHost, systemProxyHost);
                localCache.put(LocalCacheKey.systemProxyPort, systemProxyPort);
                SmartDialog.dismiss();
                // Request.dio;
              },
              child: const Text('确认'),
            )
          ],
        );
      },
    );
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
            title: '搜索默认词',
            subTitle: '是否展示搜索框默认词',
            setKey: SettingBoxKey.enableSearchWord,
            defaultVal: true,
          ),
          const SetSwitchItem(
            title: '推荐动态',
            subTitle: '是否在推荐内容中展示动态',
            setKey: SettingBoxKey.enableRcmdDynamic,
            defaultVal: true,
          ),
          const SetSwitchItem(
            title: '快速收藏',
            subTitle: '点按收藏至默认，长按选择文件夹',
            setKey: SettingBoxKey.enableQuickFav,
            defaultVal: false,
          ),
          const SetSwitchItem(
            title: '评论区搜索关键词',
            subTitle: '展示评论区搜索关键词',
            setKey: SettingBoxKey.enableWordRe,
            defaultVal: false,
          ),
          const SetSwitchItem(
            title: '首页推荐刷新',
            subTitle: '下拉刷新时保留上次内容',
            setKey: SettingBoxKey.enableSaveLastData,
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
          ListTile(
            enableFeedback: true,
            onTap: () => twoFADialog(),
            title: Text('设置代理', style: titleStyle),
            subtitle: Text('设置代理 host:port', style: subTitleStyle),
            trailing: Transform.scale(
              scale: 0.8,
              child: Switch(
                thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                    (Set<MaterialState> states) {
                  if (states.isNotEmpty &&
                      states.first == MaterialState.selected) {
                    return const Icon(Icons.done);
                  }
                  return null; // All other states will use the default thumbIcon.
                }),
                value: enableSystemProxy,
                onChanged: (val) {
                  setting.put(
                      SettingBoxKey.enableSystemProxy, !enableSystemProxy);
                  setState(() {
                    enableSystemProxy = !enableSystemProxy;
                  });
                },
              ),
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
