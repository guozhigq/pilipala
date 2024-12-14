import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/no_data.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';
import 'controller.dart';

class SearchArchivePage extends StatefulWidget {
  const SearchArchivePage({
    super.key,
    required this.searchKeyWord,
    required this.controller,
  });

  final String searchKeyWord;
  final MemberSearchController controller;

  @override
  State<SearchArchivePage> createState() => _SearchArchivePageState();
}

class _SearchArchivePageState extends State<SearchArchivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future _futureBuilderFuture;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _futureBuilderFuture = widget.controller.searchArchives();
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
          EasyThrottle.throttle('search_archive', const Duration(seconds: 1),
              () {
            widget.controller.onLoad();
          });
        }
      },
    );

    widget.controller.searchKeyWord.listen((p0) {
      if (context.mounted) {
        setState(() {
          _futureBuilderFuture = widget.controller.searchArchives();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: FutureBuilder(
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map? data = snapshot.data;
            if (data != null && data['status']) {
              return Obx(
                () => widget.controller.archiveList.isNotEmpty
                    ? ListView.builder(
                        controller: scrollController,
                        itemCount: widget.controller.archiveList.length + 1,
                        itemBuilder: (context, index) {
                          if (index == widget.controller.archiveList.length) {
                            return Container(
                              height: MediaQuery.paddingOf(context).bottom + 60,
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.paddingOf(context).bottom),
                              child: Center(
                                child: Obx(
                                  () => Text(
                                    widget.controller.loadingArchiveText.value,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline,
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return VideoCardH(
                                videoItem:
                                    widget.controller.archiveList[index]);
                          }
                        },
                      )
                    : const CustomScrollView(
                        slivers: <Widget>[
                          NoData(),
                        ],
                      ),
              );
            } else {
              return HttpError(
                errMsg: data?['msg'] ?? '请求异常',
                fn: () => setState(() {
                  _futureBuilderFuture = widget.controller.searchArchives();
                }),
                isInSliver: false,
              );
            }
          } else {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return const VideoCardHSkeleton();
              },
            );
          }
        },
      ),
    );
  }
}
