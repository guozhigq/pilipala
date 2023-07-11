import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/hot/index.dart';
import 'package:pilipala/pages/live/index.dart';
import 'package:pilipala/pages/rcmd/index.dart';
import './controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final HomeController _homeController = Get.put(HomeController());
  List videoList = [];
  // late TabController? _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 4, right: 4),
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'PLPL',
                    style: TextStyle(
                      height: 2.8,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontFamily: 'Jura-Bold',
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Theme(
                  data: ThemeData(
                    splashColor: Colors.transparent, // 点击时的水波纹颜色设置为透明
                    highlightColor: Colors.transparent, // 点击时的背景高亮颜色设置为透明
                  ),
                  child: TabBar(
                    controller: _homeController.tabController,
                    tabs: [
                      for (var i in _homeController.tabs) Tab(text: i['label']),
                    ],
                    isScrollable: true,
                    indicatorWeight: 0,
                    indicatorPadding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                    indicator: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    labelStyle: const TextStyle(fontSize: 13),
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: Theme.of(context).colorScheme.outline,
                    onTap: (value) => {_homeController.initialIndex = value},
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Hero(
                  tag: 'searchTag',
                  child: IconButton(
                    onPressed: () {
                      Get.toNamed('/search');
                    },
                    icon: const Icon(CupertinoIcons.search, size: 21),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _homeController.tabController,
        children: const [
          LivePage(),
          RcmdPage(),
          HotPage(),
        ],
      ),
    );
  }
}
