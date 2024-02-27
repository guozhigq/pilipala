import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/emote/index.dart';
import 'package:pilipala/pages/whisper_detail/controller.dart';
import 'package:pilipala/utils/feed_back.dart';
import '../../utils/storage.dart';
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
  late double emoteHeight = 0.0;
  double keyboardHeight = 0.0; // 键盘高度
  String toolbarType = 'input';
  Box userInfoCache = GStrorage.userInfo;

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
        setState(() {
          toolbarType = 'input';
        });
      }
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 键盘高度
      final viewInsets = EdgeInsets.fromViewPadding(
          View.of(context).viewInsets, View.of(context).devicePixelRatio);
      _debouncer.run(() {
        if (mounted) {
          if (keyboardHeight == 0) {
            setState(() {
              emoteHeight = keyboardHeight =
                  keyboardHeight == 0.0 ? viewInsets.bottom : keyboardHeight;
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    replyContentFocusNode.removeListener(() {});
    super.dispose();
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 34,
                height: 34,
                child: IconButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (Set<MaterialState> states) {
                      return Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.6);
                    }),
                  ),
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
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
                    NetworkImgLayer(
                      width: 34,
                      height: 34,
                      type: 'avatar',
                      src: _whisperDetailController.face,
                    ),
                    const SizedBox(width: 6),
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
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            keyboardHeight = 0;
          });
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
                      : ListView.builder(
                          itemCount: messageList.length,
                          shrinkWrap: true,
                          reverse: true,
                          itemBuilder: (_, int i) {
                            if (i == 0) {
                              return Column(
                                children: [
                                  ChatItem(
                                      item: messageList[i],
                                      e_infos: _whisperDetailController.eInfos),
                                  const SizedBox(height: 12),
                                ],
                              );
                            } else {
                              return ChatItem(
                                  item: messageList[i],
                                  e_infos: _whisperDetailController.eInfos);
                            }
                          },
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
      // resizeToAvoidBottomInset: true,
      bottomNavigationBar: Container(
        width: double.infinity,
        height: MediaQuery.of(context).padding.bottom + 70 + keyboardHeight,
        padding: EdgeInsets.only(
          left: 8,
          right: 12,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 4,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IconButton(
                //   onPressed: () {},
                //   icon: Icon(
                //     Icons.add_circle_outline,
                //     color: Theme.of(context).colorScheme.outline,
                //   ),
                // ),
                IconButton(
                  onPressed: () {
                    // if (toolbarType == 'input') {
                    //   setState(() {
                    //     toolbarType = 'emote';
                    //   });
                    // }
                    // FocusScope.of(context).unfocus();
                  },
                  icon: Icon(
                    Icons.emoji_emotions_outlined,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.08),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: TextField(
                      readOnly: true,
                      style: Theme.of(context).textTheme.titleMedium,
                      controller: _replyContentController,
                      autofocus: false,
                      focusNode: replyContentFocusNode,
                      decoration: const InputDecoration(
                        border: InputBorder.none, // 移除默认边框
                        hintText: '开发中 ...', // 提示文本
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0), // 内边距
                      ),
                    ),
                  ),
                ),
                IconButton(
                  // onPressed: _whisperDetailController.sendMsg,
                  onPressed: null,
                  icon: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                // const SizedBox(width: 16),
              ],
            ),
            AnimatedSize(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                width: double.infinity,
                height: toolbarType == 'input' ? keyboardHeight : emoteHeight,
                child: EmotePanel(
                  onChoose: (package, emote) => {},
                ),
              ),
            ),
          ],
        ),
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
