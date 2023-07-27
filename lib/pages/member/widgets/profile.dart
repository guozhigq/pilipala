import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/live/item.dart';
import 'package:pilipala/models/member/info.dart';
import 'package:pilipala/utils/utils.dart';

Widget profile(ctr, {loadingStatus = false}) {
  MemberInfoModel memberInfo = ctr.memberInfo.value;
  return Builder(
    builder: ((context) {
      return Padding(
        padding: EdgeInsets.only(top: 3 * MediaQuery.of(context).padding.top),
        child: Row(
          children: [
            Hero(
                tag: ctr.heroTag!,
                child: Stack(
                  children: [
                    NetworkImgLayer(
                      width: 90,
                      height: 90,
                      type: 'avatar',
                      src: !loadingStatus ? memberInfo.face : ctr.face,
                    ),
                    if (!loadingStatus &&
                        memberInfo.liveRoom != null &&
                        memberInfo.liveRoom!.liveStatus == 1)
                      Positioned(
                        bottom: 0,
                        left: 14,
                        child: GestureDetector(
                          onTap: () {
                            LiveItemModel liveItem = LiveItemModel.fromJson({
                              'title': memberInfo.liveRoom!.title,
                              'uname': memberInfo.name,
                              'face': memberInfo.face,
                              'roomid': memberInfo.liveRoom!.roomId,
                              'watched_show': memberInfo.liveRoom!.watchedShow,
                            });
                            Get.toNamed(
                              '/liveRoom?roomid=${memberInfo.liveRoom!.roomId}',
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
                        InkWell(
                          onTap: () {
                            Get.toNamed(
                                '/follow?mid=${memberInfo.mid}&name=${memberInfo.name}');
                          },
                          child: Column(
                            children: [
                              Text(
                                !loadingStatus
                                    ? ctr.userStat!['following'].toString()
                                    : '-',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(
                                '/fan?mid=${memberInfo.mid}&name=${memberInfo.name}');
                          },
                          child: Column(
                            children: [
                              Text(
                                  !loadingStatus
                                      ? Utils.numFormat(
                                          ctr.userStat!['follower'],
                                        )
                                      : '-',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text('粉丝',
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .fontSize))
                            ],
                          ),
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
                  if (ctr.ownerMid != ctr.mid) ...[
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => ctr.actionRelationMod(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(left: 42, right: 42),
                            foregroundColor:
                                !loadingStatus && memberInfo.isFollowed!
                                    ? Theme.of(context).colorScheme.outline
                                    : Theme.of(context).colorScheme.onPrimary,
                            backgroundColor: !loadingStatus &&
                                    memberInfo.isFollowed!
                                ? Theme.of(context).colorScheme.onInverseSurface
                                : Theme.of(context)
                                    .colorScheme
                                    .primary, // 设置按钮背景色
                          ),
                          child: Text(!loadingStatus && memberInfo.isFollowed!
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
                      onPressed: () {
                        SmartDialog.showToast('功能开发中 💪');
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.only(left: 80, right: 80),
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
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
    }),
  );
}
