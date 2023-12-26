import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/mine/index.dart';
import 'package:pilipala/pages/search/index.dart';
import 'package:pilipala/utils/feed_back.dart';
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
  late Stream<bool> stream;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    stream = _homeController.searchBarStream.stream;
  }

  showUserBottomSheet() {
    feedBack();
    showModalBottomSheet(
      context: context,
      builder: (_) => const SizedBox(
        height: 450,
        child: MinePage(),
      ),
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // gradient background
          Align(
            alignment: Alignment.topLeft,
            child: Opacity(
              opacity: 0.6,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary.withOpacity(0.9),
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                        Theme.of(context).colorScheme.surface
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0, 0.0034, 0.34]),
                ),
              ),
            ),
          ),
          Column(
            children: [
              CustomAppBar(
                stream: _homeController.hideSearchBar
                    ? stream
                    : StreamController<bool>.broadcast().stream,
                ctr: _homeController,
                callback: showUserBottomSheet,
              ),
              const CustomTabs(),
              Expanded(
                child: TabBarView(
                  controller: _homeController.tabController,
                  children: _homeController.tabsPageList,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Stream<bool>? stream;
  final HomeController? ctr;
  final Function? callback;

  const CustomAppBar({
    super.key,
    this.height = kToolbarHeight,
    this.stream,
    this.ctr,
    this.callback,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      initialData: true,
      builder: (context, AsyncSnapshot snapshot) {
        return AnimatedOpacity(
          opacity: snapshot.data ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: AnimatedContainer(
            curve: Curves.easeInOutCubicEmphasized,
            duration: const Duration(milliseconds: 500),
            height: snapshot.data
                ? MediaQuery.of(context).padding.top + 52
                : MediaQuery.of(context).padding.top + 5,
            child: Container(
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 0,
                top: MediaQuery.of(context).padding.top + 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo/logo_android_2.png',
                        height: 48,
                      ),
                    ],
                  )),
                  const SearchPage(),
                  if (ctr!.userLogin.value) ...[
                    IconButton(
                        onPressed: () => Get.toNamed('/whisper'),
                        icon: const Icon(Icons.notifications_none))
                  ],
                  const SizedBox(width: 8),
                  Obx(
                    () => ctr!.userLogin.value
                        ? Stack(
                            children: [
                              Obx(
                                () => NetworkImgLayer(
                                  type: 'avatar',
                                  width: 34,
                                  height: 34,
                                  src: ctr!.userFace.value,
                                ),
                              ),
                              Positioned.fill(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => callback!(),
                                    splashColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                        .withOpacity(0.3),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : SizedBox(
                            width: 38,
                            height: 38,
                            child: IconButton(
                              style: ButtonStyle(
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  return Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface;
                                }),
                              ),
                              onPressed: () => callback!(),
                              icon: Icon(
                                Icons.account_circle,
                                size: 22,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomTabs extends StatefulWidget {
  const CustomTabs({super.key});

  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs> {
  final HomeController _homeController = Get.put(HomeController());
  int currentTabIndex = 1;

  @override
  void initState() {
    super.initState();
    _homeController.tabController.addListener(listen);
    currentTabIndex = _homeController.tabController.index;
  }

  void listen() {
    setState(() {
      currentTabIndex = _homeController.tabController.index;
    });
  }

  void onTap(int index) {
    feedBack();
    if (_homeController.initialIndex == index) {
      _homeController.tabsCtrList[index]().animateToTop();
    }
    _homeController.initialIndex = index;
    setState(() {
      _homeController.tabController.index = index;
      currentTabIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _homeController.tabController.removeListener(listen);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        scrollDirection: Axis.horizontal,
        itemCount: _homeController.tabs.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 8.0);
        },
        itemBuilder: (BuildContext context, int index) {
          bool selected = index == currentTabIndex;
          String label = _homeController.tabs[index]['label'];
          // add margins to first and last tab;
          return CustomChip(
              onTap: () {
                onTap(index);
              },
              label: label,
              selected: selected);
        },
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  final Function onTap;
  final String label;
  final bool selected;
  const CustomChip(
      {super.key,
      required this.onTap,
      required this.label,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    TextStyle? chipTextStyle =
        selected ? const TextStyle(fontWeight: FontWeight.bold) : null;

    return InputChip(
      side: const BorderSide(color: Colors.transparent),
      color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Theme.of(context).colorScheme.tertiaryContainer; // 当按钮被按下时的颜色
        }
        return Theme.of(context).colorScheme.surfaceVariant; // 默认颜色
      }),
      label: Text(
        label,
        style: chipTextStyle,
      ),
      onPressed: () {
        onTap();
      },
      selected: selected,
      showCheckmark: false,
    );
  }
}
