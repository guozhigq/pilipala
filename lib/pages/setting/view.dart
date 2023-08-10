import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/setting/index.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle subTitleStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(color: Theme.of(context).colorScheme.outline);
    final SettingController settingController = Get.put(SettingController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Column(
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
          ListTile(
            onTap: () => Get.toNamed('/playSetting'),
            dense: false,
            title: const Text('播放设置'),
          ),
          // ListTile(
          //   onTap: () {},
          //   dense: false,
          //   title: const Text('外观设置'),
          // ),
          // ListTile(
          //   onTap: () {},
          //   dense: false,
          //   title: const Text('其他设置'),
          // ),
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
