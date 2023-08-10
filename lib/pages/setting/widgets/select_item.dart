import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/video/play/quality.dart';
import 'package:pilipala/utils/storage.dart';

class SetSelectItem extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final String? setKey;
  const SetSelectItem({
    this.title,
    this.subTitle,
    this.setKey,
    Key? key,
  }) : super(key: key);

  @override
  State<SetSelectItem> createState() => _SetSelectItemState();
}

class _SetSelectItemState extends State<SetSelectItem> {
  Box Setting = GStrorage.setting;
  late var currentVal;
  late int currentIndex;
  late List menus;
  late List<PopupMenuEntry> popMenuItems;

  @override
  void initState() {
    super.initState();
    late String defaultVal;
    switch (widget.setKey) {
      case 'defaultVideoQa':
        defaultVal = VideoQuality.values.last.description;
        List<VideoQuality> list = menus = VideoQuality.values.reversed.toList();
        currentVal = Setting.get(widget.setKey, defaultValue: defaultVal);
        currentIndex =
            list.firstWhere((i) => i.description == currentVal).index;

        popMenuItems = [
          for (var i in list) ...[
            PopupMenuItem(
              value: i.code,
              child: Text(i.description),
            )
          ]
        ];

        break;
      case 'defaultAudioQa':
        defaultVal = AudioQuality.values.last.description;
        List<AudioQuality> list = menus = AudioQuality.values.reversed.toList();
        currentVal = Setting.get(widget.setKey, defaultValue: defaultVal);
        currentIndex =
            list.firstWhere((i) => i.description == currentVal).index;

        popMenuItems = [
          for (var i in list) ...[
            PopupMenuItem(
              value: i.index,
              child: Text(i.description),
            ),
          ]
        ];
        break;
      case 'defaultDecode':
        defaultVal = VideoDecodeFormats.values[0].description;
        currentVal = Setting.get(widget.setKey, defaultValue: defaultVal);
        List<VideoDecodeFormats> list = menus = VideoDecodeFormats.values;

        currentIndex =
            list.firstWhere((i) => i.description == currentVal).index;

        popMenuItems = [
          for (var i in list) ...[
            PopupMenuItem(
              value: i.index,
              child: Text(i.description),
            ),
          ]
        ];
        break;
      case 'defaultVideoSpeed':
        defaultVal = '1.0';
        currentVal = Setting.get(widget.setKey, defaultValue: defaultVal);

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle subTitleStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(color: Theme.of(context).colorScheme.outline);
    return ListTile(
      onTap: () {},
      dense: false,
      title: Text(widget.title!),
      subtitle: Text(
        '当前${widget.title!} $currentVal',
        style: subTitleStyle,
      ),
      trailing: PopupMenuButton(
        initialValue: currentIndex,
        icon: const Icon(
          Icons.arrow_forward_rounded,
          size: 22,
        ),
        onSelected: (item) {
          currentVal = menus.firstWhere((e) => e.code == item).first;
          setState(() {});
        },
        itemBuilder: (BuildContext context) =>
            <PopupMenuEntry>[...popMenuItems],
      ),
    );
  }
}
