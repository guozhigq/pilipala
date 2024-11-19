// ignore_for_file: invalid_use_of_protected_member

import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/media_bangumi.dart';
import 'package:pilipala/common/skeleton/user_list.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/common/search_type.dart';

import 'controller.dart';
import 'widgets/article_panel.dart';
import 'widgets/live_panel.dart';
import 'widgets/media_bangumi_panel.dart';
import 'widgets/user_panel.dart';
import 'widgets/video_panel.dart';

class SearchPanel extends StatefulWidget {
  final String? keyword;
  final SearchType? searchType;
  final String? tag;
  const SearchPanel(
      {required this.keyword, required this.searchType, this.tag, Key? key})
      : super(key: key);

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel>
    with AutomaticKeepAliveClientMixin {
  late SearchPanelController _searchPanelController;

  late Future _futureBuilderFuture;
  late ScrollController scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchPanelController = Get.put(
      SearchPanelController(
        keyword: widget.keyword,
        searchType: widget.searchType,
      ),
      tag: widget.searchType!.type + widget.keyword!,
    );

    /// 专栏默认排序
    if (widget.searchType == SearchType.article) {
      _searchPanelController.order.value = 'totalrank';
    }
    scrollController = _searchPanelController.scrollController;
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        EasyThrottle.throttle('history', const Duration(seconds: 1), () {
          _searchPanelController.onSearch(type: 'onLoad');
        });
      }
    });
    _futureBuilderFuture = _searchPanelController.onSearch();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        await _searchPanelController.onRefresh();
      },
      child: FutureBuilder(
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map? data = snapshot.data;
            if (data != null && data['status']) {
              var ctr = _searchPanelController;
              RxList list = ctr.resultList;
              if (list.isNotEmpty) {
                return Obx(() {
                  switch (widget.searchType) {
                    case SearchType.video:
                      return SearchVideoPanel(
                        ctr: _searchPanelController,
                        list: list.value,
                      );
                    case SearchType.media_bangumi:
                      return searchMbangumiPanel(context, ctr, list);
                    case SearchType.bili_user:
                      return searchUserPanel(context, ctr, list);
                    case SearchType.live_room:
                      return searchLivePanel(context, ctr, list);
                    case SearchType.article:
                      return SearchArticlePanel(
                        ctr: _searchPanelController,
                        list: list.value,
                      );
                    default:
                      return const SizedBox();
                  }
                });
              } else {
                return HttpError(
                  errMsg: '没有数据',
                  isShowBtn: false,
                  fn: () => {},
                  isInSliver: false,
                );
              }
            } else {
              return HttpError(
                errMsg: data?['msg'] ?? '请求异常',
                fn: () {
                  setState(() {
                    _futureBuilderFuture = _searchPanelController.onRefresh();
                  });
                },
                isInSliver: false,
              );
            }
          } else {
            // 骨架屏
            return ListView.builder(
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              itemCount: 15,
              itemBuilder: (context, index) {
                switch (widget.searchType) {
                  case SearchType.video:
                    return const VideoCardHSkeleton();
                  case SearchType.media_bangumi:
                    return const MediaBangumiSkeleton();
                  case SearchType.bili_user:
                    return const UserListSkeleton();
                  case SearchType.live_room:
                    return const VideoCardHSkeleton();
                  default:
                    return const VideoCardHSkeleton();
                }
              },
            );
          }
        },
      ),
    );
  }
}
