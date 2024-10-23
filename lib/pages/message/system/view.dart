import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/msg/system.dart';
import 'package:pilipala/pages/message/utils/index.dart';
import 'package:pilipala/utils/app_scheme.dart';
import 'controller.dart';

class MessageSystemPage extends StatefulWidget {
  const MessageSystemPage({super.key});

  @override
  State<MessageSystemPage> createState() => _MessageSystemPageState();
}

class _MessageSystemPageState extends State<MessageSystemPage> {
  final MessageSystemController _messageSystemCtr =
      Get.put(MessageSystemController());
  late Future _futureBuilderFuture;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _messageSystemCtr.queryAndProcessMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('系统通知'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _messageSystemCtr.queryAndProcessMessages();
        },
        child: FutureBuilder(
          future: _futureBuilderFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return const SizedBox();
              }
              if (snapshot.data['status']) {
                final systemItems = _messageSystemCtr.systemItems;
                return Obx(
                  () => ListView.separated(
                    controller: scrollController,
                    itemBuilder: (context, index) => SystemItem(
                      item: systemItems[index],
                      index: index,
                      messageSystemCtr: _messageSystemCtr,
                    ),
                    itemCount: systemItems.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        indent: 14,
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
                  errMsg: snapshot.data['msg'],
                  fn: () {
                    setState(() {
                      _futureBuilderFuture =
                          _messageSystemCtr.queryMessageSystem();
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

class SystemItem extends StatelessWidget {
  final MessageSystemModel item;
  final int index;
  final MessageSystemController messageSystemCtr;

  const SystemItem(
      {super.key,
      required this.item,
      required this.index,
      required this.messageSystemCtr});

  @override
  Widget build(BuildContext context) {
    // if (item.content is Map) {
    //   var res = MessageUtils().extractLinks(item.content['web']);
    //   print('res: $res');
    // } else {
    //   var res = MessageUtils().extractLinks(item.content);
    //   print('res: $res');
    // }
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title!,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            item.timeAt!,
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                buildContent(
                  context,
                  item.content is String ? item.content : item.content!['web']!,
                ),
              ],
            ),
          ),
          // if (item.content is String)
          //   Text(item.content)
          // else ...[
          //   Text(item.content!['web']!),
          // ]
        ],
      ),
    );
  }

  InlineSpan buildContent(
    BuildContext context,
    String content,
  ) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final List<InlineSpan> spanChilds = <InlineSpan>[];
    Map<String, dynamic> contentMap = MessageUtils().extractLinks(content);
    List<String> keys = contentMap.keys.toList();
    keys.removeWhere((element) => element == 'message');
    String patternStr = keys.join('|');
    RegExp regExp = RegExp(patternStr, caseSensitive: false);

    contentMap['message'].splitMapJoin(
      regExp,
      onMatch: (Match match) {
        if (!match.group(0)!.startsWith('BV')) {
          spanChilds.add(
            WidgetSpan(
              child: Icon(Icons.link, color: colorScheme.primary, size: 16),
            ),
          );
        }
        spanChilds.add(
          TextSpan(
            text: match.group(0),
            style: TextStyle(
              color: colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                PiliSchame.routePush(Uri.parse(contentMap[match.group(0)]));
              },
          ),
        );
        return '';
      },
      onNonMatch: (String text) {
        spanChilds.add(
          TextSpan(
            text: text,
          ),
        );
        return '';
      },
    );
    return TextSpan(
      children: spanChilds,
    );
  }
}
