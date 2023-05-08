import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'controller.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final MineController _mineController = Get.put(MineController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.light_mode_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const FaIcon(
              FontAwesomeIcons.sliders,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
        },
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Get.toNamed(
                  '/webview',
                  parameters: {
                    'url':
                        'https://passport.bilibili.com/h5-app/passport/login',
                    'type': 'login',
                    'pageTitle': '登录bilibili',
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    ClipOval(
                      child: Container(
                        width: 75,
                        height: 75,
                        color: Theme.of(context).colorScheme.onInverseSurface,
                        child: Center(
                          child: Image.asset('assets/images/loading.png'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      '点击登录',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  TextStyle style = TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleMedium!.fontSize,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold);
                  return SizedBox(
                    height: constraints.maxWidth / 3 * 0.6,
                    child: GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(0),
                      crossAxisCount: 3,
                      childAspectRatio: 1.67,
                      children: <Widget>[
                        InkWell(
                          onTap: () {},
                          borderRadius: StyleString.mdRadius,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('-', style: style),
                              const SizedBox(height: 8),
                              Text(
                                '动态',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          borderRadius: StyleString.mdRadius,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '50',
                                style: style,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '关注',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          borderRadius: StyleString.mdRadius,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '-',
                                style: style,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '粉丝',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height: constraints.maxWidth / 4 * 0.8,
                    child: GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(0),
                      crossAxisCount: 4,
                      childAspectRatio: 1.25,
                      children: <Widget>[
                        ActionItem(
                          icon: const Icon(FontAwesomeIcons.download),
                          onTap: () => {},
                          text: '离线缓存',
                        ),
                        ActionItem(
                          icon: const Icon(FontAwesomeIcons.clockRotateLeft),
                          onTap: () => {},
                          text: '历史记录',
                        ),
                        ActionItem(
                          icon: const Icon(FontAwesomeIcons.star),
                          onTap: () => {},
                          text: '我的收藏',
                        ),
                        ActionItem(
                          icon: const Icon(FontAwesomeIcons.film),
                          onTap: () => {},
                          text: '稍后再看',
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionItem extends StatelessWidget {
  Icon? icon;
  Function? onTap;
  String? text;

  ActionItem({
    Key? key,
    this.icon,
    this.onTap,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: StyleString.mdRadius,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon!.icon!,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 8),
          Text(
            text!,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
