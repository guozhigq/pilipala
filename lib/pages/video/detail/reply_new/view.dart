import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/dynamics.dart';
import 'package:pilipala/http/video.dart';
import 'package:pilipala/models/common/reply_type.dart';
import 'package:pilipala/models/video/reply/emote.dart';
import 'package:pilipala/models/video/reply/item.dart';
import 'package:pilipala/pages/emote/index.dart';
import 'package:pilipala/utils/feed_back.dart';

import 'toolbar_icon_button.dart';

class VideoReplyNewDialog extends StatefulWidget {
  final int? oid;
  final int? root;
  final int? parent;
  final ReplyType? replyType;
  final ReplyItemModel? replyItem;

  const VideoReplyNewDialog({
    super.key,
    this.oid,
    this.root,
    this.parent,
    this.replyType,
    this.replyItem,
  });

  @override
  State<VideoReplyNewDialog> createState() => _VideoReplyNewDialogState();
}

class _VideoReplyNewDialogState extends State<VideoReplyNewDialog>
    with WidgetsBindingObserver {
  final TextEditingController _replyContentController = TextEditingController();
  final FocusNode replyContentFocusNode = FocusNode();
  final GlobalKey _formKey = GlobalKey<FormState>();
  late double emoteHeight = 0.0;
  double keyboardHeight = 0.0; // 键盘高度
  final _debouncer = Debouncer(milliseconds: 200); // 设置延迟时间
  String toolbarType = 'input';
  RxBool isForward = false.obs;
  RxBool showForward = false.obs;
  RxString message = ''.obs;

  @override
  void initState() {
    super.initState();
    // 监听输入框聚焦
    // replyContentFocusNode.addListener(_onFocus);
    // 界面观察者 必须
    WidgetsBinding.instance.addObserver(this);
    // 自动聚焦
    _autoFocus();
    // 监听聚焦状态
    _focuslistener();
    final String routePath = Get.currentRoute;
    if (routePath.startsWith('/video')) {
      showForward.value = true;
    }
  }

  _autoFocus() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (context.mounted) {
      FocusScope.of(context).requestFocus(replyContentFocusNode);
    }
  }

  _focuslistener() {
    replyContentFocusNode.addListener(() {
      if (replyContentFocusNode.hasFocus) {
        setState(() {
          toolbarType = 'input';
        });
      }
    });
  }

  Future submitReplyAdd() async {
    feedBack();
    // String message = _replyContentController.text;
    var result = await VideoHttp.replyAdd(
      type: widget.replyType ?? ReplyType.video,
      oid: widget.oid!,
      root: widget.root!,
      parent: widget.parent!,
      message: widget.replyItem != null && widget.replyItem!.root != 0
          ? ' 回复 @${widget.replyItem!.member!.uname!} : ${message.value}'
          : message.value,
    );
    if (result['status']) {
      SmartDialog.showToast(result['data']['success_toast']);
      Get.back(result: {
        'data': ReplyItemModel.fromJson(result['data']['reply'], ''),
      });

      /// 投稿、番剧页面
      if (isForward.value) {
        await DynamicsHttp.dynamicCreate(
          mid: 0,
          rawText: message.value,
          oid: widget.oid!,
          scene: 5,
        );
      }
    } else {
      SmartDialog.showToast(result['msg']);
    }
  }

  void onChooseEmote(PackageItem package, Emote emote) {
    final int cursorPosition = _replyContentController.selection.baseOffset;
    final String currentText = _replyContentController.text;
    final String newText = currentText.substring(0, cursorPosition) +
        emote.text! +
        currentText.substring(cursorPosition);
    _replyContentController.value = TextEditingValue(
      text: newText,
      selection:
          TextSelection.collapsed(offset: cursorPosition + emote.text!.length),
    );
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final String routePath = Get.currentRoute;
    if (mounted &&
        (routePath.startsWith('/video') ||
            routePath.startsWith('/dynamicDetail'))) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 键盘高度
        final viewInsets = EdgeInsets.fromViewPadding(
            View.of(context).viewInsets, View.of(context).devicePixelRatio);
        _debouncer.run(() {
          if (mounted) {
            if (keyboardHeight == 0 && emoteHeight == 0) {
              setState(() {
                emoteHeight = keyboardHeight =
                    keyboardHeight == 0.0 ? viewInsets.bottom : keyboardHeight;
              });
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _replyContentController.dispose();
    replyContentFocusNode.removeListener(() {});
    replyContentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _keyboardHeight = EdgeInsets.fromViewPadding(
            View.of(context).viewInsets, View.of(context).devicePixelRatio)
        .bottom;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 200,
              minHeight: 120,
            ),
            child: Container(
              padding: const EdgeInsets.only(
                  top: 12, right: 15, left: 15, bottom: 10),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextField(
                    controller: _replyContentController,
                    minLines: 3,
                    maxLines: null,
                    autofocus: false,
                    focusNode: replyContentFocusNode,
                    decoration: const InputDecoration(
                        hintText: "输入回复内容",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14,
                        )),
                    style: Theme.of(context).textTheme.bodyLarge,
                    onChanged: (text) {
                      message.value = text;
                    },
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
          Container(
            height: 52,
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ToolbarIconButton(
                  onPressed: () {
                    if (toolbarType == 'emote') {
                      setState(() {
                        toolbarType = 'input';
                      });
                    }
                    FocusScope.of(context).requestFocus(replyContentFocusNode);
                  },
                  icon: const Icon(Icons.keyboard, size: 22),
                  toolbarType: toolbarType,
                  selected: toolbarType == 'input',
                ),
                const SizedBox(width: 20),
                ToolbarIconButton(
                  onPressed: () {
                    if (toolbarType == 'input') {
                      setState(() {
                        toolbarType = 'emote';
                      });
                    }
                    FocusScope.of(context).unfocus();
                  },
                  icon: const Icon(Icons.emoji_emotions, size: 22),
                  toolbarType: toolbarType,
                  selected: toolbarType == 'emote',
                ),
                const SizedBox(width: 6),
                Obx(
                  () => showForward.value
                      ? TextButton.icon(
                          onPressed: () {
                            isForward.value = !isForward.value;
                          },
                          icon: Icon(
                              isForward.value
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              size: 22),
                          label: const Text('转发到动态'),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(
                              isForward.value
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
                const Spacer(),
                SizedBox(
                  height: 36,
                  child: Obx(
                    () => FilledButton(
                      onPressed: message.isNotEmpty ? submitReplyAdd : null,
                      child: const Text('发送'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            child: SizedBox(
              width: double.infinity,
              height: toolbarType == 'input'
                  ? (_keyboardHeight > keyboardHeight
                      ? _keyboardHeight
                      : keyboardHeight)
                  : emoteHeight,
              child: EmotePanel(
                onChoose: (package, emote) => onChooseEmote(package, emote),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef DebounceCallback = void Function();

class Debouncer {
  DebounceCallback? callback;
  final int? milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds});

  run(DebounceCallback callback) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), () {
      callback();
    });
  }
}
