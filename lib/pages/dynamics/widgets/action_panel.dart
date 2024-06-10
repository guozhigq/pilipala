// 操作栏
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/http/dynamics.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/pages/dynamics/index.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:status_bar_control/status_bar_control.dart';
import 'rich_node_panel.dart';

class ActionPanel extends StatefulWidget {
  const ActionPanel({
    super.key,
    required this.item,
  });
  // ignore: prefer_typing_uninitialized_variables
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
  TextEditingController _inputController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  String _inputText = '';

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
    var item = widget.item!;
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

  // 转发动态预览
  Widget dynamicPreview() {
    ItemModulesModel? modules = widget.item.modules;
    final String type = widget.item.type!;
    String? cover = modules?.moduleAuthor?.face;
    switch (type) {
      /// 图文动态
      case 'DYNAMIC_TYPE_DRAW':
        cover = modules?.moduleDynamic?.major?.opus?.pics?.first.url;

      /// 投稿
      case 'DYNAMIC_TYPE_AV':
        cover = modules?.moduleDynamic?.major?.archive?.cover;

      /// 转发的动态
      case 'DYNAMIC_TYPE_FORWARD':
        String forwardType = widget.item.orig!.type!;
        switch (forwardType) {
          /// 图文动态
          case 'DYNAMIC_TYPE_DRAW':
            cover = modules?.moduleDynamic?.major?.opus?.pics?.first.url;

          /// 投稿
          case 'DYNAMIC_TYPE_AV':
            cover = modules?.moduleDynamic?.major?.archive?.cover;

          /// 专栏文章
          case 'DYNAMIC_TYPE_ARTICLE':
            cover = '';

          /// 番剧
          case 'DYNAMIC_TYPE_PGC':
            cover = '';

          /// 纯文字动态
          case 'DYNAMIC_TYPE_WORD':
            cover = '';

          /// 直播
          case 'DYNAMIC_TYPE_LIVE_RCMD':
            cover = '';

          /// 合集查看
          case 'DYNAMIC_TYPE_UGC_SEASON':
            cover = '';

          /// 番剧
          case 'DYNAMIC_TYPE_PGC_UNION':
            cover = modules?.moduleDynamic?.major?.pgc?.cover;

          default:
            cover = '';
        }

      /// 专栏文章
      case 'DYNAMIC_TYPE_ARTICLE':
        cover = '';

      /// 番剧
      case 'DYNAMIC_TYPE_PGC':
        cover = '';

      /// 纯文字动态
      case 'DYNAMIC_TYPE_WORD':
        cover = '';

      /// 直播
      case 'DYNAMIC_TYPE_LIVE_RCMD':
        cover = '';

      /// 合集查看
      case 'DYNAMIC_TYPE_UGC_SEASON':
        cover = '';

      /// 番剧查看
      case 'DYNAMIC_TYPE_PGC_UNION':
        cover = '';

      default:
        cover = '';
    }
    return Container(
      width: double.infinity,
      height: 95,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 14),
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(6),
        border: Border(
          left: BorderSide(
              width: 4,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.8)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '@${widget.item.modules!.moduleAuthor!.name}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                NetworkImgLayer(
                  src: cover ?? '',
                  width: 34,
                  height: 34,
                  type: 'emote',
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    style: const TextStyle(height: 0),
                    richNode(widget.item, context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Text(data)
              ],
            )
          ],
        ),
      ),
    );
  }

  // 动态转发
  void forwardHandler() async {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) {
        return Obx(
          () => AnimatedContainer(
            duration: Durations.medium1,
            onEnd: () async {
              if (isExpand.value) {
                await Future.delayed(const Duration(milliseconds: 80));
                myFocusNode.requestFocus();
              }
            },
            height: height.value + MediaQuery.of(context).padding.bottom,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: Durations.medium1,
                  height: isExpand.value ? statusHeight : 0,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    isExpand.value ? 10 : 16,
                    10,
                    isExpand.value ? 14 : 12,
                    0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isExpand.value) ...[
                        IconButton(
                          onPressed: () => togglePanelState(false),
                          icon: const Icon(Icons.close),
                        ),
                        Text(
                          '转发动态',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                      ] else ...[
                        const Text(
                          '转发动态',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                      isExpand.value
                          ? FilledButton(
                              onPressed: () => dynamicForward('forward'),
                              child: const Text('转发'),
                            )
                          : TextButton(
                              onPressed: () {},
                              child: const Text('立即转发'),
                            )
                    ],
                  ),
                ),
                if (!isExpand.value) ...[
                  GestureDetector(
                    onTap: () => togglePanelState(true),
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.fromLTRB(16, 0, 10, 14),
                      child: Text(
                        '说点什么吧',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: TextField(
                      maxLines: 5,
                      focusNode: myFocusNode,
                      controller: _inputController,
                      onChanged: (value) {
                        setState(() {
                          _inputText = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '说点什么吧',
                      ),
                    ),
                  ),
                ],
                dynamicPreview(),
                if (!isExpand.value) ...[
                  const Divider(thickness: 0.1, height: 1),
                  ListTile(
                    onTap: () => Get.back(),
                    minLeadingWidth: 0,
                    dense: true,
                    title: Text(
                      '取消',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  togglePanelState(status) {
    if (!status) {
      Get.back();
      height.value = defaultHeight;
      _inputText = '';
      _inputController.clear();
    } else {
      height.value = Get.size.height;
    }
    isExpand.value = !(isExpand.value);
  }

  dynamicForward(String type) async {
    String dynamicId = widget.item.idStr!;
    var res = await DynamicsHttp.dynamicCreate(
      dynIdStr: dynamicId,
      mid: _dynamicsController.userInfo.mid,
      rawText: _inputText,
      scene: 4,
    );
    if (res['status']) {
      SmartDialog.showToast(type == 'forward' ? '转发成功' : '发布成功');
      togglePanelState(false);
    }
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).colorScheme.outline;
    var primary = Theme.of(context).colorScheme.primary;
    height.value = defaultHeight;
    print('height.value: ${height.value}');
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
