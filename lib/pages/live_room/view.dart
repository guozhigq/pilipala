import 'dart:io';

import 'package:floating/floating.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/live/message.dart';
import 'package:pilipala/plugin/pl_player/index.dart';

import 'controller.dart';
import 'widgets/bottom_control.dart';

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key});

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage>
    with TickerProviderStateMixin {
  final LiveRoomController _liveRoomController = Get.put(LiveRoomController());
  PlPlayerController? plPlayerController;
  late Future? _futureBuilder;
  late Future? _futureBuilderFuture;

  bool isShowCover = true;
  bool isPlay = true;
  Floating? floating;
  final ScrollController _scrollController = ScrollController();
  late AnimationController fabAnimationCtr;
  bool _shouldAutoScroll = true;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      floating = Floating();
    }
    videoSourceInit();
    _futureBuilderFuture = _liveRoomController.queryLiveInfo();
    // 监听滚动事件
    _scrollController.addListener(_onScroll);
    fabAnimationCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0.0,
    );
  }

  Future<void> videoSourceInit() async {
    _futureBuilder = _liveRoomController.queryLiveInfoH5();
    plPlayerController = _liveRoomController.plPlayerController;
  }

  void _onScroll() {
    // 反向时，展示按钮
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _shouldAutoScroll = false;
      fabAnimationCtr.forward();
    } else {
      _shouldAutoScroll = true;
      fabAnimationCtr.reverse();
    }
  }

  // 监听messageList的变化，自动滚动到底部
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _liveRoomController.messageList.listen((_) {
      if (_shouldAutoScroll) {
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController
          .animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      )
          .then((value) {
        _shouldAutoScroll = true;
        // fabAnimationCtr.forward();
      });
    }
  }

  @override
  void dispose() {
    plPlayerController!.dispose();
    if (floating != null) {
      floating!.dispose();
    }
    _scrollController.dispose();
    fabAnimationCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget videoPlayerPanel = FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data['status']) {
          return PLVideoPlayer(
            controller: plPlayerController!,
            bottomControl: BottomControl(
              controller: plPlayerController,
              liveRoomCtr: _liveRoomController,
              floating: floating,
              onRefresh: () {
                setState(() {
                  _futureBuilderFuture = _liveRoomController.queryLiveInfo();
                });
              },
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );

    Widget childWhenDisabled = Scaffold(
      primary: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Obx(
            () => Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _liveRoomController
                              .roomInfoH5.value.roomInfo?.appBackground !=
                          '' &&
                      _liveRoomController
                              .roomInfoH5.value.roomInfo?.appBackground !=
                          null
                  ? Opacity(
                      opacity: 0.6,
                      child: NetworkImgLayer(
                        width: Get.width,
                        height: Get.height,
                        type: 'bg',
                        src: _liveRoomController
                                .roomInfoH5.value.roomInfo?.appBackground ??
                            '',
                      ),
                    )
                  : Opacity(
                      opacity: 0.6,
                      child: Image.asset(
                        'assets/images/live/default_bg.webp',
                        fit: BoxFit.cover,
                        // width: Get.width,
                        // height: Get.height,
                      ),
                    ),
            ),
          ),
          Column(
            children: [
              AppBar(
                centerTitle: false,
                titleSpacing: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                toolbarHeight:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 56
                        : 0,
                title: FutureBuilder(
                  future: _futureBuilder,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const SizedBox();
                    }
                    Map data = snapshot.data as Map;
                    if (data['status']) {
                      return Obx(
                        () => Row(
                          children: [
                            NetworkImgLayer(
                              width: 34,
                              height: 34,
                              type: 'avatar',
                              src: _liveRoomController
                                  .roomInfoH5.value.anchorInfo!.baseInfo!.face,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _liveRoomController.roomInfoH5.value
                                      .anchorInfo!.baseInfo!.uname!,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 1),
                                if (_liveRoomController
                                        .roomInfoH5.value.watchedShow !=
                                    null)
                                  Text(
                                    _liveRoomController.roomInfoH5.value
                                            .watchedShow!['text_large'] ??
                                        '',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              PopScope(
                canPop: plPlayerController?.isFullScreen.value != true,
                onPopInvoked: (bool didPop) {
                  if (plPlayerController?.isFullScreen.value == true) {
                    plPlayerController!.triggerFullScreen(status: false);
                  }
                  if (MediaQuery.of(context).orientation ==
                      Orientation.landscape) {
                    verticalScreen();
                  }
                },
                child: SizedBox(
                  width: Get.size.width,
                  height: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? Get.size.height
                      : Get.size.width * 9 / 16,
                  child: videoPlayerPanel,
                ),
              ),
              const SizedBox(height: 20),
              // 显示消息的列表
              buildMessageListUI(
                context,
                _liveRoomController,
                _scrollController,
              ),
              // 底部安全距离
              SizedBox(
                height: MediaQuery.of(context).padding.bottom + 20,
              )
            ],
          ),
          // 定位 快速滑动到底部
          Positioned(
            right: 20,
            bottom: MediaQuery.of(context).padding.bottom + 20,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 2),
                end: const Offset(0, 0),
              ).animate(CurvedAnimation(
                parent: fabAnimationCtr,
                curve: Curves.easeInOut,
              )),
              child: ElevatedButton.icon(
                onPressed: () {
                  _scrollToBottom();
                },
                icon: const Icon(Icons.keyboard_arrow_down), // 图标
                label: const Text('新消息'), // 文字
                style: ElevatedButton.styleFrom(
                  // primary: Colors.blue, // 按钮背景颜色
                  // onPrimary: Colors.white, // 按钮文字颜色
                  padding: const EdgeInsets.fromLTRB(14, 12, 20, 12), // 按钮内边距
                ),
              ),
            ),
          ),
        ],
      ),
    );
    if (Platform.isAndroid) {
      return PiPSwitcher(
        childWhenDisabled: childWhenDisabled,
        childWhenEnabled: videoPlayerPanel,
        floating: floating,
      );
    } else {
      return childWhenDisabled;
    }
  }
}

Widget buildMessageListUI(
  BuildContext context,
  LiveRoomController liveRoomController,
  ScrollController scrollController,
) {
  return Expanded(
    child: Obx(
      () => MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black,
                Colors.black,
              ],
              stops: [0.0, 0.1, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: ListView.builder(
            controller: scrollController,
            itemCount: liveRoomController.messageList.length,
            itemBuilder: (context, index) {
              final LiveMessageModel liveMsgItem =
                  liveRoomController.messageList[index];
              return Padding(
                padding: EdgeInsets.only(
                  top: index == 0 ? 40.0 : 4.0,
                  bottom: 4.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: '${liveMsgItem.userName}: ',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // 处理点击事件
                            print('Text clicked');
                          },
                      ),
                      TextSpan(
                        children: [
                          ...buildMessageTextSpan(context, liveMsgItem)
                        ],
                        // text: liveMsgItem.message,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

List<InlineSpan> buildMessageTextSpan(
  BuildContext context,
  LiveMessageModel liveMsgItem,
) {
  final List<InlineSpan> inlineSpanList = [];

  // 是否包含表情包
  if (liveMsgItem.emots == null) {
    // 没有表情包的消息
    inlineSpanList.add(
      TextSpan(
        text: liveMsgItem.message ?? '',
        style: const TextStyle(
          shadows: [
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Colors.black,
            ),
            Shadow(
              offset: Offset(-1.0, -1.0),
              blurRadius: 3.0,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  } else {
    // 有表情包的消息 使用正则匹配 表情包用图片渲染
    final List<String> emotsKeys = liveMsgItem.emots!.keys.toList();
    final RegExp pattern = RegExp(emotsKeys.map(RegExp.escape).join('|'));

    liveMsgItem.message?.splitMapJoin(
      pattern,
      onMatch: (Match match) {
        final emoteItem = liveMsgItem.emots![match.group(0)];
        if (emoteItem != null) {
          inlineSpanList.add(
            WidgetSpan(
              child: NetworkImgLayer(
                width: emoteItem['width'].toDouble(),
                height: emoteItem['height'].toDouble(),
                type: 'emote',
                src: emoteItem['url'],
              ),
            ),
          );
        }
        return '';
      },
      onNonMatch: (String nonMatch) {
        inlineSpanList.add(
          TextSpan(
            text: nonMatch,
            style: const TextStyle(
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Colors.black,
                ),
                Shadow(
                  offset: Offset(-1.0, -1.0),
                  blurRadius: 3.0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        );
        return nonMatch;
      },
    );
  }

  return inlineSpanList;
}
