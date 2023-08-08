import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/bangumi/index.dart';
import 'package:pilipala/pages/hot/index.dart';
import 'package:pilipala/pages/live/index.dart';
import 'package:pilipala/pages/main/index.dart';
import 'package:pilipala/pages/mine/index.dart';
import 'package:pilipala/pages/rcmd/index.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/storage.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(toolbarHeight: 0, elevation: 0),
      body: Column(
        children: [
          CustomAppBar(stream: stream, ctr: _homeController),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent, // 点击时的水波纹颜色设置为透明
                      highlightColor: Colors.transparent, // 点击时的背景高亮颜色设置为透明
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: TabBar(
                        controller: _homeController.tabController,
                        tabs: [
                          for (var i in _homeController.tabs)
                            // Tab(text: i['label'])
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 11),
                              child: Row(
                                children: [
                                  i['icon'],
                                  const SizedBox(width: 4),
                                  Text(i['label'])
                                ],
                              ),
                            ),
                        ],
                        isScrollable: true,
                        indicatorWeight: 0,
                        indicatorPadding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 5),
                        indicator: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.8),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Theme.of(context).colorScheme.primary,
                        labelStyle: const TextStyle(fontSize: 13),
                        dividerColor: Colors.transparent,
                        unselectedLabelColor:
                            Theme.of(context).colorScheme.outline,
                        onTap: (value) =>
                            {feedBack(), _homeController.initialIndex = value},
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: IconButton(
                    tooltip: '全部分类',
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () async {},
                    icon: Icon(
                      Icons.dataset_outlined,
                      color: Theme.of(context).colorScheme.outline,
                      size: 19,
                    ),
                  ),
                ),
                const SizedBox(width: 14)
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _homeController.tabController,
              children: const [
                LivePage(),
                RcmdPage(),
                HotPage(),
                BangumiPage(),
              ],
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
  final ctr;

  const CustomAppBar({
    super.key,
    this.height = kToolbarHeight,
    this.stream,
    this.ctr,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    Box user = GStrorage.user;

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
              height: snapshot.data ? 94 : MediaQuery.of(context).padding.top,
              child: Container(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 4,
                  top: MediaQuery.of(context).padding.top,
                ),
                child: Row(
                  children: [
                    const Text(
                      'PLPL',
                      style: TextStyle(
                        height: 2.8,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Jura-Bold',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed('/search', parameters: {
                            'hintText': ctr.defaultSearch.value
                          });
                        },
                        child: Container(
                          width: 250,
                          height: 45,
                          clipBehavior: Clip.hardEdge,
                          padding: const EdgeInsets.only(left: 12, right: 22),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            color:
                                Theme.of(context).colorScheme.onInverseSurface,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search_outlined,
                                size: 23,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              const SizedBox(width: 7),
                              Expanded(
                                child: Obx(
                                  () => Text(
                                    ctr.defaultSearch.value,
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
                    const SizedBox(width: 12),
                    if (user.get(UserBoxKey.userLogin) ?? false) ...[
                      GestureDetector(
                        onTap: () {
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
                        },
                        child: NetworkImgLayer(
                          type: 'avatar',
                          width: 34,
                          height: 34,
                          src: user.get(UserBoxKey.userFace),
                        ),
                      )
                    ] else ...[
                      IconButton(
                        onPressed: () {
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
                        },
                        icon: const Icon(CupertinoIcons.person, size: 22),
                      )
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
