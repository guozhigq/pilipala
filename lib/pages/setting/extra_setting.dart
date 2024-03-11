import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/common/dynamics_type.dart';
import 'package:pilipala/models/common/reply_sort_type.dart';
import 'package:pilipala/pages/setting/widgets/select_dialog.dart';
import 'package:pilipala/utils/storage.dart';

import '../home/index.dart';
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
  bool userLogin = false;

  @override
  void initState() {
    super.initState();
    // 默认优先显示最新评论
    defaultReplySort =
        setting.get(SettingBoxKey.replySortType, defaultValue: 0);
    if (defaultReplySort == 2) {
      setting.put(SettingBoxKey.replySortType, 0);
      defaultReplySort = 0;
    }
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
          const SetSwitchItem(
            title: '大家都在搜',
            subTitle: '是否展示「大家都在搜」',
            setKey: SettingBoxKey.enableHotKey,
            defaultVal: true,
          ),
          SetSwitchItem(
            title: '搜索默认词',
            subTitle: '是否展示搜索框默认词',
            setKey: SettingBoxKey.enableSearchWord,
            defaultVal: true,
            callFn: (val) {
              Get.find<HomeController>().defaultSearch.value = '';
            },
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
            title: '启用ai总结',
            subTitle: '视频详情页开启ai总结',
            setKey: SettingBoxKey.enableAi,
            defaultVal: true,
          ),
          ListTile(
            dense: false,
            title: Text('评论展示', style: titleStyle),
            subtitle: Text(
              '当前优先展示「${ReplySortType.values[defaultReplySort].titles}」',
              style: subTitleStyle,
            ),
            onTap: () async {
              int? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<int>(
                      title: '评论展示',
                      value: defaultReplySort,
                      values: ReplySortType.values.map((e) {
                        return {'title': e.titles, 'value': e.index};
                      }).toList());
                },
              );
              if (result != null) {
                defaultReplySort = result;
                setting.put(SettingBoxKey.replySortType, result);
                setState(() {});
              }
            },
          ),
          ListTile(
            dense: false,
            title: Text('动态展示', style: titleStyle),
            subtitle: Text(
              '当前优先展示「${DynamicsType.values[defaultDynamicType].labels}」',
              style: subTitleStyle,
            ),
            onTap: () async {
              int? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<int>(
                      title: '动态展示',
                      value: defaultDynamicType,
                      values: DynamicsType.values.map((e) {
                        return {'title': e.labels, 'value': e.index};
                      }).toList());
                },
              );
              if (result != null) {
                defaultDynamicType = result;
                setting.put(SettingBoxKey.defaultDynamicType, result);
                setState(() {});
              }
            },
          ),
          ListTile(
            enableFeedback: true,
            onTap: () => twoFADialog(),
            title: Text('设置代理', style: titleStyle),
            subtitle: Text('设置代理 host:port', style: subTitleStyle),
            trailing: Transform.scale(
              alignment: Alignment.centerRight,
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
