import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/common/theme_type.dart';
import 'package:pilipala/utils/storage.dart';

import 'controller.dart';
import 'widgets/switch_item.dart';

class StyleSetting extends StatefulWidget {
  const StyleSetting({super.key});

  @override
  State<StyleSetting> createState() => _StyleSettingState();
}

class _StyleSettingState extends State<StyleSetting> {
  final SettingController settingController = Get.put(SettingController());
  Box setting = GStrorage.setting;
  late int picQuality;
  late ThemeType _tempThemeValue;

  @override
  void initState() {
    super.initState();
    picQuality = setting.get(SettingBoxKey.defaultPicQa, defaultValue: 10);
    _tempThemeValue = settingController.themeType.value;
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
          '外观设置',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        children: [
          Obx(
            () => ListTile(
              enableFeedback: true,
              onTap: () => settingController.onOpenFeedBack(),
              title: const Text('震动反馈'),
              subtitle: Text('请确定手机设置中已开启震动反馈', style: subTitleStyle),
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
                    value: settingController.feedBackEnable.value,
                    onChanged: (value) => settingController.onOpenFeedBack()),
              ),
            ),
          ),
          const SetSwitchItem(
            title: 'iOS路由切换',
            subTitle: 'iOS路由切换样式，需重启',
            setKey: SettingBoxKey.iosTransition,
            defaultVal: false,
          ),
          ListTile(
            dense: false,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, StateSetter setState) {
                      final SettingController settingController =
                          Get.put(SettingController());
                      return AlertDialog(
                        title: const Text('图片质量'),
                        contentPadding: const EdgeInsets.only(
                            top: 20, left: 8, right: 8, bottom: 8),
                        content: SizedBox(
                          height: 40,
                          child: Slider(
                            value: picQuality.toDouble(),
                            min: 10,
                            max: 100,
                            divisions: 9,
                            label: '$picQuality%',
                            onChanged: (double val) {
                              picQuality = val.toInt();
                              setState(() {});
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Get.back(),
                              child: Text('取消',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline))),
                          TextButton(
                            onPressed: () {
                              setting.put(
                                  SettingBoxKey.defaultPicQa, picQuality);
                              Get.back();
                              settingController.picQuality.value = picQuality;
                            },
                            child: const Text('确定'),
                          )
                        ],
                      );
                    },
                  );
                },
              );
            },
            title: Text('图片质量', style: titleStyle),
            subtitle: Text('选择合适的图片清晰度，上限100%', style: subTitleStyle),
            trailing: Obx(
              () => Text(
                '${settingController.picQuality.value}%',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          ListTile(
            dense: false,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('主题模式'),
                    contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                    content: StatefulBuilder(
                        builder: (context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i in ThemeType.values) ...[
                            RadioListTile(
                              value: i,
                              title: Text(i.description, style: titleStyle),
                              groupValue: _tempThemeValue,
                              onChanged: (ThemeType? value) {
                                setState(() {
                                  _tempThemeValue = i;
                                });
                              },
                            ),
                          ]
                        ],
                      );
                    }),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            '取消',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.outline),
                          )),
                      TextButton(
                          onPressed: () {
                            settingController.themeType.value = _tempThemeValue;
                            setting.put(
                                SettingBoxKey.themeMode, _tempThemeValue.code);
                            Get.forceAppUpdate();
                            Get.back();
                          },
                          child: const Text('确定'))
                    ],
                  );
                },
              );
            },
            title: Text('主题模式', style: titleStyle),
            subtitle: Obx(() => Text(
                '当前模式：${settingController.themeType.value.description}',
                style: subTitleStyle)),
            trailing: const Icon(Icons.arrow_right_alt_outlined),
          ),
          ListTile(
            dense: false,
            onTap: () => Get.toNamed('/colorSetting'),
            title: Text('应用主题', style: titleStyle),
          ),
          ListTile(
            dense: false,
            onTap: () => Get.toNamed('/fontSizeSetting'),
            title: Text('字体大小', style: titleStyle),
          )
        ],
      ),
    );
  }
}
