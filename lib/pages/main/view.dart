import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './controller.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  final MainController _mainController = Get.put(MainController());
  late AnimationController? _animationController;
  late Animation<double>? _fadeAnimation;
  late Animation<double>? _slideAnimation;
  int selectedIndex = 0;

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
  }

  void setIndex(int value) {
    if (selectedIndex != value) {
      selectedIndex = value;
      _animationController!.reverse().then((_) {
        selectedIndex = value;
        _animationController!.forward();
      });
      setState(() {});
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
          child: IndexedStack(
            index: selectedIndex,
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
