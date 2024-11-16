import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/live/item.dart';
import 'package:pilipala/models/member/info.dart';
import 'package:pilipala/plugin/pl_gallery/index.dart';
import 'package:pilipala/utils/utils.dart';

class ProfilePanel extends StatelessWidget {
  final dynamic ctr;
  final bool loadingStatus;
  const ProfilePanel({
    super.key,
    required this.ctr,
    this.loadingStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    MemberInfoModel memberInfo = ctr.memberInfo.value;
    final int? mid = memberInfo.mid;
    final String? name = memberInfo.name;

    Map<String, dynamic> buildStatItem({
      required String label,
      required String value,
      required VoidCallback onTap,
    }) {
      return {
        'label': label,
        'value': value,
        'fn': onTap,
      };
    }

    final List<Map<String, dynamic>> statList = [
      buildStatItem(
        label: '关注',
        value: !loadingStatus ? "${ctr.userStat!['following']}" : '-',
        onTap: () {
          Get.toNamed('/follow?mid=$mid&name=$name');
        },
      ),
      buildStatItem(
        label: '粉丝',
        value: !loadingStatus
            ? ctr.userStat!['follower'] != null
                ? Utils.numFormat(ctr.userStat!['follower'])
                : '-'
            : '-',
        onTap: () {
          Get.toNamed('/fan?mid=$mid&name=$name');
        },
      ),
      buildStatItem(
        label: '获赞',
        value: !loadingStatus
            ? ctr.userStat!['likes'] != null
                ? Utils.numFormat(ctr.userStat!['likes'])
                : '-'
            : '-',
        onTap: () {},
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 4),
      child: Row(
        children: [
          Hero(
            tag: ctr.heroTag!,
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      HeroDialogRoute<void>(
                        builder: (BuildContext context) =>
                            InteractiveviewerGallery(
                          sources: [
                            !loadingStatus ? memberInfo.face : ctr.face.value
                          ],
                          initIndex: 0,
                          onPageChanged: (int pageIndex) {},
                        ),
                      ),
                    );
                  },
                  child: NetworkImgLayer(
                    width: 90,
                    height: 90,
                    type: 'avatar',
                    src: !loadingStatus ? memberInfo.face : ctr.face.value,
                  ),
                ),
                if (!loadingStatus &&
                    memberInfo.liveRoom != null &&
                    memberInfo.liveRoom!.liveStatus == 1)
                  Positioned(
                    bottom: 0,
                    left: 14,
                    child: GestureDetector(
                      onTap: () {
                        LiveItemModel liveItem = LiveItemModel(
                          title: memberInfo.liveRoom!.title,
                          uname: memberInfo.name,
                          face: memberInfo.face,
                          roomId: memberInfo.liveRoom!.roomId,
                          watchedShow: memberInfo.liveRoom!.watchedShow,
                        );
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
                            'assets/images/live.png',
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
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: statList.map((item) {
                      return buildStatColumn(
                        context,
                        item['label'],
                        item['value'],
                        item['fn'],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                if (ctr.ownerMid != ctr.mid && ctr.ownerMid != -1)
                  buildActionButtons(context, ctr, memberInfo),
                if (ctr.ownerMid == ctr.mid && ctr.ownerMid != -1)
                  buildEditProfileButton(context),
                if (ctr.ownerMid == -1) buildNotLoggedInButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatColumn(
    BuildContext context,
    String label,
    String value,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.labelMedium!.fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActionButtons(
    BuildContext context,
    dynamic ctr,
    MemberInfoModel memberInfo,
  ) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        const SizedBox(width: 20),
        Obx(
          () => Expanded(
            child: TextButton(
              onPressed: () => loadingStatus ? null : ctr.actionRelationMod(),
              style: TextButton.styleFrom(
                foregroundColor: ctr.attribute.value == -1
                    ? Colors.transparent
                    : ctr.attribute.value != 0
                        ? colorScheme.outline
                        : colorScheme.onPrimary,
                backgroundColor: ctr.attribute.value != 0
                    ? colorScheme.onInverseSurface
                    : colorScheme.primary,
              ),
              child: Obx(() => Text(ctr.attributeText.value)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextButton(
            onPressed: () {
              Get.toNamed(
                '/whisperDetail',
                parameters: {
                  'name': memberInfo.name!,
                  'face': memberInfo.face!,
                  'mid': memberInfo.mid.toString(),
                  'heroTag': ctr.heroTag!,
                },
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.onInverseSurface,
            ),
            child: const Text('发消息'),
          ),
        ),
      ],
    );
  }

  Widget buildEditProfileButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Get.toNamed('/mineEdit');
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: const Text('编辑资料'),
    );
  }

  Widget buildNotLoggedInButton(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        foregroundColor: Theme.of(context).colorScheme.outline,
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      ),
      child: const Text('未登录'),
    );
  }
}
