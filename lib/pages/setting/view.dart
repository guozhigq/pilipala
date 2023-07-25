import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/setting/index.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingController settingController = Get.put(SettingController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Column(
        children: [
          Obx(
            () => Visibility(
              visible: settingController.userLogin.value,
              child: ListTile(
                onTap: () => settingController.loginOut(),
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
