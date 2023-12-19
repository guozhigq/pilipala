import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/pages/member/index.dart';
import 'package:pilipala/utils/utils.dart';

import 'widgets/conis.dart';
import 'widgets/profile.dart';
import 'widgets/seasons.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage>
    with SingleTickerProviderStateMixin {
  late String heroTag;
  late MemberController _memberController;
  late Future _futureBuilderFuture;
  late Future _memberSeasonsFuture;
  late Future _memberCoinsFuture;
  final ScrollController _extendNestCtr = ScrollController();
  final StreamController<bool> appbarStream = StreamController<bool>();
  late int mid;

  @override
  void initState() {
    super.initState();
    mid = int.parse(Get.parameters['mid']!);
    heroTag = Get.arguments['heroTag'] ?? Utils.makeHeroTag(mid);
    _memberController = Get.put(MemberController(), tag: heroTag);
    _futureBuilderFuture = _memberController.getInfo();
    _memberSeasonsFuture = _memberController.getMemberSeasons();
    _memberCoinsFuture = _memberController.getRecentCoinVideo();
    _extendNestCtr.addListener(
      () {
        double offset = _extendNestCtr.position.pixels;
        if (offset > 100) {
          appbarStream.add(true);
        } else {
          appbarStream.add(false);
        }
      },
    );
  }

  @override
  void dispose() {
    _extendNestCtr.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: Column(
        children: [
          AppBar(
            title: StreamBuilder(
              stream: appbarStream.stream,
              initialData: false,
              builder: (context, AsyncSnapshot snapshot) {
                return AnimatedOpacity(
                  opacity: snapshot.data ? 1 : 0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 500),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => NetworkImgLayer(
                              width: 35,
                              height: 35,
                              type: 'avatar',
                              src: _memberController.face.value,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Obx(
                            () => Text(
                              _memberController.memberInfo.value.name ?? '',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                onPressed: () => Get.toNamed(
                    '/memberSearch?mid=${Get.parameters['mid']}&uname=${_memberController.memberInfo.value.name!}'),
                icon: const Icon(Icons.search_outlined),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  if (_memberController.ownerMid != _memberController.mid) ...[
                    PopupMenuItem(
                      onTap: () => _memberController.blockUser(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.block, size: 19),
                          const SizedBox(width: 10),
                          Text(_memberController.attribute.value != 128
                              ? '加入黑名单'
                              : '移除黑名单'),
                        ],
                      ),
                    )
                  ],
                  PopupMenuItem(
                    onTap: () => _memberController.shareUser(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.share_outlined, size: 19),
                        const SizedBox(width: 10),
                        Text(_memberController.ownerMid != _memberController.mid
                            ? '分享UP主'
                            : '分享我的主页'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _extendNestCtr,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 20,
                ),
                child: Column(
                  children: [
                    profileWidget(),

                    /// 动态链接
                    ListTile(
                      onTap: _memberController.pushDynamicsPage,
                      title: const Text('Ta的动态'),
                      trailing:
                          const Icon(Icons.arrow_forward_outlined, size: 19),
                    ),

                    /// 视频
                    ListTile(
                      onTap: _memberController.pushArchivesPage,
                      title: const Text('Ta的投稿'),
                      trailing:
                          const Icon(Icons.arrow_forward_outlined, size: 19),
                    ),

                    /// 专栏
                    ListTile(
                      onTap: () {},
                      title: const Text('Ta的专栏'),
                    ),
                    MediaQuery.removePadding(
                      removeTop: true,
                      removeBottom: true,
                      context: context,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: StyleString.safeSpace,
                          right: StyleString.safeSpace,
                        ),
                        child: FutureBuilder(
                          future: _memberSeasonsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data == null) {
                                return const SizedBox();
                              }
                              if (snapshot.data['status']) {
                                Map data = snapshot.data as Map;
                                if (data['data'].seasonsList.isEmpty) {
                                  return commenWidget('用户没有设置专栏');
                                } else {
                                  return MemberSeasonsPanel(data: data['data']);
                                }
                              } else {
                                // 请求错误
                                return const SizedBox();
                              }
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ),

                    /// 收藏

                    /// 追番
                    /// 最近投币
                    Obx(
                      () => _memberController.recentCoinsList.isNotEmpty
                          ? ListTile(
                              onTap: () {},
                              title: const Text('最近投币的视频'),
                              // trailing: const Icon(Icons.arrow_forward_outlined,
                              //     size: 19),
                            )
                          : const SizedBox(),
                    ),
                    MediaQuery.removePadding(
                      removeTop: true,
                      removeBottom: true,
                      context: context,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: StyleString.safeSpace,
                          right: StyleString.safeSpace,
                        ),
                        child: FutureBuilder(
                          future: _memberCoinsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data == null) {
                                return const SizedBox();
                              }
                              if (snapshot.data['status']) {
                                Map data = snapshot.data as Map;
                                return MemberCoinsPanel(data: data['data']);
                              } else {
                                // 请求错误
                                return const SizedBox();
                              }
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ),
                    // 最近点赞
                    // ListTile(
                    //   onTap: () {},
                    //   title: const Text('最近点赞的视频'),
                    //   trailing:
                    //       const Icon(Icons.arrow_forward_outlined, size: 19),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget profileWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, bottom: 20),
      child: FutureBuilder(
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map data = snapshot.data!;
            if (data['status']) {
              return Obx(
                () => Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfilePanel(ctr: _memberController),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Flexible(
                                child: Text(
                              _memberController.memberInfo.value.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            )),
                            const SizedBox(width: 2),
                            if (_memberController.memberInfo.value.sex == '女')
                              const Icon(
                                FontAwesomeIcons.venus,
                                size: 14,
                                color: Colors.pink,
                              ),
                            if (_memberController.memberInfo.value.sex == '男')
                              const Icon(
                                FontAwesomeIcons.mars,
                                size: 14,
                                color: Colors.blue,
                              ),
                            const SizedBox(width: 4),
                            Image.asset(
                              'assets/images/lv/lv${_memberController.memberInfo.value.level}.png',
                              height: 11,
                            ),
                            const SizedBox(width: 6),
                            if (_memberController
                                        .memberInfo.value.vip!.status ==
                                    1 &&
                                _memberController.memberInfo.value.vip!
                                        .label!['img_label_uri_hans'] !=
                                    '') ...[
                              Image.network(
                                _memberController.memberInfo.value.vip!
                                    .label!['img_label_uri_hans'],
                                height: 20,
                              ),
                            ] else if (_memberController
                                        .memberInfo.value.vip!.status ==
                                    1 &&
                                _memberController.memberInfo.value.vip!
                                        .label!['img_label_uri_hans_static'] !=
                                    '') ...[
                              Image.network(
                                _memberController.memberInfo.value.vip!
                                    .label!['img_label_uri_hans_static'],
                                height: 20,
                              ),
                            ]
                          ],
                        ),
                        if (_memberController
                                .memberInfo.value.official!['title'] !=
                            '') ...[
                          const SizedBox(height: 6),
                          Text.rich(
                            maxLines: 2,
                            TextSpan(
                              text: _memberController
                                          .memberInfo.value.official!['role'] ==
                                      1
                                  ? '个人认证：'
                                  : '企业认证：',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              children: [
                                TextSpan(
                                  text: _memberController
                                      .memberInfo.value.official!['title'],
                                ),
                              ],
                            ),
                            softWrap: true,
                          ),
                        ],
                        const SizedBox(height: 6),
                        if (_memberController.memberInfo.value.sign != '')
                          SelectableText(
                            _memberController.memberInfo.value.sign!,
                          ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          } else {
            // 骨架屏
            return ProfilePanel(ctr: _memberController, loadingStatus: true);
          }
        },
      ),
    );
  }

  Widget commenWidget(msg) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 30,
      ),
      child: Center(
        child: Text(
          msg,
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Theme.of(context).colorScheme.outline),
        ),
      ),
    );
  }
}
