import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/member.dart';
import 'package:pilipala/models/common/rcmd_type.dart';
import 'package:pilipala/pages/setting/widgets/select_dialog.dart';
import 'package:pilipala/utils/storage.dart';

import 'widgets/switch_item.dart';

class RecommendSetting extends StatefulWidget {
  const RecommendSetting({super.key});

  @override
  State<RecommendSetting> createState() => _RecommendSettingState();
}

class _RecommendSettingState extends State<RecommendSetting> {
  Box setting = GStrorage.setting;
  static Box localCache = GStrorage.localCache;
  late dynamic defaultRcmdType;
  Box userInfoCache = GStrorage.userInfo;
  late dynamic userInfo;
  bool userLogin = false;
  late dynamic accessKeyInfo;

  @override
  void initState() {
    super.initState();
    // 首页默认推荐类型
    defaultRcmdType =
        setting.get(SettingBoxKey.defaultRcmdType, defaultValue: 'web');
    userInfo = userInfoCache.get('userInfoCache');
    userLogin = userInfo != null;
    accessKeyInfo = localCache.get(LocalCacheKey.accessKey, defaultValue: null);
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
          '推荐设置',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        children: [
          const SetSwitchItem(
            title: '推荐动态',
            subTitle: '是否在推荐内容中展示动态',
            setKey: SettingBoxKey.enableRcmdDynamic,
            defaultVal: true,
          ),
          const SetSwitchItem(
            title: '首页推荐刷新',
            subTitle: '下拉刷新时保留上次内容',
            setKey: SettingBoxKey.enableSaveLastData,
            defaultVal: false,
          ),
          ListTile(
            dense: false,
            title: Text('首页推荐类型', style: titleStyle),
            subtitle: Text(
              '当前使用「$defaultRcmdType端」推荐',
              style: subTitleStyle,
            ),
            onTap: () async {
              String? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<String>(
                    title: '推荐类型',
                    value: defaultRcmdType,
                    values: RcmdType.values.map((e) {
                      return {'title': e.labels, 'value': e.values};
                    }).toList(),
                  );
                },
              );
              if (result != null) {
                if (result == 'app') {
                  // app端推荐需要access_key
                  if (accessKeyInfo == null) {
                    if (!userLogin) {
                      SmartDialog.showToast('请先登录');
                      return;
                    }
                    // 显示一个确认框，告知用户可能会导致账号被风控
                    SmartDialog.show(
                        animationType: SmartAnimationType.centerFade_otherSlide,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('提示'),
                            content: const Text(
                                '使用app端推荐需获取access_key，有小概率触发风控导致账号退出（在官方app重新登录即可解除），是否继续？'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  result = null;
                                  SmartDialog.dismiss();
                                },
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  SmartDialog.dismiss();
                                  await MemberHttp.cookieToKey();
                                },
                                child: const Text('确定'),
                              ),
                            ],
                          );
                        });
                  }
                }
                if (result != null) {
                  defaultRcmdType = result;
                  setting.put(SettingBoxKey.defaultRcmdType, result);
                  SmartDialog.showToast('下次启动时生效');
                  setState(() {});
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
