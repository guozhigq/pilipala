import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pilipala/models/bangumi/info.dart';

class BangumiPanel extends StatefulWidget {
  final List<EpisodeItem> pages;
  final int? cid;
  final double? sheetHeight;
  final Function? changeFuc;

  const BangumiPanel({
    super.key,
    required this.pages,
    this.cid,
    this.sheetHeight,
    this.changeFuc,
  });

  @override
  State<BangumiPanel> createState() => _BangumiPanelState();
}

class _BangumiPanelState extends State<BangumiPanel> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.pages.indexWhere((e) => e.cid == widget.cid!);
  }

  void showBangumiPanel() {
    showBottomSheet(
      context: context,
      builder: (_) => Container(
        height: widget.sheetHeight,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            Container(
              height: 45,
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '合集（${widget.pages.length}）',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Theme.of(context).dividerColor.withOpacity(0.1),
            ),
            Expanded(
              child: Material(
                child: ListView.builder(
                  itemCount: widget.pages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        if (widget.pages[index].badge != null) {
                          SmartDialog.showToast('需要大会员');
                          return;
                        }
                        await widget.changeFuc!(
                          widget.pages[index].bvid,
                          widget.pages[index].cid,
                        );
                        currentIndex = index;
                        setState(() {});
                      },
                      dense: false,
                      title: Text(
                        widget.pages[index].longTitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: index == currentIndex
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      trailing: widget.pages[index].badge != null
                          ? Image.asset(
                              'assets/images/big-vip.png',
                              height: 20,
                            )
                          : const SizedBox(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('合集 '),
              Expanded(
                child: Text(
                  ' 正在播放：${widget.pages[currentIndex].longTitle}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 34,
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () => showBangumiPanel(),
                  child: Text(
                    '全${widget.pages.length}话',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.only(top: 7, bottom: 7),
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: Row(
              children: [
                for (int i = 0; i < widget.pages.length; i++) ...[
                  Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 10),
                    child: Material(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      borderRadius: BorderRadius.circular(6),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () async {
                          if (widget.pages[i].badge != null) {
                            SmartDialog.showToast('需要大会员');
                            return;
                          }
                          await widget.changeFuc!(
                            widget.pages[i].bvid,
                            widget.pages[i].cid,
                          );
                          currentIndex = i;
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (i == currentIndex) ...[
                                    Image.asset(
                                      'assets/images/live.gif',
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      height: 12,
                                    ),
                                    const SizedBox(width: 6)
                                  ],
                                  Text(
                                    '第${i + 1}话',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: i == currentIndex
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                  ),
                                  const SizedBox(width: 2),
                                  if (widget.pages[i].badge != null) ...[
                                    Image.asset(
                                      'assets/images/big-vip.png',
                                      height: 16,
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                widget.pages[i].longTitle!,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: i == currentIndex
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        )
      ],
    );
  }
}
