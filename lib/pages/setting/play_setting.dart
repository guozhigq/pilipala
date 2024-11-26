import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/models/video/play/ao_output.dart';
import 'package:pilipala/models/video/play/quality.dart';
import 'package:pilipala/pages/setting/widgets/select_dialog.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import 'package:pilipala/services/service_locator.dart';
import 'package:pilipala/utils/global_data_cache.dart';
import 'package:pilipala/utils/storage.dart';

import '../../models/live/quality.dart';
import 'widgets/switch_item.dart';

class PlaySetting extends StatefulWidget {
  const PlaySetting({super.key});

  @override
  State<PlaySetting> createState() => _PlaySettingState();
}

class _PlaySettingState extends State<PlaySetting> {
  Box setting = GStorage.setting;
  late dynamic defaultVideoQa;
  late dynamic defaultLiveQa;
  late dynamic defaultAudioQa;
  late dynamic defaultDecode;
  late int defaultFullScreenMode;
  late int defaultBtmProgressBehavior;
  late String defaultAoOutput;
  late String hardwareDecodeFormat;

  @override
  void initState() {
    super.initState();
    defaultVideoQa = setting.get(SettingBoxKey.defaultVideoQa,
        defaultValue: VideoQuality.values.last.code);
    defaultLiveQa = setting.get(SettingBoxKey.defaultLiveQa,
        defaultValue: LiveQuality.values.last.code);
    defaultAudioQa = setting.get(SettingBoxKey.defaultAudioQa,
        defaultValue: AudioQuality.values.last.code);
    defaultDecode = setting.get(SettingBoxKey.defaultDecode,
        defaultValue: VideoDecodeFormats.values.last.code);
    defaultFullScreenMode = setting.get(SettingBoxKey.fullScreenMode,
        defaultValue: FullScreenMode.values.first.code);
    defaultBtmProgressBehavior = setting.get(SettingBoxKey.btmProgressBehavior,
        defaultValue: BtmProgresBehavior.values.first.code);
    defaultAoOutput =
        setting.get(SettingBoxKey.defaultAoOutput, defaultValue: '0');
    hardwareDecodeFormat = setting.get(SettingBoxKey.hardwareDecodeFormat,
        defaultValue: Platform.isAndroid ? 'auto-safe' : 'auto');
  }

  @override
  void dispose() {
    super.dispose();

    // 重新验证媒体通知后台播放设置
    videoPlayerServiceHandler.revalidateSetting();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.titleMedium!;
    TextStyle subTitleStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(color: Theme.of(context).colorScheme.outline);
    return Scaffold(
      appBar: AppBar(title: const Text('播放设置')),
      body: ListView(
        children: [
          ListTile(
            dense: false,
            onTap: () => Get.toNamed('/playSpeedSet'),
            title: Text('倍速设置', style: titleStyle),
            subtitle: Text('设置视频播放速度', style: subTitleStyle),
          ),
          ListTile(
            dense: false,
            onTap: () => Get.toNamed('/playerGestureSet'),
            title: Text('手势设置', style: titleStyle),
            subtitle: Text('设置播放器手势', style: subTitleStyle),
          ),
          const SetSwitchItem(
            title: '开启1080P',
            subTitle: '免登录查看1080P视频',
            setKey: SettingBoxKey.p1080,
            defaultVal: true,
          ),
          const SetSwitchItem(
            title: 'CDN优化',
            subTitle: '使用优质CDN线路',
            setKey: SettingBoxKey.enableCDN,
            defaultVal: false,
          ),
          const SetSwitchItem(
            title: '自动播放',
            subTitle: '进入详情页自动播放',
            setKey: SettingBoxKey.autoPlayEnable,
            defaultVal: true,
          ),
          const SetSwitchItem(
            title: '后台播放',
            subTitle: '进入后台时继续播放',
            setKey: SettingBoxKey.enableBackgroundPlay,
            defaultVal: false,
          ),
          if (Platform.isAndroid)
            const SetSwitchItem(
              title: '自动PiP播放',
              subTitle: '进入后台时画中画播放',
              setKey: SettingBoxKey.autoPiP,
              defaultVal: false,
            ),
          const SetSwitchItem(
            title: '自动全屏',
            subTitle: '视频开始播放时进入全屏',
            setKey: SettingBoxKey.enableAutoEnter,
            defaultVal: false,
          ),
          const SetSwitchItem(
            title: '自动退出',
            subTitle: '视频结束播放时退出全屏',
            setKey: SettingBoxKey.enableAutoExit,
            defaultVal: false,
          ),
          const SetSwitchItem(
            title: '开启硬解',
            subTitle: '以较低功耗播放视频',
            setKey: SettingBoxKey.enableHA,
            defaultVal: false,
          ),
          const SetSwitchItem(
            title: '观看人数',
            subTitle: '展示同时在看人数',
            setKey: SettingBoxKey.enableOnlineTotal,
            defaultVal: false,
          ),
          const SetSwitchItem(
            title: '亮度记忆',
            subTitle: '返回时自动调整视频亮度',
            setKey: SettingBoxKey.enableAutoBrightness,
            defaultVal: false,
          ),
          const SetSwitchItem(
            title: '弹幕开关',
            subTitle: '展示弹幕',
            setKey: SettingBoxKey.enableShowDanmaku,
            defaultVal: false,
          ),
          SetSwitchItem(
              title: '控制栏动画',
              subTitle: '播放器控制栏显示动画效果',
              setKey: SettingBoxKey.enablePlayerControlAnimation,
              defaultVal: true,
              callFn: (bool val) {
                GlobalDataCache.enablePlayerControlAnimation = val;
              }),
          SetSwitchItem(
            title: '港澳台模式',
            setKey: SettingBoxKey.enableGATMode,
            defaultVal: false,
            callFn: (bool val) {
              Request.setBaseUrl(type: val ? 'bangumi' : 'default');
            },
          ),
          ListTile(
            dense: false,
            title: Text('默认视频画质', style: titleStyle),
            subtitle: Text(
              '当前默认画质${VideoQualityCode.fromCode(defaultVideoQa)!.description!}',
              style: subTitleStyle,
            ),
            onTap: () async {
              int? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<int>(
                      title: '默认视频画质',
                      value: defaultVideoQa,
                      values: VideoQuality.values.reversed.map((e) {
                        return {'title': e.description, 'value': e.code};
                      }).toList());
                },
              );
              if (result != null) {
                defaultVideoQa = result;
                setting.put(SettingBoxKey.defaultVideoQa, result);
                setState(() {});
              }
            },
          ),
          ListTile(
            dense: false,
            title: Text('默认直播画质', style: titleStyle),
            subtitle: Text(
              '当前默认画质${LiveQualityCode.fromCode(defaultLiveQa)!.description!}',
              style: subTitleStyle,
            ),
            onTap: () async {
              int? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<int>(
                      title: '默认直播画质',
                      value: defaultLiveQa,
                      values: LiveQuality.values.reversed.map((e) {
                        return {'title': e.description, 'value': e.code};
                      }).toList());
                },
              );
              if (result != null) {
                defaultLiveQa = result;
                setting.put(SettingBoxKey.defaultLiveQa, result);
                setState(() {});
              }
            },
          ),
          ListTile(
            dense: false,
            title: Text('默认音质', style: titleStyle),
            subtitle: Text(
              '当前音质${AudioQualityCode.fromCode(defaultAudioQa)!.description!}',
              style: subTitleStyle,
            ),
            onTap: () async {
              int? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<int>(
                      title: '默认音质',
                      value: defaultAudioQa,
                      values: AudioQuality.values.reversed.map((e) {
                        return {'title': e.description, 'value': e.code};
                      }).toList());
                },
              );
              if (result != null) {
                defaultAudioQa = result;
                setting.put(SettingBoxKey.defaultAudioQa, result);
                setState(() {});
              }
            },
          ),
          ListTile(
            dense: false,
            title: Text('默认解码格式', style: titleStyle),
            subtitle: Text(
              '当前解码格式${VideoDecodeFormatsCode.fromCode(defaultDecode)!.description!}',
              style: subTitleStyle,
            ),
            onTap: () async {
              String? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<String>(
                      title: '默认解码格式',
                      value: defaultDecode,
                      values: VideoDecodeFormats.values.map((e) {
                        return {'title': e.description, 'value': e.code};
                      }).toList());
                },
              );
              if (result != null) {
                defaultDecode = result;
                setting.put(SettingBoxKey.defaultDecode, result);
                setState(() {});
              }
            },
          ),
          ListTile(
            dense: false,
            title: Text('音频输出方式', style: titleStyle),
            subtitle: Text(
              '当前输出方式 ${aoOutputList.firstWhere((element) => element['value'] == defaultAoOutput)['title']}',
              style: subTitleStyle,
            ),
            onTap: () async {
              String? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<String>(
                    title: '音频输出方式',
                    value: defaultAoOutput,
                    values: aoOutputList,
                  );
                },
              );
              if (result != null) {
                defaultAoOutput = result;
                setting.put(SettingBoxKey.defaultAoOutput, result);
                setState(() {});
              }
            },
          ),
          ListTile(
            dense: false,
            title: Text('硬解方式', style: titleStyle),
            subtitle: Text(
              '当前硬解方式(--hwdec)：$hardwareDecodeFormat',
              style: subTitleStyle,
            ),
            onTap: () async {
              String? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<String>(
                      title: '硬解方式',
                      value: hardwareDecodeFormat,
                      values: ['no', 'auto-safe', 'auto', 'yes', 'auto-copy']
                          .map((e) {
                        return {'title': e, 'value': e};
                      }).toList());
                },
              );
              if (result != null) {
                setting.put(SettingBoxKey.hardwareDecodeFormat, result);
                hardwareDecodeFormat = result;
                GlobalDataCache.hardwareDecodeFormat = result;
                setState(() {});
              }
            },
          ),
          ListTile(
            dense: false,
            title: Text('默认全屏方式', style: titleStyle),
            subtitle: Text(
              '当前全屏方式：${FullScreenModeCode.fromCode(defaultFullScreenMode)!.description}',
              style: subTitleStyle,
            ),
            onTap: () async {
              int? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<int>(
                      title: '默认全屏方式',
                      value: defaultFullScreenMode,
                      values: FullScreenMode.values.map((e) {
                        return {'title': e.description, 'value': e.code};
                      }).toList());
                },
              );
              if (result != null) {
                defaultFullScreenMode = result;
                setting.put(SettingBoxKey.fullScreenMode, result);
                setState(() {});
              }
            },
          ),
          ListTile(
            dense: false,
            title: Text('底部进度条展示', style: titleStyle),
            subtitle: Text(
              '当前展示方式：${BtmProgresBehaviorCode.fromCode(defaultBtmProgressBehavior)!.description}',
              style: subTitleStyle,
            ),
            onTap: () async {
              int? result = await showDialog(
                context: context,
                builder: (context) {
                  return SelectDialog<int>(
                      title: '底部进度条展示',
                      value: defaultBtmProgressBehavior,
                      values: BtmProgresBehavior.values.map((e) {
                        return {'title': e.description, 'value': e.code};
                      }).toList());
                },
              );
              if (result != null) {
                defaultBtmProgressBehavior = result;
                setting.put(SettingBoxKey.btmProgressBehavior, result);
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }
}
