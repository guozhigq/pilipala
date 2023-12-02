import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/main/index.dart';
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

  showUserBottonSheet() {
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
      appBar: AppBar(toolbarHeight: 0, elevation: 0),
      body: Column(
        children: [
          CustomAppBar(
            stream: _homeController.hideSearchBar
                ? stream
                : StreamController<bool>.broadcast().stream,
            ctr: _homeController,
            callback: showUserBottonSheet,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: Align(
              alignment: Alignment.center,
              child: TabBar(
                controller: _homeController.tabController,
                tabs: [
                  for (var i in _homeController.tabs) Tab(text: i['label'])
                ],
                isScrollable: true,
                dividerColor: Colors.transparent,
                enableFeedback: true,
                splashBorderRadius: BorderRadius.circular(10),
                onTap: (value) {
                  feedBack();
                  if (_homeController.initialIndex == value) {
                    _homeController.tabsCtrList[value]().animateToTop();
                  }
                  _homeController.initialIndex = value;
                },
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _homeController.tabController,
              children: _homeController.tabsPageList,
            ),
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
                : MediaQuery.of(context).padding.top - 10,
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 0,
                top: MediaQuery.of(context).padding.top + 4,
              ),
              child: Row(
                children: [
                  const Expanded(child: SearchPage()),
                  const SizedBox(width: 10),
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
                                Icons.person_rounded,
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
