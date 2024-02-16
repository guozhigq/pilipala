import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/utils/storage.dart';

class HiddenSetting extends StatefulWidget {
  const HiddenSetting({super.key});

  @override
  State<HiddenSetting> createState() => _HiddenSettingState();
}

class _HiddenSettingState extends State<HiddenSetting> {

  @override
  void initState() {
    super.initState();
  }

  void test(Object? val) {
    print(val);
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
          '隐藏设置',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              RxInt zero = 0.obs;
              1 / zero.value;
            },
            dense: false,
            title: Text('产生除以0异常', style: titleStyle),
          ),
          ListTile(
            onTap: () {
              List list = [];
              test(list[0]);
            },
            dense: false,
            title: Text('产生数组越界异常', style: titleStyle),
          ),
          ListTile(
            onTap: () {
              RxInt? integer;
              test(integer!.value);
            },
            dense: false,
            title: Text('产生空异常', style: titleStyle),
            subtitle: Text('空安全: 喵喵喵?', style: subTitleStyle),
          ),
          ListTile(
            onTap: () {
              int.parse("壹");
            },
            dense: false,
            title: Text('产生整数解析异常', style: titleStyle),
          ),
          ListTile(
            onTap: () {
              throw Exception("测试异常");
            },
            dense: false,
            title: Text('产生测试异常', style: titleStyle),
          ),
        ],
      ),
    );
  }
}
