import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/badge.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/http/search.dart';
import 'package:pilipala/http/user.dart';
import 'package:pilipala/models/video/later.dart';
import 'package:pilipala/utils/utils.dart';

class MediaListPanel extends StatefulWidget {
  const MediaListPanel({
    this.sheetHeight,
    required this.mediaList,
    this.changeMediaList,
    this.panelTitle,
    this.bvid,
    required this.mediaId,
    this.hasMore = false,
    required this.type,
    super.key,
  });

  final double? sheetHeight;
  final List<MediaVideoItemModel> mediaList;
  final Function? changeMediaList;
  final String? panelTitle;
  final String? bvid;
  final int mediaId;
  final bool hasMore;
  final int type;

  @override
  State<MediaListPanel> createState() => _MediaListPanelState();
}

class _MediaListPanelState extends State<MediaListPanel> {
  RxList<MediaVideoItemModel> mediaList = <MediaVideoItemModel>[].obs;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    mediaList.value = widget.mediaList;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (widget.hasMore) {
          EasyThrottle.throttle(
              'queryFollowDynamic', const Duration(seconds: 1), () {
            loadMore();
          });
        }
      }
    });
  }

  void loadMore() async {
    var res = await UserHttp.getMediaList(
      type: widget.type,
      bizId: widget.mediaId,
      ps: 20,
      oid: mediaList.last.id,
    );
    if (res['status']) {
      if (res['data'].isNotEmpty) {
        mediaList.addAll(res['data']);
      }
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.sheetHeight,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          AppBar(
            toolbarHeight: 45,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                widget.panelTitle ?? '稍后再看',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 14),
            ],
          ),
          Expanded(
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              child: Obx(
                () => ListView.builder(
                  controller: _scrollController,
                  itemCount: mediaList.length,
                  itemBuilder: ((context, index) {
                    var item = mediaList[index];
                    return InkWell(
                      onTap: () async {
                        String bvid = item.bvid!;
                        int? aid = item.id;
                        String cover = item.cover ?? '';
                        final int cid =
                            await SearchHttp.ab2c(aid: aid, bvid: bvid);
                        widget.changeMediaList?.call(bvid, cid, aid, cover);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints boxConstraints) {
                            const double width = 120;
                            return Container(
                              constraints: const BoxConstraints(minHeight: 88),
                              height: width / StyleString.aspectRatio,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  AspectRatio(
                                    aspectRatio: StyleString.aspectRatio,
                                    child: LayoutBuilder(
                                      builder: (BuildContext context,
                                          BoxConstraints boxConstraints) {
                                        final double maxWidth =
                                            boxConstraints.maxWidth;
                                        final double maxHeight =
                                            boxConstraints.maxHeight;
                                        return Stack(
                                          children: [
                                            NetworkImgLayer(
                                              src: item.cover ?? '',
                                              width: maxWidth,
                                              height: maxHeight,
                                            ),
                                            PBadge(
                                              text: Utils.timeFormat(
                                                  item.duration!),
                                              right: 6.0,
                                              bottom: 6.0,
                                              type: 'gray',
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 6, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.title as String,
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: item.bvid == widget.bvid
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : null,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            item.upper?.name as String,
                                            style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium!
                                                  .fontSize,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              StatView(
                                                  view: item.cntInfo!['play']
                                                      as int),
                                              const SizedBox(width: 8),
                                              StatDanMu(
                                                  danmu:
                                                      item.cntInfo!['danmaku']
                                                          as int),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
