import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pilipala/common/widgets/pull_to_refresh_header.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';
import 'package:pilipala/models/member/archive.dart';
import 'package:pilipala/pages/member/archive/index.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class ArchivePanel extends StatefulWidget {
  const ArchivePanel({super.key});

  @override
  State<ArchivePanel> createState() => _ArchivePanelState();
}

class _ArchivePanelState extends State<ArchivePanel>
    with AutomaticKeepAliveClientMixin {
  DateTime lastRefreshTime = DateTime.now();
  late final LoadMoreListSource source = LoadMoreListSource();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return PullToRefreshNotification(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        return true;
      },
      maxDragOffset: 50,
      child: GlowNotificationWidget(
        Column(
          children: <Widget>[
            // 下拉刷新指示器
            PullToRefreshContainer(
              (PullToRefreshScrollNotificationInfo? info) {
                return PullToRefreshHeader(info, lastRefreshTime);
              },
            ),
            const SizedBox(height: 4),
            Expanded(
              child: LoadingMoreList<VListItemModel>(
                ListConfig<VListItemModel>(
                  sourceList: source,
                  itemBuilder:
                      (BuildContext c, VListItemModel item, int index) {
                    return VideoCardH(videoItem: item);
                  },
                  indicatorBuilder: (context, status) {
                    return const Center(child: Text('加载中'));
                  },
                ),
              ),
            )
          ],
        ),
        showGlowLeading: false,
      ),
    );
  }
}

class LoadMoreListSource extends LoadingMoreBase<VListItemModel> {
  final ArchiveController _archiveController = Get.put(ArchiveController());
  @override
  Future<bool> loadData([bool isloadMoreAction = false]) {
    return Future<bool>(() async {
      var res = await _archiveController.getMemberArchive();
      if (res['status']) {
        addAll(res['data'].list.vlist);
      }
      return true;
    });
  }
}
