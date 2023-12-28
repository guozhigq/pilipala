import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/utils/storage.dart';

Box setting = GStrorage.setting;

class CustomToast extends StatelessWidget {
  final String msg;
  const CustomToast({Key? key, required this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double toastOpacity =
        setting.get(SettingBoxKey.defaultToastOp, defaultValue: 0.8);
    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 30),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer
            .withOpacity(toastOpacity),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        msg,
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
