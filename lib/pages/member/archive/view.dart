import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';
import 'package:pilipala/models/member/archive.dart';
import 'package:pilipala/pages/member/archive/index.dart';
import 'package:pilipala/utils/utils.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

class ArchivePanel extends StatefulWidget {
  final int? mid;
  const ArchivePanel({super.key, this.mid});

  @override
  State<ArchivePanel> createState() => _ArchivePanelState();
}

class _ArchivePanelState extends State<ArchivePanel>
    with AutomaticKeepAliveClientMixin {
  DateTime lastRefreshTime = DateTime.now();
  late final LoadMoreListSource source;
  late final ArchiveController _archiveController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print('🐶🐶： ${widget.mid}');
    _archiveController = Get.put(ArchiveController(widget.mid),
        tag: Utils.makeHeroTag(widget.mid));
    source = LoadMoreListSource(_archiveController);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            // PullToRefreshContainer(
            //   (PullToRefreshScrollNotificationInfo? info) {
            //     return PullToRefreshHeader(info, lastRefreshTime);
            //   },
            // ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 14, top: 8, bottom: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('排序方式'),
                  SizedBox(
                    height: 35,
                    width: 85,
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      onPressed: () {
                        // _archiveController.order = 'click';
                        // _archiveController.pn = 1;
                        _archiveController.toggleSort();
                        source.refresh(true);
                        // LoadMoreListSource().loadData();
                      },
                      child: Obx(
                        () => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: Text(
                            _archiveController.currentOrder['label']!,
                            key: ValueKey<String>(
                                _archiveController.currentOrder['label']!),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LoadingMoreList<VListItemModel>(
                ListConfig<VListItemModel>(
                  sourceList: source,
                  itemBuilder:
                      (BuildContext c, VListItemModel item, int index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          const SizedBox(height: 6),
                          VideoCardH(videoItem: item)
                        ],
                      );
                    } else {
                      return VideoCardH(videoItem: item);
                    }
                  },
                  indicatorBuilder: _buildIndicator,
                ),
              ),
            )
          ],
        ),
        showGlowLeading: false,
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    TextStyle style =
        TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.outline);
    Widget? widget;
    switch (status) {
      case IndicatorStatus.none:
        widget = Container(height: 0.0);
        break;
      case IndicatorStatus.loadingMoreBusying:
        widget = Text('加载中...', style: style);
        widget = _setbackground(false, widget, height: 60.0);
        break;
      case IndicatorStatus.fullScreenBusying:
        widget = Text('加载中...', style: style);
        widget = _setbackground(true, widget);
        break;
      case IndicatorStatus.error:

        /// TODO 异常逻辑
        widget = Text('没有更多了', style: style);
        widget = _setbackground(false, widget);

        widget = GestureDetector(
          onTap: () {},
          child: widget,
        );

        break;
      case IndicatorStatus.fullScreenError:

        /// TODO 异常逻辑
        widget = Text('没有更多了', style: style);
        widget = _setbackground(true, widget);
        widget = GestureDetector(
          onTap: () {},
          child: widget,
        );
        break;
      case IndicatorStatus.noMoreLoad:
        widget = Text('没有更多了', style: style);
        widget = _setbackground(false, widget, height: 60.0);
        break;
      case IndicatorStatus.empty:
        widget = Text('用户没有投稿', style: style);
        widget = _setbackground(true, widget);
        break;
    }
    return widget;
  }

  Widget _setbackground(bool full, Widget widget, {double height = 100}) {
    widget = Padding(
      padding: height == double.infinity
          ? EdgeInsets.zero
          : EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Container(
        width: double.infinity,
        height: height,
        color: Theme.of(context).colorScheme.background,
        alignment: Alignment.center,
        child: widget,
      ),
    );
    return widget;
  }

  Widget getIndicator(BuildContext context) {
    final TargetPlatform platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS
        ? const CupertinoActivityIndicator(
            animating: true,
            radius: 16.0,
          )
        : CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          );
  }
}

class LoadMoreListSource extends LoadingMoreBase<VListItemModel> {
  late ArchiveController ctr;
  LoadMoreListSource(this.ctr);
  bool forceRefresh = false;

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    bool isSuccess = false;
    var res = await ctr.getMemberArchive();
    if (res['status']) {
      if (ctr.pn == 2) {
        clear();
      }
      addAll(res['data'].list.vlist);
    }
    if (length < res['data'].page['count']) {
      isSuccess = true;
    } else {
      isSuccess = false;
    }
    return isSuccess;
  }

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    // _hasMore = true;
    // pageindex = 1;
    // //force to refresh list when you don't want clear list before request
    // //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);

    forceRefresh = false;
    return result;
  }
}
