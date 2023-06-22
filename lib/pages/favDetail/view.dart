import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/favDetail/index.dart';

import 'widget/fav_video_card.dart';

class FavDetailPage extends StatefulWidget {
  const FavDetailPage({super.key});

  @override
  State<FavDetailPage> createState() => _FavDetailPageState();
}

class _FavDetailPageState extends State<FavDetailPage> {
  late final ScrollController _controller = ScrollController();
  final FavDetailController _favDetailController =
      Get.put(FavDetailController());
  late StreamController<bool> titleStreamC; // a
  Future? _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _favDetailController.queryUserFavFolderDetail();
    titleStreamC = StreamController<bool>();
    _controller.addListener(
      () {
        if (_controller.offset > 160) {
          titleStreamC.add(true);
        } else if (_controller.offset <= 160) {
          titleStreamC.add(false);
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          SliverAppBar(
            expandedHeight: 260 - MediaQuery.of(context).padding.top,
            pinned: true,
            title: StreamBuilder(
              stream: titleStreamC.stream,
              initialData: false,
              builder: (context, AsyncSnapshot snapshot) {
                return AnimatedOpacity(
                  opacity: snapshot.data ? 1 : 0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 500),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _favDetailController.item!.title!,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '共${_favDetailController.item!.mediaCount!}条视频',
                            style: Theme.of(context).textTheme.labelMedium,
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
            // actions: [
            //   IconButton(
            //     onPressed: () {},
            //     icon: const Icon(Icons.more_vert),
            //   ),
            //   const SizedBox(width: 4)
            // ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                    ),
                  ),
                ),
                padding: EdgeInsets.only(
                    top: kTextTabBarHeight +
                        MediaQuery.of(context).padding.top +
                        30,
                    left: 20,
                    right: 20),
                child: SizedBox(
                  height: 200,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180,
                        height: 110,
                        child: NetworkImgLayer(
                          width: 180,
                          height: 110,
                          src: _favDetailController.item!.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            _favDetailController.item!.title!,
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .fontSize,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _favDetailController.item!.upper!.name!,
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .fontSize,
                                color: Theme.of(context).colorScheme.outline),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 8, left: 14),
              child: Obx(
                () => Text(
                  '共${_favDetailController.favDetailData.value.medias != null ? _favDetailController.favDetailData.value.medias!.length : '-'}条视频',
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium!.fontSize,
                      color: Theme.of(context).colorScheme.outline,
                      letterSpacing: 1),
                ),
              ),
            ),
          ),
          FutureBuilder(
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map data = snapshot.data;
                if (data['status']) {
                  if (_favDetailController.item!.mediaCount == 0) {
                    return const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 300,
                        child: Center(child: Text('没有内容')),
                      ),
                    );
                  } else {
                    return Obx(
                      () => SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return FavVideoCardH(
                            videoItem: _favDetailController
                                .favDetailData.value.medias![index],
                          );
                        },
                            childCount: _favDetailController
                                .favDetailData.value.medias!.length),
                      ),
                    );
                  }
                } else {
                  return HttpError(
                    errMsg: data['msg'],
                    fn: () => setState(() {}),
                  );
                }
              } else {
                return const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: Center(child: Text('加载中')),
                  ),
                );
              }
            },
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.bottom + 20,
            ),
          )
        ],
      ),
    );
  }
}
