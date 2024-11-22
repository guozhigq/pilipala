import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/video/reply/emote.dart';
import 'package:pilipala/pages/emote/index.dart';
import 'package:pilipala/pages/video/detail/reply_new/toolbar_icon_button.dart';
import 'package:pilipala/pages/whisper_detail/controller.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'widget/chat_item.dart';

class WhisperDetailPage extends StatefulWidget {
  const WhisperDetailPage({super.key});

  @override
  State<WhisperDetailPage> createState() => _WhisperDetailPageState();
}

class _WhisperDetailPageState extends State<WhisperDetailPage>
    with WidgetsBindingObserver {
  final WhisperDetailController _whisperDetailController =
      Get.put(WhisperDetailController());
  late Future _futureBuilderFuture;
  late TextEditingController _replyContentController;
  final FocusNode replyContentFocusNode = FocusNode();
  final _debouncer = Debouncer(milliseconds: 200); // 设置延迟时间
  late double emoteHeight = 230.0;
  double keyboardHeight = 0.0; // 键盘高度
  RxString toolbarType = ''.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _futureBuilderFuture = _whisperDetailController.querySessionMsg();
    _replyContentController = _whisperDetailController.replyContentController;
    _focuslistener();
  }

  _focuslistener() {
    replyContentFocusNode.addListener(() {
      if (replyContentFocusNode.hasFocus) {
        toolbarType.value = 'input';
      }
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final String routePath = Get.currentRoute;
    if (mounted && routePath.startsWith('/whisperDetail')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 键盘高度
        final viewInsets = EdgeInsets.fromViewPadding(
            View.of(context).viewInsets, View.of(context).devicePixelRatio);
        _debouncer.run(() {
          if (mounted) {
            if (keyboardHeight == 0) {
              setState(() {
                keyboardHeight =
                    keyboardHeight == 0.0 ? viewInsets.bottom : keyboardHeight;
                if (keyboardHeight != 0) {
                  emoteHeight = keyboardHeight;
                }
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
    replyContentFocusNode.removeListener(() {});
    replyContentFocusNode.dispose();
    super.dispose();
  }

  void onChooseEmote(PackageItem package, Emote emote) {
    _whisperDetailController.emoteList.add(
      {'text': emote.text, 'url': emote.url},
    );
    final int cursorPosition =
        max(_replyContentController.selection.baseOffset, 0);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              SizedBox(
                width: 34,
                height: 34,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  feedBack();
                  Get.toNamed(
                    '/member?mid=${_whisperDetailController.mid}',
                    arguments: {
                      'face': _whisperDetailController.face,
                      'heroTag': null
                    },
                  );
                },
                child: Row(
                  children: <Widget>[
                    Hero(
                      tag: _whisperDetailController.heroTag,
                      child: NetworkImgLayer(
                        width: 34,
                        height: 34,
                        type: 'avatar',
                        src: _whisperDetailController.face,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _whisperDetailController.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 36, height: 36),
            ],
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert_outlined, size: 20),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                onTap: () => _whisperDetailController.removeSession(context),
                child: const Text('关闭会话'),
              )
            ],
          ),
          const SizedBox(width: 14)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                toolbarType.value = '';
              },
              child: FutureBuilder(
                future: _futureBuilderFuture,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const SizedBox();
                    }
                    final Map data = snapshot.data as Map;
                    if (data['status']) {
                      List messageList = _whisperDetailController.messageList;
                      return Obx(
                        () => messageList.isEmpty
                            ? const SizedBox()
                            : Align(
                                alignment: Alignment.topCenter,
                                child: ListView.separated(
                                  itemCount: messageList.length,
                                  shrinkWrap: true,
                                  reverse: true,
                                  itemBuilder: (_, int i) {
                                    return ChatItem(
                                      item: messageList[i],
                                      e_infos: _whisperDetailController.eInfos,
                                      ctr: _whisperDetailController,
                                    );
                                  },
                                  separatorBuilder: (_, int i) {
                                    return i == 0
                                        ? const SizedBox(height: 20)
                                        : const SizedBox.shrink();
                                  },
                                ),
                              ),
                      );
                    } else {
                      // 请求错误
                      return const SizedBox();
                    }
                  } else {
                    // 骨架屏
                    return const SizedBox();
                  }
                },
              ),
            ),
          ),
          Obx(
            () => Container(
              padding: EdgeInsets.fromLTRB(
                8,
                12,
                12,
                toolbarType.value == ''
                    ? MediaQuery.of(context).padding.bottom + 6
                    : 6,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Colors.grey.withOpacity(0.15),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToolbarIconButton(
                    onPressed: () {
                      if (toolbarType.value == '') {
                        toolbarType.value = 'emote';
                      } else if (toolbarType.value == 'input') {
                        FocusScope.of(context).unfocus();
                        toolbarType.value = 'emote';
                      } else if (toolbarType.value == 'emote') {
                        FocusScope.of(context).requestFocus();
                      }
                    },
                    icon: const Icon(Icons.emoji_emotions_outlined, size: 22),
                    toolbarType: toolbarType.value,
                    selected: false,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.05),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: TextField(
                        style: Theme.of(context).textTheme.titleMedium,
                        controller: _replyContentController,
                        autofocus: false,
                        focusNode: replyContentFocusNode,
                        decoration: const InputDecoration(
                          border: InputBorder.none, // 移除默认边框
                          hintText: '文明发言 ～', // 提示文本
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0), // 内边距
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _whisperDetailController.sendMsg,
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => AnimatedSize(
              curve: Curves.linear,
              duration: const Duration(milliseconds: 200),
              child: SizedBox(
                width: double.infinity,
                height: toolbarType.value == 'input'
                    ? keyboardHeight
                    : toolbarType.value == 'emote'
                        ? emoteHeight
                        : 0,
                child: EmotePanel(
                  onChoose: (package, emote) => onChooseEmote(package, emote),
                ),
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
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
