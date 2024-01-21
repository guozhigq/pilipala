import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/pages/dynamics/index.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/media/index.dart';
import 'package:pilipala/utils/event_bus.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';
import './controller.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  final MainController _mainController = Get.put(MainController());
  final HomeController _homeController = Get.put(HomeController());
  final DynamicsController _dynamicController = Get.put(DynamicsController());
  final MediaController _mediaController = Get.put(MediaController());

  int? _lastSelectTime; //上次点击时间
  Box setting = GStrorage.setting;
  late bool enableMYBar;

  @override
  void initState() {
    super.initState();
    _lastSelectTime = DateTime.now().millisecondsSinceEpoch;
    _mainController.pageController =
        PageController(initialPage: _mainController.selectedIndex);
    enableMYBar = setting.get(SettingBoxKey.enableMYBar, defaultValue: true);
  }

  void setIndex(int value) async {
    feedBack();
    _mainController.pageController!.jumpToPage(value);
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
    } else {
      _dynamicController.flag = false;
    }

    if (currentPage is MediaPage) {
      _mediaController.queryFavFolder();
    }
  }

  @override
  void dispose() async {
    await GStrorage.close();
    EventBus().off(EventName.loginEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Box localCache = GStrorage.localCache;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double sheetHeight = MediaQuery.sizeOf(context).height -
        MediaQuery.of(context).padding.top -
        MediaQuery.sizeOf(context).width * 9 / 16;
    localCache.put('sheetHeight', sheetHeight);
    localCache.put('statusBarHeight', statusBarHeight);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        _mainController.onBackPressed(context);
      },
      child: Scaffold(
        extendBody: true,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _mainController.pageController,
          onPageChanged: (index) {
            _mainController.selectedIndex = index;
            setState(() {});
          },
          children: _mainController.pages,
        ),
        bottomNavigationBar: StreamBuilder(
          stream: _mainController.hideTabBar
              ? _mainController.bottomBarStream.stream
              : StreamController<bool>.broadcast().stream,
          initialData: true,
          builder: (context, AsyncSnapshot snapshot) {
            return AnimatedSlide(
              curve: Curves.easeInOutCubicEmphasized,
              duration: const Duration(milliseconds: 500),
              offset: Offset(0, snapshot.data ? 0 : 1),
              child: enableMYBar
                  ? NavigationBar(
                      onDestinationSelected: (value) => setIndex(value),
                      selectedIndex: _mainController.selectedIndex,
                      destinations: <Widget>[
                        ..._mainController.navigationBars.map((e) {
                          return NavigationDestination(
                            icon: e['icon'],
                            selectedIcon: e['selectIcon'],
                            label: e['label'],
                          );
                        }).toList(),
                      ],
                    )
                  : BottomNavigationBar(
                      currentIndex: _mainController.selectedIndex,
                      onTap: (value) => setIndex(value),
                      iconSize: 16,
                      selectedFontSize: 12,
                      unselectedFontSize: 12,
                      items: [
                        ..._mainController.navigationBars.map((e) {
                          return BottomNavigationBarItem(
                            icon: e['icon'],
                            activeIcon: e['selectIcon'],
                            label: e['label'],
                          );
                        }).toList(),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
