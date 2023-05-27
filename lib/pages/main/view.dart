import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/hot/index.dart';
import './controller.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  final MainController _mainController = Get.put(MainController());
  final HomeController _homeController = Get.put(HomeController());
  final HotController _hotController = Get.put(HotController());
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
          await Future.delayed(const Duration(microseconds: 300));
          _homeController.animateToTop();
        }
        _lastSelectTime = DateTime.now().millisecondsSinceEpoch;
      }
      _homeController.flag = true;
    } else {
      _homeController.flag = false;
    }

    if (currentPage is HotPage) {
      if (_hotController.flag) {
        // 单击返回顶部 双击并刷新
        if (DateTime.now().millisecondsSinceEpoch - _lastSelectTime! < 500) {
          _hotController.onRefresh();
        } else {
          await Future.delayed(const Duration(microseconds: 300));
          _hotController.animateToTop();
        }
        _lastSelectTime = DateTime.now().millisecondsSinceEpoch;
      }
      _hotController.flag = true;
    } else {
      _hotController.flag = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            controller: _pageController,
            // physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              selectedIndex = index;
              setState(() {});
            },
            children: _mainController.pages,
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 1,
        destinations: _mainController.navigationBars.map((e) {
          return NavigationDestination(
            icon: e['icon'],
            selectedIcon: e['selectedIcon'],
            label: e['label'],
          );
        }).toList(),
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) => setIndex(value),
      ),
    );
  }
}
