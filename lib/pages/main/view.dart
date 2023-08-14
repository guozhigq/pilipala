import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/pages/dynamics/index.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/media/index.dart';
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

  PageController? _pageController;

  late AnimationController? _animationController;
  late Animation<double>? _fadeAnimation;
  late Animation<double>? _slideAnimation;
  int selectedIndex = 0;
  int? _lastSelectTime; //上次点击时间

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      reverseDuration: const Duration(milliseconds: 0),
      value: 1,
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.8, end: 1.0).animate(_animationController!);
    _slideAnimation =
        Tween(begin: 0.8, end: 1.0).animate(_animationController!);
    _lastSelectTime = DateTime.now().millisecondsSinceEpoch;
    _pageController = PageController(initialPage: selectedIndex);
  }

  void setIndex(int value) async {
    feedBack();
    if (selectedIndex != value) {
      selectedIndex = value;
      _animationController!.reverse().then((_) {
        selectedIndex = value;
        _animationController!.forward();
      });
      setState(() {});
    }
    _pageController!.jumpToPage(value);
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
  Widget build(BuildContext context) {
    Box localCache = GStrorage.localCache;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double sheetHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).size.width * 9 / 16;
    localCache.put('sheetHeight', sheetHeight);
    localCache.put('statusBarHeight', statusBarHeight);
    return Scaffold(
      extendBody: true,
      body: FadeTransition(
        opacity: _fadeAnimation!,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _slideAnimation!,
              curve: Curves.fastOutSlowIn,
              reverseCurve: Curves.linear,
            ),
          ),
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              selectedIndex = index;
              setState(() {});
            },
            children: _mainController.pages,
          ),
        ),
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _mainController.bottomBarStream.stream,
        initialData: true,
        builder: (context, AsyncSnapshot snapshot) {
          return AnimatedSlide(
            curve: Curves.easeInOutCubicEmphasized,
            duration: const Duration(milliseconds: 1000),
            offset: Offset(0, snapshot.data ? 0 : 1),
            child: NavigationBar(
              onDestinationSelected: (value) => setIndex(value),
              selectedIndex: selectedIndex,
              destinations: <Widget>[
                ..._mainController.navigationBars.map((e) {
                  return NavigationDestination(
                    icon: e['icon'],
                    selectedIcon: e['selectIcon'],
                    label: e['label'],
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
