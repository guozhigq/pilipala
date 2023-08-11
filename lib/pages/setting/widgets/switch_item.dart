import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/utils/storage.dart';

class SetSwitchItem extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final String? setKey;
  final bool? defaultVal;

  const SetSwitchItem({
    this.title,
    this.subTitle,
    this.setKey,
    this.defaultVal,
    Key? key,
  }) : super(key: key);

  @override
  State<SetSwitchItem> createState() => _SetSwitchItemState();
}

class _SetSwitchItemState extends State<SetSwitchItem> {
  // ignore: non_constant_identifier_names
  Box Setting = GStrorage.setting;
  late bool val;

  @override
  void initState() {
    super.initState();
    val = Setting.get(widget.setKey, defaultValue: widget.defaultVal ?? false);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.titleMedium!;
    TextStyle subTitleStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(color: Theme.of(context).colorScheme.outline);
    return ListTile(
      enableFeedback: true,
      onTap: () {
        Setting.put(widget.setKey, !val);
      },
      title: Text(widget.title!, style: titleStyle),
      subtitle: widget.subTitle != null
          ? Text(widget.subTitle!, style: subTitleStyle)
          : null,
      trailing: Transform.scale(
        scale: 0.8,
        child: Switch(
            thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                (Set<MaterialState> states) {
              if (states.isNotEmpty && states.first == MaterialState.selected) {
                return const Icon(Icons.done);
              }
              return null; // All other states will use the default thumbIcon.
            }),
            value: val,
            onChanged: (value) {
              val = value;
              Setting.put(widget.setKey, value);
              setState(() {});
            }),
      ),
    );
  }
}
