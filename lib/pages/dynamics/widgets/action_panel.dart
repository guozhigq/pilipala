// 操作栏
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/dynamics.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/pages/dynamics/index.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:status_bar_control/status_bar_control.dart';
import '../forward/index.dart';

class ActionPanel extends StatefulWidget {
  const ActionPanel({
    super.key,
    required this.item,
  });

  final DynamicItemModel item;

  @override
  State<ActionPanel> createState() => _ActionPanelState();
}

class _ActionPanelState extends State<ActionPanel>
    with TickerProviderStateMixin {
  final DynamicsController _dynamicsController = Get.put(DynamicsController());
  late ModuleStatModel stat;
  bool isProcessing = false;
  double defaultHeight = 260;
  RxDouble height = 0.0.obs;
  RxBool isExpand = false.obs;
  late double statusHeight;

  void Function()? handleState(Future Function() action) {
    return isProcessing
        ? null
        : () async {
            isProcessing = true;
            await action();
            isProcessing = false;
          };
  }

  @override
  void initState() {
    super.initState();
    stat = widget.item.modules!.moduleStat!;
    onInit();
  }

  onInit() async {
    statusHeight = await StatusBarControl.getHeight;
  }

  // 动态点赞
  Future onLikeDynamic() async {
    feedBack();
    var item = widget.item;
    String dynamicId = item.idStr!;
    // 1 已点赞 2 不喜欢 0 未操作
    Like like = item.modules!.moduleStat!.like!;
    int count = like.count == '点赞' ? 0 : int.parse(like.count ?? '0');
    bool status = like.status!;
    int up = status ? 2 : 1;
    var res = await DynamicsHttp.likeDynamic(dynamicId: dynamicId, up: up);
    if (res['status']) {
      SmartDialog.showToast(!status ? '点赞成功' : '取消赞');
      if (up == 1) {
        item.modules!.moduleStat!.like!.count = (count + 1).toString();
        item.modules!.moduleStat!.like!.status = true;
      } else {
        if (count == 1) {
          item.modules!.moduleStat!.like!.count = '点赞';
        } else {
          item.modules!.moduleStat!.like!.count = (count - 1).toString();
        }
        item.modules!.moduleStat!.like!.status = false;
      }
      setState(() {});
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  // 动态转发
  void forwardHandler() async {
    final userInfo = _dynamicsController.userInfo;
    if (userInfo == null) {
      SmartDialog.showToast('请先登录');
      return;
    }
    int mid = userInfo.mid!;
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return DynamicForwardPage(
          item: widget.item,
          mid: mid,
          cb: () => setState(() {
            stat.forward!.count =
                (int.parse(stat.forward!.count ?? '0') + 1).toString();
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).colorScheme.outline;
    var primary = Theme.of(context).colorScheme.primary;
    height.value = defaultHeight;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 1,
          child: TextButton.icon(
            onPressed: forwardHandler,
            icon: const Icon(
              FontAwesomeIcons.shareFromSquare,
              size: 16,
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              foregroundColor: Theme.of(context).colorScheme.outline,
            ),
            label: Text(stat.forward!.count ?? '转发'),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextButton.icon(
            onPressed: () => _dynamicsController.pushDetail(widget.item, 1,
                action: 'comment'),
            icon: const Icon(
              FontAwesomeIcons.comment,
              size: 16,
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              foregroundColor: Theme.of(context).colorScheme.outline,
            ),
            label: Text(stat.comment!.count ?? '评论'),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextButton.icon(
            onPressed: handleState(onLikeDynamic),
            icon: Icon(
              stat.like!.status!
                  ? FontAwesomeIcons.solidThumbsUp
                  : FontAwesomeIcons.thumbsUp,
              size: 16,
              color: stat.like!.status! ? primary : color,
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              foregroundColor: Theme.of(context).colorScheme.outline,
            ),
            label: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                stat.like!.count ?? '点赞',
                key: ValueKey<String>(stat.like!.count ?? '点赞'),
                style: TextStyle(
                  color: stat.like!.status! ? primary : color,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
