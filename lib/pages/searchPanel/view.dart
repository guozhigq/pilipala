import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/video_card_h.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/live_card.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';
import 'package:pilipala/models/common/search_type.dart';

import 'controller.dart';
import 'widgets/userPanel.dart';

class SearchPanel extends StatefulWidget {
  String? keyword;
  SearchType? searchType;
  SearchPanel({required this.keyword, required this.searchType, Key? key})
      : super(key: key);

  @override
  State<SearchPanel> createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel>
    with AutomaticKeepAliveClientMixin {
  late SearchPanelController? _searchPanelController;

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
        tag: widget.searchType!.type);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _searchPanelController!.onRefresh();
      },
      child: FutureBuilder(
        future: _searchPanelController!.onSearch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map data = snapshot.data;
            if (data['status']) {
              return Obx(
                () => ListView.builder(
                  controller: _searchPanelController!.scrollController,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false,
                  itemCount: _searchPanelController!.resultList.length,
                  itemBuilder: (context, index) {
                    var i = _searchPanelController!.resultList[index];
                    switch (widget.searchType) {
                      case SearchType.video:
                        return VideoCardH(videoItem: i);
                      case SearchType.bili_user:
                        return UserPanel(userItem: i);
                      case SearchType.live_room:
                        return LiveCard(liveItem: i);
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              );
            } else {
              return HttpError(
                errMsg: data['msg'],
                fn: () => setState(() {}),
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
