import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/member/info.dart';
import 'package:pilipala/pages/member/index.dart';
import 'package:pilipala/utils/feed_back.dart';
import 'package:pilipala/utils/utils.dart';
import 'widgets/commen_widget.dart';
import 'widgets/conis.dart';
import 'widgets/like.dart';
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
  late Future _memberLikeFuture;
  final ScrollController _extendNestCtr = ScrollController();
  final StreamController<bool> appbarStream =
      StreamController<bool>.broadcast();
  late int mid;

  @override
  void initState() {
    super.initState();
    mid = int.tryParse(Get.parameters['mid']!) ?? -1;
    heroTag = Get.arguments['heroTag'] ?? Utils.makeHeroTag(mid);
    _memberController = Get.put(MemberController(), tag: heroTag);
    _futureBuilderFuture = _memberController.getInfo();
    _memberSeasonsFuture = _memberController.getMemberSeasons();
    _memberCoinsFuture = _memberController.getRecentCoinVideo();
    _memberLikeFuture = _memberController.getRecentLikeVideo();
    _extendNestCtr.addListener(
      () {
        final double offset = _extendNestCtr.position.pixels;
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
    appbarStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          stream: appbarStream.stream.distinct(),
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return AnimatedOpacity(
              opacity: snapshot.data ? 1 : 0,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 500),
              child: Row(
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
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (mid == -1) {
                SmartDialog.showToast('用户ID获取异常');
                return;
              }
              Get.toNamed(
                  '/memberSearch?mid=$mid&uname=${_memberController.memberInfo.value.name ?? ''}');
            },
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
      primary: true,
      body: ListView(
        controller: _extendNestCtr,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 20,
        ),
        children: [
          Obx(() {
            Rx<MemberInfoModel> memberInfo = _memberController.memberInfo;
            return memberInfo.value.silence != null &&
                    memberInfo.value.silence! == 1
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Text(
                      '该账号封禁中',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontSize: 16,
                      ),
                    ),
                  )
                : const SizedBox();
          }),
          profileWidget(),

          /// 动态链接
          Obx(
            () => ListTile(
              onTap: _memberController.pushDynamicsPage,
              title: Text('${_memberController.isOwner.value ? '我' : 'Ta'}的动态'),
              trailing: const Icon(Icons.arrow_forward_outlined, size: 19),
            ),
          ),

          /// 视频
          Obx(
            () => ListTile(
              onTap: _memberController.pushArchivesPage,
              title: Text('${_memberController.isOwner.value ? '我' : 'Ta'}的投稿'),
              trailing: const Icon(Icons.arrow_forward_outlined, size: 19),
            ),
          ),

          /// 他的收藏夹
          Obx(
            () => ListTile(
              onTap: _memberController.pushfavPage,
              title: Text('${_memberController.isOwner.value ? '我' : 'Ta'}的收藏'),
              trailing: const Icon(Icons.arrow_forward_outlined, size: 19),
            ),
          ),

          /// 专栏
          Obx(
            () => ListTile(
              onTap: _memberController.pushArticlePage,
              title: Text('${_memberController.isOwner.value ? '我' : 'Ta'}的专栏'),
              trailing: const Icon(Icons.arrow_forward_outlined, size: 19),
            ),
          ),

          /// 合集
          Obx(
            () => ListTile(
              title: Text('${_memberController.isOwner.value ? '我' : 'Ta'}的合集'),
            ),
          ),
          MediaQuery.removePadding(
            removeTop: true,
            removeBottom: true,
            context: context,
            child: FutureBuilder(
              future: _memberSeasonsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return const SizedBox();
                  }
                  if (snapshot.data['status']) {
                    Map data = snapshot.data as Map;
                    if (data['data'].seasonsList.isEmpty) {
                      return const CommenWidget(msg: '用户没有设置合集');
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

          /// 追番
          /// 最近投币
          Obx(
            () => _memberController.recentCoinsList.isNotEmpty
                ? const ListTile(title: Text('最近投币的视频'))
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
                  if (snapshot.connectionState == ConnectionState.done) {
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

          /// 最近点赞
          Obx(
            () => _memberController.recentLikeList.isNotEmpty
                ? const ListTile(title: Text('最近点赞的视频'))
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
                future: _memberLikeFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const SizedBox();
                    }
                    if (snapshot.data['status']) {
                      Map data = snapshot.data as Map;
                      return MemberLikePanel(data: data['data']);
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
            Map? data = snapshot.data;
            if (data != null && data['status']) {
              Rx<MemberInfoModel> memberInfo = _memberController.memberInfo;
              return Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfilePanel(ctr: _memberController),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Flexible(
                            child: Text(
                          memberInfo.value.name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: memberInfo.value.vip!.nicknameColor !=
                                          null
                                      ? Color(_memberController
                                          .memberInfo.value.vip!.nicknameColor!)
                                      : null),
                        )),
                        const SizedBox(width: 2),
                        if (memberInfo.value.sex == '女')
                          const Icon(
                            FontAwesomeIcons.venus,
                            size: 14,
                            color: Colors.pink,
                          ),
                        if (memberInfo.value.sex == '男')
                          const Icon(
                            FontAwesomeIcons.mars,
                            size: 14,
                            color: Colors.blue,
                          ),
                        const SizedBox(width: 4),
                        Image.asset(
                          'assets/images/lv/lv${memberInfo.value.level}.png',
                          height: 11,
                        ),
                        const SizedBox(width: 6),
                        if (memberInfo.value.vip!.status == 1 &&
                            memberInfo
                                    .value.vip!.label!['img_label_uri_hans'] !=
                                '') ...[
                          Image.network(
                            memberInfo.value.vip!.label!['img_label_uri_hans'],
                            height: 20,
                          ),
                        ] else if (memberInfo.value.vip!.status == 1 &&
                            memberInfo.value.vip!
                                    .label!['img_label_uri_hans_static'] !=
                                '') ...[
                          Image.network(
                            memberInfo
                                .value.vip!.label!['img_label_uri_hans_static'],
                            height: 20,
                          ),
                        ],
                      ],
                    ),
                    if (memberInfo.value.official!['title'] != '') ...[
                      const SizedBox(height: 6),
                      Text(
                        memberInfo.value.official!['role'] == 1
                            ? '个人认证：${memberInfo.value.official!['title']}'
                            : '企业认证：${memberInfo.value.official!['title']}',
                        maxLines: 2,
                        softWrap: true,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () {
                        feedBack();
                        Clipboard.setData(ClipboardData(
                            text: memberInfo.value.mid.toString()));
                        SmartDialog.showToast('uid复制成功');
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child: SizedBox(
                            height: 16,
                            child: Text(
                              'uid: ${memberInfo.value.mid}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SelectableText(memberInfo.value.sign ?? ''),
                  ],
                ),
              );
            } else {
              return ProfilePanel(ctr: _memberController, loadingStatus: true);
            }
          } else {
            // 骨架屏
            return ProfilePanel(ctr: _memberController, loadingStatus: true);
          }
        },
      ),
    );
  }
}
