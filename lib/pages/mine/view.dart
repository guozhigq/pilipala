import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/common/theme_type.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/models/user/info.dart';
import 'package:pilipala/models/user/stat.dart';
import 'package:pilipala/utils/utils.dart';
import 'controller.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  final MineController ctr = Get.put(MineController());
  late Future _futureBuilderFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = ctr.queryUserInfo();
    ctr.queryFavFolder();
    ctr.userLogin.listen((status) {
      if (mounted) {
        setState(() {
          _futureBuilderFuture = ctr.queryUserInfo();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () => Get.toNamed('/search'),
          ),
          IconButton(
            icon: Icon(
              ctr.themeType.value == ThemeType.dark
                  ? Icons.wb_sunny_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () => ctr.onChangeTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Get.toNamed('/setting', preventDuplicates: false),
          ),
          const SizedBox(width: 22),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => _buildProfileSection(context, ctr.userInfo.value)),
            const SizedBox(height: 10),
            FutureBuilder(
              future: _futureBuilderFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return const SizedBox();
                  }
                  if (snapshot.data['status']) {
                    return Obx(
                      () => _buildStatsSection(
                        context,
                        ctr.userStat.value,
                      ),
                    );
                  } else {
                    return _buildStatsSection(
                      context,
                      ctr.userStat.value,
                    );
                  }
                } else {
                  return _buildStatsSection(
                    context,
                    ctr.userStat.value,
                  );
                }
              },
            ),
            _buildMenuSection(context),
            Obx(
              () => Visibility(
                visible: ctr.userLogin.value,
                child: Divider(
                  height: 25,
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
              ),
            ),
            Obx(
              () => ctr.userLogin.value
                  ? _buildFavoritesSection(context)
                  : const SizedBox(),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom +
                  kBottomNavigationBarHeight,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, UserInfoData userInfo) {
    return InkWell(
      onTap: () => ctr.onLogin(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 30, 10),
        child: Row(
          children: [
            userInfo.face != null
                ? NetworkImgLayer(
                    src: userInfo.face,
                    width: 85,
                    height: 85,
                    type: 'avatar',
                  )
                : ClipOval(
                    child: SizedBox(
                      width: 85,
                      height: 85,
                      child: Image.asset('assets/images/noface.jpeg'),
                    ),
                  ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      userInfo.uname ?? '去登录',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: userInfo.vipStatus == 1
                            ? const Color.fromARGB(255, 251, 100, 163)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Image.asset(
                      'assets/images/lv/lv${userInfo.levelInfo != null ? userInfo.levelInfo!.currentLevel : '0'}.png',
                      height: 12,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                if (userInfo.vipType != 0 && userInfo.vipStatus == 1) ...[
                  Image.network(
                    userInfo.vipLabel!['img_label_uri_hans_static'],
                    height: 22,
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  '硬币: ${userInfo.money ?? '-'}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 28,
              color: Theme.of(context).colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, UserStat userStat) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxWidth / 3 * 0.6,
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(0),
              crossAxisCount: 3,
              childAspectRatio: 1.67,
              children: <Widget>[
                _buildStatItem(
                  context,
                  (userStat.dynamicCount ?? '-').toString(),
                  '动态',
                  ctr.pushDynamic,
                ),
                _buildStatItem(
                  context,
                  (userStat.following ?? '-').toString(),
                  '关注',
                  ctr.pushFollow,
                ),
                _buildStatItem(
                  context,
                  (userStat.follower ?? '-').toString(),
                  '粉丝',
                  ctr.pushFans,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String count,
    String label,
    Function onTap,
  ) {
    TextStyle style = TextStyle(
        fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
        fontWeight: FontWeight.bold);
    return InkWell(
      onTap: () => onTap(),
      // onTap: () {},
      borderRadius: StyleString.mdRadius,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(count, style: style),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            height: constraints.maxWidth / 4 * 0.85,
            child: GridView.count(
              primary: false,
              crossAxisCount: 4,
              padding: const EdgeInsets.all(0),
              childAspectRatio: 1.2,
              children: [
                ...ctr.menuList.map((element) {
                  return InkWell(
                    onTap: () {
                      if (!ctr.userLogin.value) {
                        SmartDialog.showToast('账号未登录');
                      } else {
                        element['onTap']();
                      }
                    },
                    borderRadius: StyleString.mdRadius,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            element['icon'],
                            size: 21,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(element['title'])
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesSection(context) {
    return Column(
      children: [
        _buildFavoritesTitle(context, 'fav', '收藏夹'),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          height: MediaQuery.textScalerOf(context).scale(110),
          child: FutureBuilder(
            future: ctr.queryFavFolder(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map? data = snapshot.data;
                if (data != null && data['status']) {
                  List favFolderList = ctr.favFolderData.value.list!;
                  int favFolderCount = ctr.favFolderData.value.count!;
                  bool flag = favFolderCount > favFolderList.length;
                  return Obx(
                    () => ListView.builder(
                      itemCount:
                          ctr.favFolderData.value.list!.length + (flag ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (flag && index == favFolderList.length) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Center(
                              child: IconButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.zero),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    return Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                        .withOpacity(0.5);
                                  }),
                                ),
                                onPressed: () => Get.toNamed('/fav'),
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return FavFolderItem(
                            item: ctr.favFolderData.value.list![index],
                            index: index,
                          );
                        }
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 110,
                    child: Center(child: Text(data?['msg'] ?? '')),
                  );
                }
              } else {
                // 骨架屏
                return Obx(
                  () => ctr.favFolderData.value.list != null
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ctr.favFolderData.value.list!.length,
                          itemBuilder: (context, index) {
                            return FavFolderItem(
                              item: ctr.favFolderData.value.list![index],
                              index: index,
                            );
                          },
                        )
                      : const SizedBox(),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTitle(
    BuildContext context,
    String type,
    String title,
  ) {
    return ListTile(
      onTap: () => Get.toNamed('/fav'),
      leading: null,
      dense: true,
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: title,
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                    fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' '),
              TextSpan(
                text: '20',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
      // trailing: IconButton(
      //   onPressed: () {},
      //   icon: const Icon(
      //     Icons.refresh,
      //     size: 20,
      //   ),
      // ),
    );
  }
}

class FavFolderItem extends StatelessWidget {
  const FavFolderItem({super.key, this.item, this.index});
  final FavFolderItemData? item;
  final int? index;
  @override
  Widget build(BuildContext context) {
    String heroTag = Utils.makeHeroTag(item!.fid);
    return Container(
      margin: EdgeInsets.only(left: index == 0 ? 20 : 0, right: 14),
      child: InkWell(
        onTap: () => Get.toNamed('/favDetail', arguments: item, parameters: {
          'mediaId': item!.id.toString(),
          'heroTag': heroTag,
          'isOwner': '1',
        }),
        borderRadius: StyleString.mdRadius,
        child: Stack(
          children: [
            NetworkImgLayer(
              src: item!.cover,
              width: 175,
              height: 110,
            ),
            // 渐变
            Positioned(
              left: 0,
              right: 0,
              top: 60,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(bottom: 8, left: 10, right: 2),
                decoration: BoxDecoration(
                  borderRadius: StyleString.mdRadius,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.white),
                        children: [
                          TextSpan(text: item!.title!),
                          const TextSpan(text: ' '),
                          if (item!.mediaCount! > 0)
                            TextSpan(
                              text: item!.mediaCount!.toString(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
