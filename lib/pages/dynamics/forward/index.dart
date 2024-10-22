import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/http/dynamics.dart';
import 'package:pilipala/models/dynamics/result.dart';

import '../widgets/rich_node_panel.dart';

class DynamicForwardPage extends StatefulWidget {
  const DynamicForwardPage({
    super.key,
    this.item,
    this.mid,
    this.cb,
  });

  final DynamicItemModel? item;
  final int? mid;
  final Function()? cb;

  @override
  State<DynamicForwardPage> createState() => _DynamicForwardPageState();
}

class _DynamicForwardPageState extends State<DynamicForwardPage> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  RxBool isExpand = false.obs;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void dynamicForward(String type) async {
    String dynamicId = widget.item!.idStr!;
    var res = await DynamicsHttp.dynamicCreate(
      dynIdStr: dynamicId,
      mid: widget.mid!,
      rawText: type == 'quickForward' ? '' : _inputController.text,
      scene: 4,
    );
    if (res['status']) {
      SmartDialog.showToast('转发成功');
      widget.cb?.call();
      _onClose();
    } else {
      SmartDialog.showToast(res['message']);
    }
  }

  void _onClose() async {
    _focusNode.unfocus();
    await Future.delayed(const Duration(milliseconds: 120));
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final EdgeInsetsGeometry padding = EdgeInsets.fromLTRB(
          isExpand.value ? 10 : 16,
          10,
          isExpand.value ? 12 : 12,
          0,
        );
        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          onEnd: () => isExpand.value ? _focusNode.requestFocus() : null,
          child: Column(
            mainAxisSize: isExpand.value ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: padding,
                child: isExpand.value ? _topBarExpand() : _topBar(),
              ),
              isExpand.value ? _contentExpand() : _content(),
              dynamicPreview(),
              if (!isExpand.value) ..._bottomBar(),
            ],
          ),
        );
      },
    );
  }

  // 转发动态预览
  Widget dynamicPreview() {
    ItemModulesModel? modules = widget.item!.modules;
    final String type = widget.item!.type!;
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
        String forwardType = widget.item!.orig!.type!;
        switch (forwardType) {
          /// 图文动态
          case 'DYNAMIC_TYPE_DRAW':
            cover = modules?.moduleDynamic?.major?.opus?.pics?.first.url;

          /// 投稿
          case 'DYNAMIC_TYPE_AV':
            cover = modules?.moduleDynamic?.major?.archive?.cover;

          /// 番剧
          case 'DYNAMIC_TYPE_PGC_UNION':
            cover = modules?.moduleDynamic?.major?.pgc?.cover;
          // 专栏文章
          case 'DYNAMIC_TYPE_ARTICLE':
          // 番剧
          case 'DYNAMIC_TYPE_PGC':
          // 纯文字动态
          case 'DYNAMIC_TYPE_WORD':
          // 直播
          case 'DYNAMIC_TYPE_LIVE_RCMD':
          // 合集查看
          case 'DYNAMIC_TYPE_UGC_SEASON':
            cover = '';

          default:
            cover = '';
        }

      // 专栏文章
      case 'DYNAMIC_TYPE_ARTICLE':
      // 番剧
      case 'DYNAMIC_TYPE_PGC':
      // 纯文字动态
      case 'DYNAMIC_TYPE_WORD':
      // 直播
      case 'DYNAMIC_TYPE_LIVE_RCMD':
      // 合集查看
      case 'DYNAMIC_TYPE_UGC_SEASON':
      // 番剧查看
      case 'DYNAMIC_TYPE_PGC_UNION':
        cover = '';
      default:
        cover = '';
    }
    return Container(
      width: double.infinity,
      height: 98,
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
              '@${widget.item!.modules!.moduleAuthor!.name}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                NetworkImgLayer(
                  src: cover ?? '',
                  width: 45,
                  height: 45,
                  radius: 6,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
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

  // 未展开时的顶部
  Widget _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '转发动态',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () => dynamicForward('quickForward'),
          child: const Text('快速转发'),
        )
      ],
    );
  }

  // 展开时的顶部
  Widget _topBarExpand() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _onClose,
              icon: const Icon(Icons.close),
            ),
            FilledButton(
              onPressed: () => dynamicForward('forward'),
              child: const Text('转发'),
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            '转发动态',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // 未展开时的底部
  List<Widget> _bottomBar() {
    return [
      const Divider(thickness: 0.1, height: 1),
      ListTile(
        onTap: () => Get.back(),
        minLeadingWidth: 0,
        dense: true,
        title: Text(
          '取消',
          style: TextStyle(color: Theme.of(context).colorScheme.outline),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).padding.bottom,
      )
    ];
  }

  // 未展开时的内容区
  Widget _content() {
    return GestureDetector(
      onTap: () {
        isExpand.value = true;
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(16, 10, 10, 16),
        child: Text(
          '说点什么吧',
          textAlign: TextAlign.start,
          style: TextStyle(color: Theme.of(context).colorScheme.outline),
        ),
      ),
    );
  }

  // 展开时的内容区
  Widget _contentExpand() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: TextField(
        maxLines: null,
        minLines: 3,
        focusNode: _focusNode,
        controller: _inputController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: '说点什么吧',
        ),
      ),
    );
  }
}
