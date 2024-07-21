import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/no_data.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';
import 'package:pilipala/utils/utils.dart';
import '../../common/widgets/http_error.dart';
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
    _futureBuilderFuture = _memberArchivesController.getMemberArchive('init');
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
        title: Obx(
          () => Text(
              '他的投稿 - ${_memberArchivesController.currentOrder['label']}',
              style: Theme.of(context).textTheme.titleMedium),
        ),
        actions: [
          // Obx(
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              // 这里处理选择逻辑
              _memberArchivesController.currentOrder.value = value;
              _memberArchivesController.getMemberArchive('init');
            },
            itemBuilder: (BuildContext context) =>
                _memberArchivesController.orderList.map(
              (e) {
                return PopupMenuItem(
                  value: e,
                  child: Text(e['label']!),
                );
              },
            ).toList(),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: CustomScrollView(
        controller: _memberArchivesController.scrollController,
        slivers: [
          FutureBuilder(
            future: _futureBuilderFuture,
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data != null) {
                  Map data = snapshot.data as Map;
                  List list = _memberArchivesController.archivesList;
                  if (data['status']) {
                    return Obx(
                      () => list.isNotEmpty
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, index) {
                                  return VideoCardH(
                                    videoItem: list[index],
                                    showOwner: false,
                                    showPubdate: true,
                                    showCharge: true,
                                  );
                                },
                                childCount: list.length,
                              ),
                            )
                          : _memberArchivesController.isLoading.value
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    return const VideoCardHSkeleton();
                                  }, childCount: 10),
                                )
                              : const NoData(),
                    );
                  } else {
                    return HttpError(
                      errMsg: snapshot.data['msg'],
                      fn: () {},
                    );
                  }
                } else {
                  return HttpError(
                    errMsg: snapshot.data['msg'],
                    fn: () {},
                  );
                }
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return const VideoCardHSkeleton();
                  }, childCount: 10),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
