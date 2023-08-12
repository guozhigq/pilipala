import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/bangumi/index.dart';
import 'package:pilipala/pages/hot/index.dart';
import 'package:pilipala/pages/live/index.dart';
import 'package:pilipala/pages/main/index.dart';
import 'package:pilipala/pages/mine/index.dart';
import 'package:pilipala/pages/rcmd/index.dart';
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
  Stream<bool> stream = Get.find<MainController>().bottomBarStream.stream;

  @override
  bool get wantKeepAlive => true;

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
            stream: stream,
            ctr: _homeController,
            callback: showUserBottonSheet,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
            child: Theme(
              data: ThemeData(
                splashColor: Colors.transparent, // 点击时的水波纹颜色设置为透明
                highlightColor: Colors.transparent, // 点击时的背景高亮颜色设置为透明
              ),
              child: TabBar(
                controller: _homeController.tabController,
                tabs: [
                  for (var i in _homeController.tabs) Tab(text: i['label'])
                ],
                isScrollable: true,
                indicatorWeight: 0,
                indicatorPadding: const EdgeInsets.only(
                    top: 37, left: 18, right: 18, bottom: 6),
                indicatorColor: Colors.black,
                indicator: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.centerLeft,
                    radius: 20.00,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.background,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(2),
                    bottomLeft: Radius.circular(2),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Theme.of(context).colorScheme.primary,
                labelStyle:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                dividerColor: Colors.transparent,
                unselectedLabelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontWeight: FontWeight.normal,
                ),
                unselectedLabelColor: Theme.of(context).colorScheme.outline,
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
        return ClipRect(
          clipBehavior: Clip.hardEdge,
          child: AnimatedOpacity(
            opacity: snapshot.data ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              curve: Curves.linear,
              duration: const Duration(milliseconds: 300),
              height: snapshot.data
                  ? MediaQuery.of(context).padding.top + 42
                  : MediaQuery.of(context).padding.top,
              child: Container(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 0,
                  top: MediaQuery.of(context).padding.top,
                ),
                child: Row(children: [
                  Image.asset(
                    'assets/images/logo/logo_android_2.png',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed('/search',
                            parameters: {'hintText': ctr!.defaultSearch.value});
                      },
                      child: Container(
                        width: 250,
                        height: 40,
                        clipBehavior: Clip.hardEdge,
                        padding: const EdgeInsets.only(left: 12, right: 22),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_outlined,
                              size: 21,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Obx(
                                () => Text(
                                  ctr!.defaultSearch.value,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => ctr!.userLogin.value
                        ? GestureDetector(
                            onTap: () => callback!(),
                            child: NetworkImgLayer(
                              type: 'avatar',
                              width: 38,
                              height: 38,
                              src: ctr!.userFace.value,
                            ),
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
                ]),
              ),
            ),
          ),
        );
      },
    );
  }
}
