import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/live/item.dart';
import 'package:pilipala/models/user/stat.dart';
import 'package:pilipala/pages/member/index.dart';
import 'package:pilipala/utils/utils.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage>
    with SingleTickerProviderStateMixin {
  final MemberController _memberController = Get.put(MemberController());
  final ScrollController _extendNestCtr = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: ExtendedNestedScrollView(
        controller: _extendNestCtr,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: false,
              primary: true,
              elevation: 0,
              scrolledUnderElevation: 0,
              forceElevated: innerBoxIsScrolled,
              expandedHeight: 320,
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
                const SizedBox(width: 4),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Positioned.fill(
                      bottom: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: NetworkImage(_memberController.face!),
                            alignment: Alignment.topCenter,
                            isAntiAlias: true,
                          ),
                        ),
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context)
                                  .colorScheme
                                  .background
                                  .withOpacity(0.44),
                              Theme.of(context).colorScheme.background,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.0, 0.46],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 20,
                      child: Container(
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: FutureBuilder(
                        future: _memberController.getInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map data = snapshot.data!;
                            if (data['status']) {
                              return Obx(
                                () => Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        profile(
                                            _memberController.memberInfo.value),
                                        const SizedBox(height: 14),
                                        Row(
                                          children: [
                                            Text(
                                              _memberController
                                                  .memberInfo.value.name!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            const SizedBox(width: 2),
                                            if (_memberController
                                                    .memberInfo.value.sex ==
                                                '女')
                                              const Icon(
                                                FontAwesomeIcons.venus,
                                                size: 14,
                                                color: Colors.pink,
                                              ),
                                            if (_memberController
                                                    .memberInfo.value.sex ==
                                                '男')
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
                                            if (_memberController.memberInfo
                                                        .value.vip!.status ==
                                                    1 &&
                                                _memberController.memberInfo
                                                            .value.vip!.label![
                                                        'img_label_uri_hans'] !=
                                                    '') ...[
                                              Image.network(
                                                _memberController.memberInfo
                                                        .value.vip!.label![
                                                    'img_label_uri_hans'],
                                                height: 20,
                                              ),
                                            ] else if (_memberController
                                                        .memberInfo
                                                        .value
                                                        .vip!
                                                        .status ==
                                                    1 &&
                                                _memberController.memberInfo
                                                            .value.vip!.label![
                                                        'img_label_uri_hans_static'] !=
                                                    '') ...[
                                              Image.network(
                                                _memberController.memberInfo
                                                        .value.vip!.label![
                                                    'img_label_uri_hans_static'],
                                                height: 20,
                                              ),
                                            ]
                                          ],
                                        ),
                                        if (_memberController.memberInfo.value
                                                .official!['title'] !=
                                            '') ...[
                                          const SizedBox(height: 6),
                                          Text.rich(
                                            maxLines: 2,
                                            TextSpan(
                                              text: _memberController
                                                          .memberInfo
                                                          .value
                                                          .official!['role'] ==
                                                      1
                                                  ? '个人认证：'
                                                  : '企业认证：',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: _memberController
                                                      .memberInfo
                                                      .value
                                                      .official!['title'],
                                                ),
                                              ],
                                            ),
                                            softWrap: true,
                                          ),
                                        ],
                                        const SizedBox(height: 4),
                                        if (_memberController
                                                .memberInfo.value.sign !=
                                            '')
                                          SelectableRegion(
                                            magnifierConfiguration:
                                                const TextMagnifierConfiguration(),
                                            focusNode: FocusNode(),
                                            selectionControls:
                                                MaterialTextSelectionControls(),
                                            child: Text(
                                              _memberController
                                                  .memberInfo.value.sign!,
                                              textAlign: TextAlign.left,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          } else {
                            // 骨架屏
                            return profile(null, loadingStatus: true);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ];
        },
        pinnedHeaderSliverHeightBuilder: () {
          return MediaQuery.of(context).padding.top + kToolbarHeight;
        },
        onlyOneScrollInBody: true,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              child: TabBar(controller: _tabController, tabs: [
                Tab(text: '主页'),
                Tab(text: '动态'),
                Tab(text: '投稿'),
              ]),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                Text('主页'),
                Text('动态'),
                Text('投稿'),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget profile(memberInfo, {loadingStatus = false}) {
    return Padding(
      padding: EdgeInsets.only(top: 3 * MediaQuery.of(context).padding.top),
      child: Row(
        children: [
          Hero(
              tag: _memberController.heroTag!,
              child: Stack(
                children: [
                  NetworkImgLayer(
                    width: 90,
                    height: 90,
                    type: 'avatar',
                    src: !loadingStatus
                        ? memberInfo.face
                        : _memberController.face,
                  ),
                  if (!loadingStatus &&
                      memberInfo.liveRoom != null &&
                      memberInfo.liveRoom.liveStatus == 1)
                    Positioned(
                      bottom: 0,
                      left: 14,
                      child: GestureDetector(
                        onTap: () {
                          LiveItemModel liveItem = LiveItemModel.fromJson({
                            'title': memberInfo.liveRoom.title,
                            'uname': memberInfo.name,
                            'face': memberInfo.face,
                            'roomid': memberInfo.liveRoom.roomId,
                          });
                          Get.toNamed(
                            '/liveRoom?roomid=${memberInfo.liveRoom.roomId}',
                            arguments: {'liveItem': liveItem},
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(children: [
                            Image.asset(
                              'assets/images/live.gif',
                              height: 10,
                            ),
                            Text(
                              ' 直播中',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .fontSize),
                            )
                          ]),
                        ),
                      ),
                    )
                ],
              )),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            !loadingStatus
                                ? _memberController.userStat!['following']
                                    .toString()
                                : '-',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '关注',
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .fontSize),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                              !loadingStatus
                                  ? Utils.numFormat(
                                      _memberController.userStat!['follower'],
                                    )
                                  : '-',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('粉丝',
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .fontSize))
                        ],
                      ),
                      Column(
                        children: [
                          const Text('-',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            '获赞',
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .fontSize),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                if (_memberController.ownerMid != _memberController.mid) ...[
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(left: 42, right: 42),
                          foregroundColor:
                              !loadingStatus && memberInfo.isFollowed
                                  ? Theme.of(context).colorScheme.outline
                                  : Theme.of(context).colorScheme.onPrimary,
                          backgroundColor: !loadingStatus &&
                                  memberInfo.isFollowed
                              ? Theme.of(context).colorScheme.onInverseSurface
                              : Theme.of(context)
                                  .colorScheme
                                  .primary, // 设置按钮背景色
                        ),
                        child: Text(!loadingStatus && memberInfo.isFollowed
                            ? '取关'
                            : '关注'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(left: 42, right: 42),
                          backgroundColor:
                              Theme.of(context).colorScheme.onInverseSurface,
                        ),
                        child: const Text('发消息'),
                      )
                    ],
                  )
                ] else ...[
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(left: 80, right: 80),
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Text('编辑资料'),
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
