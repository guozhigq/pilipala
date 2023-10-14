import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/pages/dynamics/widgets/dynamic_panel.dart';
import 'package:pilipala/utils/utils.dart';

import 'controller.dart';

class MemberDynamicPanel extends StatefulWidget {
  final int? mid;
  const MemberDynamicPanel({super.key, this.mid});

  @override
  State<MemberDynamicPanel> createState() => _MemberDynamicPanelState();
}

class _MemberDynamicPanelState extends State<MemberDynamicPanel>
    with AutomaticKeepAliveClientMixin {
  DateTime lastRefreshTime = DateTime.now();
  late final LoadMoreListSource source;
  late final MemberDynamicPanelController _dynamicController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _dynamicController = Get.put(MemberDynamicPanelController(widget.mid),
        tag: Utils.makeHeroTag(widget.mid));
    source = LoadMoreListSource(_dynamicController);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LoadingMoreList<DynamicItemModel>(
      ListConfig<DynamicItemModel>(
        sourceList: source,
        itemBuilder: (BuildContext c, DynamicItemModel item, int index) {
          return DynamicPanel(item: item);
        },
        indicatorBuilder: _buildIndicator,
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

class LoadMoreListSource extends LoadingMoreBase<DynamicItemModel> {
  late MemberDynamicPanelController ctr;
  LoadMoreListSource(this.ctr);

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    bool isSuccess = false;
    var res = await ctr.getMemberDynamic();
    if (res['status']) {
      addAll(res['data'].items);
    }
    if (res['data'].hasMore) {
      isSuccess = true;
    } else {
      isSuccess = false;
    }
    return isSuccess;
  }
}
