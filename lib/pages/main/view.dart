import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/models/common/dynamic_badge_mode.dart';
import 'package:pilipala/pages/dynamics/index.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/mine/index.dart';
import 'package:pilipala/pages/rank/index.dart';
import 'package:pilipala/utils/event_bus.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/global_data_cache.dart';
import 'package:pilipala/utils/storage.dart';
import './controller.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  final MainController _mainController = Get.put(MainController());
  late HomeController _homeController;
  RankController? _rankController;
  late DynamicsController _dynamicController;
  late MineController _mineController;

  int? _lastSelectTime; //上次点击时间
  Box setting = GStorage.setting;
  late bool enableMYBar;

  @override
  void initState() {
    super.initState();
    _lastSelectTime = DateTime.now().millisecondsSinceEpoch;
    _mainController.pageController =
        PageController(initialPage: _mainController.selectedIndex);
    enableMYBar = setting.get(SettingBoxKey.enableMYBar, defaultValue: true);
    controllerInit();
  }

  void setIndex(int value) async {
    feedBack();
    _mainController.pageController.jumpToPage(value);
    var currentPage = _mainController.pages[value];
    if (currentPage is HomePage) {
      if (_homeController.flag) {
        // 单击返回顶部 双击并刷新
        if (DateTime.now().millisecondsSinceEpoch - _lastSelectTime! < 500) {
          _homeController.onRefresh();
        } else {
          _homeController.animateToTop();
        }
        _lastSelectTime = DateTime.now().millisecondsSinceEpoch;
      }
      _homeController.flag = true;
    } else {
      _homeController.flag = false;
    }

    if (currentPage is RankPage) {
      if (_rankController!.flag) {
        // 单击返回顶部 双击并刷新
        if (DateTime.now().millisecondsSinceEpoch - _lastSelectTime! < 500) {
          _rankController!.onRefresh();
        } else {
          _rankController!.animateToTop();
        }
        _lastSelectTime = DateTime.now().millisecondsSinceEpoch;
      }
      _rankController!.flag = true;
    } else {
      _rankController?.flag = false;
    }

    if (currentPage is DynamicsPage) {
      if (_dynamicController.flag) {
        // 单击返回顶部 双击并刷新
        if (DateTime.now().millisecondsSinceEpoch - _lastSelectTime! < 500) {
          _dynamicController.onRefresh();
        } else {
          _dynamicController.animateToTop();
        }
        _lastSelectTime = DateTime.now().millisecondsSinceEpoch;
      }
      _dynamicController.flag = true;
      _mainController.clearUnread();
    } else {
      _dynamicController.flag = false;
    }

    if (currentPage is MinePage) {
      _mineController.queryFavFolder();
      _mineController.queryUserInfo();
    }
  }

  void controllerInit() {
    _homeController = Get.put(HomeController());
    _dynamicController = Get.put(DynamicsController());
    _mineController = Get.put(MineController());
    if (_mainController.pagesIds.contains(1)) {
      _rankController = Get.put(RankController());
    }
    if (_mainController.pagesIds.contains(2)) {
      _dynamicController = Get.put(DynamicsController());
    }
  }

  @override
  void dispose() async {
    await GStorage.close();
    EventBus().off(EventName.loginEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Box localCache = GStorage.localCache;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double sheetHeight = MediaQuery.sizeOf(context).height -
        MediaQuery.of(context).padding.top -
        MediaQuery.sizeOf(context).width * 9 / 16;
    GlobalDataCache.sheetHeight = sheetHeight;
    localCache.put('sheetHeight', sheetHeight);
    localCache.put('statusBarHeight', statusBarHeight);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            Get.isDarkMode ? Brightness.light : Brightness.dark,
      ),
    );
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        _mainController.onBackPressed(context);
      },
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            if (_mainController.enableGradientBg)
              Align(
                alignment: Alignment.topLeft,
                child: Opacity(
                  opacity: Theme.of(context).brightness == Brightness.dark
                      ? 0.3
                      : 0.6,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                            Theme.of(context).colorScheme.surface,
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.3),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.1, 0.3, 5]),
                    ),
                  ),
                ),
              ),
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _mainController.pageController,
              onPageChanged: (index) {
                _mainController.selectedIndex = index;
                setState(() {});
              },
              children: _mainController.pages,
            ),
          ],
        ),
        bottomNavigationBar: _mainController.navigationBars.length > 1
            ? StreamBuilder(
                stream: _mainController.hideTabBar
                    ? _mainController.bottomBarStream.stream.distinct()
                    : StreamController<bool>.broadcast().stream,
                initialData: true,
                builder: (context, AsyncSnapshot snapshot) {
                  return AnimatedSlide(
                    curve: Curves.easeInOutCubicEmphasized,
                    duration: const Duration(milliseconds: 500),
                    offset: Offset(0, snapshot.data ? 0 : 1),
                    child: enableMYBar
                        ? Obx(
                            () => NavigationBar(
                              onDestinationSelected: (value) => setIndex(value),
                              selectedIndex: _mainController.selectedIndex,
                              destinations: <Widget>[
                                ..._mainController.navigationBars.map((e) {
                                  return NavigationDestination(
                                    icon: _mainController
                                                .dynamicBadgeType.value ==
                                            DynamicBadgeMode.number
                                        ? Badge(
                                            label: Text(e['count'].toString()),
                                            padding: const EdgeInsets.fromLTRB(
                                                6, 0, 6, 0),
                                            isLabelVisible: _mainController
                                                        .dynamicBadgeType
                                                        .value !=
                                                    DynamicBadgeMode.hidden &&
                                                e['count'] > 0,
                                            child: e['icon'],
                                          )
                                        : e['icon'],
                                    selectedIcon: e['selectIcon'],
                                    label: e['label'],
                                  );
                                }).toList(),
                              ],
                            ),
                          )
                        : Obx(
                            () => BottomNavigationBar(
                              currentIndex: _mainController.selectedIndex,
                              type: BottomNavigationBarType.fixed,
                              onTap: (value) => setIndex(value),
                              iconSize: 16,
                              selectedFontSize: 12,
                              unselectedFontSize: 12,
                              items: [
                                ..._mainController.navigationBars.map((e) {
                                  return BottomNavigationBarItem(
                                    icon: Badge(
                                      label: _mainController
                                                  .dynamicBadgeType.value ==
                                              DynamicBadgeMode.number
                                          ? Text(e['count'].toString())
                                          : null,
                                      padding:
                                          const EdgeInsets.fromLTRB(6, 0, 6, 0),
                                      isLabelVisible: _mainController
                                                  .dynamicBadgeType.value !=
                                              DynamicBadgeMode.hidden &&
                                          e['count'] > 0,
                                      child: e['icon'],
                                    ),
                                    activeIcon: e['selectIcon'],
                                    label: e['label'],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                  );
                },
              )
            : null,
      ),
    );
  }
}
