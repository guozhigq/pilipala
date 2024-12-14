import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/dynamic_card.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/no_data.dart';
import 'package:pilipala/models/dynamics/result.dart';
import 'package:pilipala/pages/dynamics/widgets/dynamic_panel.dart';

import 'controller.dart';

class SearchDynamicPage extends StatefulWidget {
  const SearchDynamicPage({
    super.key,
    required this.searchKeyWord,
    required this.controller,
  });

  final String searchKeyWord;
  final MemberSearchController controller;

  @override
  State<SearchDynamicPage> createState() => _SearchDynamicPageState();
}

class _SearchDynamicPageState extends State<SearchDynamicPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future _futureBuilderFuture;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _futureBuilderFuture = widget.controller.searchDynamic();
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
          EasyThrottle.throttle('search_dynamic', const Duration(seconds: 1),
              () {
            widget.controller.onLoad();
          });
        }
      },
    );
    widget.controller.searchKeyWord.listen((p0) {
      if (context.mounted) {
        setState(() {
          _futureBuilderFuture = widget.controller.searchDynamic();
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
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          FutureBuilder(
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map? data = snapshot.data;
                if (data != null && data['status']) {
                  RxList<DynamicItemModel> list = widget.controller.dynamicList;
                  return Obx(
                    () => list.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                bool isLastItem = index == list.length;
                                double bottom =
                                    MediaQuery.paddingOf(context).bottom;
                                if (isLastItem) {
                                  return Container(
                                    height: bottom + 60,
                                    padding: EdgeInsets.only(bottom: bottom),
                                    child: Center(
                                      child: Obx(
                                        () => Text(
                                          widget.controller.loadingDynamicText
                                              .value,
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
                                  return DynamicPanel(item: list[index]);
                                }
                              },
                              childCount: list.length + 1,
                            ),
                          )
                        : const NoData(),
                  );
                } else {
                  return HttpError(
                    errMsg: data?['msg'] ?? '请求异常',
                    fn: () => setState(() {
                      _futureBuilderFuture = widget.controller.searchDynamic();
                    }),
                  );
                }
              } else {
                return skeleton();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget skeleton() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return const DynamicCardSkeleton();
      }, childCount: 5),
    );
  }
}
