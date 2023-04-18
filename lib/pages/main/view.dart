import 'package:flutter/material.dart';
import 'package:pilipala/pages/home/view.dart';
import 'package:pilipala/pages/hot/view.dart';
import 'package:pilipala/pages/mine/view.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int selectedIndex = 0;

  void setIndex(int value) {
    if (selectedIndex != value) {
      selectedIndex = value;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          HomePage(),
          HotPage(),
          MinePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        elevation: 1,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "推荐",
          ),
          NavigationDestination(
            icon: Icon(Icons.whatshot_outlined),
            selectedIcon: Icon(Icons.whatshot_rounded),
            label: "热门",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: "我的",
            selectedIcon: Icon(Icons.person),
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) => setIndex(value),
      ),
    );
  }
}
