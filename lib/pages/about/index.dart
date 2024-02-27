import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pilipala/http/index.dart';
import 'package:pilipala/models/github/latest.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/cache_manage.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final AboutController _aboutController = Get.put(AboutController());
  String cacheSize = '';

  @override
  void initState() {
    super.initState();
    // 读取缓存占用
    getCacheSize();
  }

  Future<void> getCacheSize() async {
    final res = await CacheManage().loadApplicationCache();
    setState(() => cacheSize = res);
  }

  @override
  Widget build(BuildContext context) {
    final Color outline = Theme.of(context).colorScheme.outline;
    TextStyle subTitleStyle =
        TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.outline);
    return Scaffold(
      appBar: AppBar(
        title: Text('关于', style: Theme.of(context).textTheme.titleMedium),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo/logo_android_2.png',
              width: 150,
            ),
            Text(
              'PiliPala',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Obx(
              () => Badge(
                isLabelVisible: _aboutController.isLoading.value
                    ? false
                    : _aboutController.isUpdate.value,
                label: const Text('New'),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: FilledButton.tonal(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () => _aboutController.githubRelease(),
                                title: const Text('Github下载'),
                              ),
                              ListTile(
                                onTap: () => _aboutController.panDownload(),
                                title: const Text('网盘下载'),
                              ),
                              ListTile(
                                onTap: () => _aboutController.webSiteUrl(),
                                title: const Text('官网下载'),
                              ),
                              ListTile(
                                onTap: () => _aboutController.qimiao(),
                                title: const Text('奇妙应用'),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).padding.bottom +
                                          20)
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'V${_aboutController.currentVersion.value}',
                      style: subTitleStyle.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ListTile(
            //   onTap: () {},
            //   title: const Text('更新日志'),
            //   trailing: const Icon(
            //     Icons.arrow_forward_ios,
            //     size: 16,
            //   ),
            // ),
            ListTile(
              onTap: () => _aboutController.githubUrl(),
              title: const Text('开源地址'),
              trailing: Text(
                'github.com/guozhigq/pilipala',
                style: subTitleStyle,
              ),
            ),
            ListTile(
              onTap: () => _aboutController.webSiteUrl(),
              title: const Text('访问官网'),
              trailing: Text(
                'https://pilipalanet.mysxl.cn',
                style: subTitleStyle,
              ),
            ),
            ListTile(
              onTap: () => _aboutController.panDownload(),
              title: const Text('网盘下载'),
              trailing: Text(
                '提取码：pili',
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ),
            ListTile(
              onTap: () => _aboutController.feedback(),
              title: const Text('问题反馈'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: outline,
              ),
            ),
            ListTile(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          onTap: () => _aboutController.qqChanel(),
                          title: const Text('QQ群'),
                          trailing: Text(
                            '616150809',
                            style: subTitleStyle,
                          ),
                        ),
                        ListTile(
                          onTap: () => _aboutController.tgChanel(),
                          title: const Text('TG频道'),
                          trailing: Text(
                            'https://t.me/+lm_oOVmF0RJiODk1',
                            style: subTitleStyle,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 20)
                      ],
                    );
                  },
                );
              },
              title: const Text('交流社区'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: outline,
              ),
            ),
            ListTile(
              onTap: () => _aboutController.aPay(),
              title: const Text('赞助'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: outline),
            ),
            ListTile(
              onTap: () => _aboutController.logs(),
              title: const Text('错误日志'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: outline),
            ),
            ListTile(
              onTap: () async {
                var cleanStatus = await CacheManage().clearCacheAll();
                if (cleanStatus) {
                  getCacheSize();
                  SmartDialog.showToast('清除成功');
                }
              },
              title: const Text('清除缓存'),
              subtitle: Text('图片及网络缓存 $cacheSize', style: subTitleStyle),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 20)
          ],
        ),
      ),
    );
  }
}

class AboutController extends GetxController {
  RxString currentVersion = ''.obs;
  RxString remoteVersion = ''.obs;
  late LatestDataModel remoteAppInfo;
  RxBool isUpdate = true.obs;
  RxBool isLoading = true.obs;
  late LatestDataModel data;

  @override
  void onInit() {
    super.onInit();
    // init();
    // 获取当前版本
    getCurrentApp();
    // 获取最新的版本
    getRemoteApp();
  }

  // 获取设备信息
  // Future init() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isAndroid) {
  //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     print(androidInfo.supportedAbis);
  //   } else if (Platform.isIOS) {
  //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //     print(iosInfo);
  //   }
  // }

  // 获取当前版本
  Future getCurrentApp() async {
    var result = await PackageInfo.fromPlatform();
    currentVersion.value = result.version;
  }

  // 获取远程版本
  Future getRemoteApp() async {
    var result = await Request().get(Api.latestApp, extra: {'ua': 'pc'});
    data = LatestDataModel.fromJson(result.data);
    remoteAppInfo = data;
    remoteVersion.value = data.tagName!;
    isUpdate.value =
        Utils.needUpdate(currentVersion.value, remoteVersion.value);
    isLoading.value = false;
  }

  // 跳转下载/本地更新
  Future onUpdate() async {
    Utils.matchVersion(data);
  }

  // 跳转github
  githubUrl() {
    launchUrl(
      Uri.parse('https://github.com/guozhigq/pilipala'),
      mode: LaunchMode.externalApplication,
    );
  }

  githubRelease() {
    launchUrl(
      Uri.parse('https://github.com/guozhigq/pilipala/release'),
      mode: LaunchMode.externalApplication,
    );
  }

  // 从网盘下载
  panDownload() {
    Clipboard.setData(
      const ClipboardData(text: 'pili'),
    );
    SmartDialog.showToast(
      '已复制提取码：pili',
      displayTime: const Duration(milliseconds: 500),
    ).then(
      (value) => launchUrl(
        Uri.parse('https://www.123pan.com/s/9sVqVv-flu0A.html'),
        mode: LaunchMode.externalApplication,
      ),
    );
  }

  // 问题反馈
  feedback() {
    launchUrl(
      Uri.parse('https://github.com/guozhigq/pilipala/issues'),
      // 系统自带浏览器打开
      mode: LaunchMode.externalApplication,
    );
  }

  // qq频道
  qqChanel() {
    Clipboard.setData(
      const ClipboardData(text: '616150809'),
    );
    SmartDialog.showToast('已复制QQ群号');
  }

  // tg频道
  tgChanel() {
    Clipboard.setData(
      const ClipboardData(text: 'https://t.me/+lm_oOVmF0RJiODk1'),
    );
    SmartDialog.showToast(
      '已复制，即将在浏览器打开',
      displayTime: const Duration(milliseconds: 500),
    ).then(
      (value) => launchUrl(
        Uri.parse('https://t.me/+lm_oOVmF0RJiODk1'),
        mode: LaunchMode.externalApplication,
      ),
    );
  }

  aPay() {
    try {
      launchUrl(
        Uri.parse(
            'alipayqr://platformapi/startapp?saId=10000007&qrcode=https://qr.alipay.com/fkx14623ddwl1ping3ddd73'),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print(e);
    }
  }

  // 官网
  webSiteUrl() {
    launchUrl(
      Uri.parse('https://pilipalanet.mysxl.cn'),
      mode: LaunchMode.externalApplication,
    );
  }

  qimiao() {
    launchUrl(
      Uri.parse('https://www.magicalapk.com/home'),
      mode: LaunchMode.externalApplication,
    );
  }

  // 日志
  logs() {
    Get.toNamed('/logs');
  }
}
