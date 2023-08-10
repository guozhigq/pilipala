import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/video/play/quality.dart';
import 'package:pilipala/utils/storage.dart';

import 'widgets/switch_item.dart';

class PlaySetting extends StatefulWidget {
  const PlaySetting({super.key});

  @override
  State<PlaySetting> createState() => _PlaySettingState();
}

class _PlaySettingState extends State<PlaySetting> {
  Box setting = GStrorage.setting;
  late dynamic defaultVideoQa;
  late dynamic defaultAudioQa;
  late dynamic defaultDecode;

  @override
  void initState() {
    super.initState();
    defaultVideoQa = setting.get(SettingBoxKey.defaultVideoQa,
        defaultValue: VideoQuality.values.last.code);
    defaultAudioQa = setting.get(SettingBoxKey.defaultAudioQa,
        defaultValue: AudioQuality.values.last.code);
    defaultDecode = setting.get(SettingBoxKey.defaultDecode,
        defaultValue: VideoDecodeFormats.values.last.code);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle subTitleStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(color: Theme.of(context).colorScheme.outline);
    return Scaffold(
      appBar: AppBar(
        title: const Text('播放设置'),
      ),
      body: ListView(
        children: [
          const SetSwitchItem(
            title: '自动播放',
            subTitle: '进入详情页自动播放',
            setKey: SettingBoxKey.autoPlayEnable,
          ),
          const SetSwitchItem(
            title: '开启硬解',
            subTitle: '以较低功耗播放视频',
            setKey: SettingBoxKey.enableHA,
          ),
          ListTile(
            dense: false,
            title: const Text('默认画质'),
            subtitle: Text(
              '当前画质' + VideoQualityCode.fromCode(defaultVideoQa)!.description!,
              style: subTitleStyle,
            ),
            trailing: PopupMenuButton(
              initialValue: defaultVideoQa,
              icon: const Icon(Icons.arrow_forward_rounded, size: 22),
              onSelected: (item) {
                defaultVideoQa = item;
                setting.put(SettingBoxKey.defaultVideoQa, item);
                setState(() {});
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                for (var i in VideoQuality.values.reversed) ...[
                  PopupMenuItem(
                    value: i.code,
                    child: Text(i.description),
                  ),
                ]
              ],
            ),
          ),
          ListTile(
            dense: false,
            title: const Text('默认音质'),
            subtitle: Text(
              '当前音质' + AudioQualityCode.fromCode(defaultAudioQa)!.description!,
              style: subTitleStyle,
            ),
            trailing: PopupMenuButton(
              initialValue: defaultAudioQa,
              icon: const Icon(Icons.arrow_forward_rounded, size: 22),
              onSelected: (item) {
                defaultAudioQa = item;
                setting.put(SettingBoxKey.defaultAudioQa, item);
                setState(() {});
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                for (var i in AudioQuality.values.reversed) ...[
                  PopupMenuItem(
                    value: i.code,
                    child: Text(i.description),
                  ),
                ]
              ],
            ),
          ),
          ListTile(
            dense: false,
            title: const Text('默认解码格式'),
            subtitle: Text(
              '当前解码格式' +
                  VideoDecodeFormatsCode.fromCode(defaultDecode)!.description!,
              style: subTitleStyle,
            ),
            trailing: PopupMenuButton(
              initialValue: defaultDecode,
              icon: const Icon(Icons.arrow_forward_rounded, size: 22),
              onSelected: (item) {
                defaultDecode = item;
                setting.put(SettingBoxKey.defaultDecode, item);
                setState(() {});
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                for (var i in VideoDecodeFormats.values) ...[
                  PopupMenuItem(
                    value: i.code,
                    child: Text(i.description),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
