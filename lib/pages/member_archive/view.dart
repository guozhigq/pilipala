import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';
import 'package:pilipala/utils/utils.dart';
import 'controller.dart';

class MemberArchivePage extends StatefulWidget {
  const MemberArchivePage({super.key});

  @override
  State<MemberArchivePage> createState() => _MemberArchivePageState();
}

class _MemberArchivePageState extends State<MemberArchivePage> {
  late MemberArchiveController _memberArchivesController;
  late Future _futureBuilderFuture;
  late ScrollController scrollController;
  late int mid;

  @override
  void initState() {
    super.initState();
    mid = int.parse(Get.parameters['mid']!);
    final String heroTag = Utils.makeHeroTag(mid);
    _memberArchivesController =
        Get.put(MemberArchiveController(), tag: heroTag);
    _futureBuilderFuture =
        _memberArchivesController.getMemberArchive('onRefresh');
    scrollController = _memberArchivesController.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle(
              'member_archives', const Duration(milliseconds: 500), () {
            _memberArchivesController.onLoad();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Text('他的投稿', style: Theme.of(context).textTheme.titleMedium),
        // actions: [
        //   Obx(
        //     () => PopupMenuButton<String>(
        //       padding: EdgeInsets.zero,
        //       tooltip: '投稿排序',
        //       icon: Icon(
        //         Icons.more_vert_outlined,
        //         color: Theme.of(context).colorScheme.outline,
        //       ),
        //       position: PopupMenuPosition.under,
        //       onSelected: (String type) {},
        //       itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        //         for (var i in _memberArchivesController.orderList) ...[
        //           PopupMenuItem<String>(
        //             onTap: () {},
        //             value: _memberArchivesController.currentOrder['label'],
        //             child: Row(
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 Text(i['label']!),
        //                 if (_memberArchivesController.currentOrder['label'] ==
        //                     i['label']) ...[
        //                   const SizedBox(width: 10),
        //                   const Icon(Icons.done, size: 20),
        //                 ],
        //               ],
        //             ),
        //           ),
        //         ]
        //       ],
        //     ),
        //   ),
        // ],
      ),
      body: CustomScrollView(
        controller: _memberArchivesController.scrollController,
        slivers: [
          FutureBuilder(
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  Map data = snapshot.data as Map;
                  List list = _memberArchivesController.archivesList;
                  if (data['status']) {
                    return Obx(
                      () => list.isNotEmpty
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return VideoCardH(
                                    videoItem: list[index],
                                    showOwner: false,
                                    showPubdate: true,
                                  );
                                },
                                childCount: list.length,
                              ),
                            )
                          : const SliverToBoxAdapter(),
                    );
                  } else {
                    return const SliverToBoxAdapter();
                  }
                } else {
                  return const SliverToBoxAdapter();
                }
              } else {
                return const SliverToBoxAdapter();
              }
            },
          ),
        ],
      ),
    );
  }
}
