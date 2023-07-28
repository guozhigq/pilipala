import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/member/archive/view.dart';
import 'package:pilipala/pages/member/dynamic/index.dart';
import 'package:pilipala/pages/member/index.dart';

import 'widgets/profile.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage>
    with SingleTickerProviderStateMixin {
  final MemberController _memberController = Get.put(MemberController());
  Future? _futureBuilderFuture;
  final ScrollController _extendNestCtr = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
    _futureBuilderFuture = _memberController.getInfo();
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
                    if (_memberController.face != null)
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
                        future: _futureBuilderFuture,
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
                                        profile(_memberController),
                                        const SizedBox(height: 14),
                                        Row(
                                          children: [
                                            Flexible(
                                                child: Text(
                                              _memberController
                                                  .memberInfo.value.name!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            )),
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
                              return const SizedBox();
                            }
                          } else {
                            // 骨架屏
                            return profile(_memberController,
                                loadingStatus: true);
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
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TabBar(controller: _tabController, tabs: const [
                Tab(text: '主页'),
                Tab(text: '动态'),
                Tab(text: '投稿'),
              ]),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: const [
                Text('主页'),
                MemberDynamicPanel(),
                ArchivePanel(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
