import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/models/common/search_type.dart';

import 'controller.dart';
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
  late SearchPanelController? _searchPanelController;

  bool _isLoadingMore = false;
  late Future _futureBuilderFuture;

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
      tag: widget.searchType!.type + widget.tag!,
    );
    ScrollController scrollController =
        _searchPanelController!.scrollController;
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        if (!_isLoadingMore) {
          _isLoadingMore = true;
          await _searchPanelController!.onSearch(type: 'onLoad');
          _isLoadingMore = false;
        }
      }
    });
    _futureBuilderFuture = _searchPanelController!.onSearch();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        await _searchPanelController!.onRefresh();
      },
      child: FutureBuilder(
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map data = snapshot.data;
            var ctr = _searchPanelController;
            List list = ctr!.resultList;
            if (data['status']) {
              return Obx(() {
                switch (widget.searchType) {
                  case SearchType.video:
                    return searchVideoPanel(context, ctr, list);
                  case SearchType.media_bangumi:
                    return searchMbangumiPanel(context, ctr, list);
                  case SearchType.bili_user:
                    return searchUserPanel(context, ctr, list);
                  case SearchType.live_room:
                    return searchLivePanel(context, ctr, list);
                  default:
                    return const SizedBox();
                }
              });
            } else {
              return CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  HttpError(
                    errMsg: data['msg'],
                    fn: () => setState(() {}),
                  ),
                ],
              );
            }
          } else {
            // 骨架屏
            return ListView.builder(
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: false,
              itemCount: 15,
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
