import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/pages/follow_search/index.dart';

import '../follow/widgets/follow_item.dart';

class FollowSearchPage extends StatefulWidget {
  const FollowSearchPage({super.key});

  @override
  State<FollowSearchPage> createState() => _FollowSearchPageState();
}

class _FollowSearchPageState extends State<FollowSearchPage> {
  final FollowSearchController _followSearchController =
      Get.put(FollowSearchController());
  late Future? _futureBuilder;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _futureBuilder = _followSearchController.searchFollow();
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle(
              'my-throttler', const Duration(milliseconds: 500), () {
            _followSearchController.onLoad();
          });
        }
      },
    );
  }

  void reRequest() {
    setState(() {
      _futureBuilder = _followSearchController.searchFollow();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: reRequest,
            icon: const Icon(CupertinoIcons.search, size: 22),
          ),
          const SizedBox(width: 6),
        ],
        title: TextField(
          autofocus: true,
          focusNode: _followSearchController.searchFocusNode,
          controller: _followSearchController.controller.value,
          textInputAction: TextInputAction.search,
          onChanged: (value) => _followSearchController.onChange(value),
          decoration: InputDecoration(
            hintText: _followSearchController.hintText,
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                size: 22,
                color: Theme.of(context).colorScheme.outline,
              ),
              onPressed: () => _followSearchController.onClear(),
            ),
          ),
          onSubmitted: (String value) => reRequest(),
        ),
      ),
      body: FutureBuilder(
          future: _futureBuilder,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data;
              if (data == null) {
                return CustomScrollView(
                  slivers: [
                    HttpError(errMsg: snapshot.data['msg'], fn: reRequest)
                  ],
                );
              }
              if (data['status']) {
                RxList followList = _followSearchController.followList;
                return Obx(
                  () => followList.isNotEmpty
                      ? ListView.builder(
                          controller: scrollController,
                          itemCount: followList.length,
                          itemBuilder: ((context, index) {
                            return FollowItem(
                              item: followList[index],
                            );
                          }),
                        )
                      : CustomScrollView(
                          slivers: [HttpError(errMsg: '未搜索到结果', fn: reRequest)],
                        ),
                );
              } else {
                return CustomScrollView(
                  slivers: [
                    HttpError(errMsg: snapshot.data['msg'], fn: reRequest)
                  ],
                );
              }
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}
