import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/setting/index.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final SettingController _settingController = Get.put(SettingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Column(
        children: [
          Obx(
            () => Visibility(
              visible: _settingController.userLogin.value,
              child: ListTile(
                onTap: () => _settingController.loginOut(),
                dense: false,
                title: const Text('退出登录'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
