import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/common/widgets/no_data.dart';
import 'package:pilipala/models/msg/at.dart';
import 'package:pilipala/pages/message/utils/index.dart';
import 'package:pilipala/utils/utils.dart';

import 'controller.dart';

class MessageAtPage extends StatefulWidget {
  const MessageAtPage({super.key});

  @override
  State<MessageAtPage> createState() => _MessageAtPageState();
}

class _MessageAtPageState extends State<MessageAtPage> {
  final MessageAtController _messageAtCtr = Get.put(MessageAtController());
  late Future _futureBuilderFuture;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _messageAtCtr.queryMessageAt();
    scrollController.addListener(
      () async {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle('follow', const Duration(seconds: 1), () {
            _messageAtCtr.queryMessageAt(type: 'onLoad');
          });
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('@我的')),
      body: RefreshIndicator(
        onRefresh: () async {
          await _messageAtCtr.queryMessageAt(type: 'init');
        },
        child: FutureBuilder(
          future: _futureBuilderFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final Map<String, dynamic>? data = snapshot.data;
              if (data != null && data['status']) {
                final RxList<MessageAtItems> atItems = _messageAtCtr.atItems;
                return Obx(
                  () => atItems.isEmpty
                      ? const CustomScrollView(slivers: [NoData()])
                      : ListView.separated(
                          controller: scrollController,
                          itemBuilder: (context, index) => AtItem(
                            item: atItems[index],
                            index: index,
                            messageAtCtr: _messageAtCtr,
                          ),
                          itemCount: atItems.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              indent: 66,
                              endIndent: 14,
                              height: 1,
                              color: Colors.grey.withOpacity(0.1),
                            );
                          },
                        ),
                );
              } else {
                // 请求错误
                return HttpError(
                  errMsg: data?['msg'] ?? '请求异常',
                  fn: () {
                    setState(() {
                      _futureBuilderFuture = _messageAtCtr.queryMessageAt();
                    });
                  },
                  isInSliver: false,
                );
              }
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

class AtItem extends StatelessWidget {
  final MessageAtItems item;
  final int index;
  final MessageAtController messageAtCtr;

  const AtItem({
    super.key,
    required this.item,
    required this.index,
    required this.messageAtCtr,
  });

  @override
  Widget build(BuildContext context) {
    Color outline = Theme.of(context).colorScheme.outline;
    final User user = item.user!;
    final String heroTag = Utils.makeHeroTag(user.mid);
    final Uri uri = Uri.parse(item.item!.uri!);

    /// bilibili://
    final Uri nativeUri = Uri.parse(item.item!.nativeUri!);
    final String type = item.item!.type!;

    return InkWell(
      onTap: () async {
        MessageUtils.onClickMessage(context, uri, nativeUri, type, null);
      },
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed('/member?mid=${item.user!.mid}',
                    arguments: {'face': item.user!.avatar, 'heroTag': heroTag});
              },
              child: Hero(
                tag: heroTag,
                child: NetworkImgLayer(
                  width: 42,
                  height: 42,
                  type: 'avatar',
                  src: item.user!.avatar,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(text: item.user!.nickname!),
                    const TextSpan(text: ' '),
                    if (item.item!.type! == 'reply')
                      TextSpan(
                        text: '在评论中@了我',
                        style: TextStyle(color: outline),
                      ),
                  ])),
                  const SizedBox(height: 6),
                  Text(item.item!.sourceContent!),
                  const SizedBox(height: 4),
                  Text(
                    Utils.dateFormat(item.atTime!, formatType: 'detail'),
                    style: TextStyle(color: outline),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 25),
            if (item.item!.type! == 'reply')
              Container(
                width: 60,
                height: 80,
                padding: const EdgeInsets.all(4),
                child: Text(
                  item.item!.title!,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 12, letterSpacing: 0.3),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
