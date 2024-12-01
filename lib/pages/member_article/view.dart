import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/skeleton/skeleton.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/common/widgets/no_data.dart';
import 'package:pilipala/utils/utils.dart';

import 'controller.dart';

class MemberArticlePage extends StatefulWidget {
  const MemberArticlePage({super.key});

  @override
  State<MemberArticlePage> createState() => _MemberArticlePageState();
}

class _MemberArticlePageState extends State<MemberArticlePage> {
  late MemberArticleController _memberArticleController;
  late Future _futureBuilderFuture;
  late ScrollController scrollController;
  late int mid;

  @override
  void initState() {
    super.initState();
    mid = int.parse(Get.parameters['mid']!);
    final String heroTag = Utils.makeHeroTag(mid);
    _memberArticleController = Get.put(MemberArticleController(), tag: heroTag);
    _futureBuilderFuture = _memberArticleController.getMemberArticle('init');
    scrollController = _memberArticleController.scrollController;

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      EasyThrottle.throttle(
          'member_archives', const Duration(milliseconds: 500), () {
        _memberArticleController.getMemberArticle('onLoad');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            '${_memberArticleController.isOwner.value ? '我' : 'Ta'}的图文',
          ),
        ),
      ),
      body: FutureBuilder(
        future: _futureBuilderFuture,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data != null) {
              return _buildContent(snapshot.data as Map);
            } else {
              return _buildError(snapshot.data['msg']);
            }
          } else {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return _buildSkeleton();
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildContent(Map data) {
    RxList list = _memberArticleController.articleList;
    if (data['status']) {
      return Obx(
        () => list.isNotEmpty
            ? ListView.separated(
                controller: scrollController,
                itemCount: list.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    height: 10,
                    color: Theme.of(context).dividerColor.withOpacity(0.15),
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return _buildListItem(list[index]);
                },
              )
            : const CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                slivers: [
                  NoData(),
                ],
              ),
      );
    } else {
      return _buildError(data['msg']);
    }
  }

  Widget _buildListItem(dynamic item) {
    return ListTile(
      onTap: () {
        Get.toNamed('/opus', parameters: {
          'title': item.content,
          'id': item.opusId,
          'articleType': 'opus',
        });
      },
      leading: item?.cover != null
          ? NetworkImgLayer(
              width: 50,
              height: 50,
              type: 'emote',
              src: item?.cover?['url'] ?? '',
            )
          : const SizedBox(),
      title: Text(
        item.content,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          '${item.stat["like"]}人点赞',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
    );
  }

  Widget _buildError(String errMsg) {
    return HttpError(
      errMsg: errMsg,
      fn: () {},
      isInSliver: false,
    );
  }

  Widget _buildSkeleton() {
    return Skeleton(
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onInverseSurface,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        title: Container(
          height: 16,
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
        subtitle: Container(
          height: 11,
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
      ),
    );
  }
}
