import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pilipala/models/video/play/quality.dart';
import 'package:pilipala/models/video/play/url.dart';
import 'package:pilipala/pages/home/index.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/plugin/pl_player/index.dart';

class HeaderControl extends StatefulWidget implements PreferredSizeWidget {
  final PlPlayerController? controller;
  final VideoDetailController? videoDetailCtr;
  const HeaderControl({
    this.controller,
    this.videoDetailCtr,
    Key? key,
  }) : super(key: key);

  @override
  State<HeaderControl> createState() => _HeaderControlState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _HeaderControlState extends State<HeaderControl> {
  late PlayUrlModel videoInfo;
  List<PlaySpeed> playSpeed = PlaySpeed.values;
  TextStyle subTitleStyle = const TextStyle(fontSize: 12);
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  void initState() {
    super.initState();
    videoInfo = widget.videoDetailCtr!.data;
  }

  /// 设置面板
  void showSettingSheet() {
    showModalBottomSheet(
      elevation: 0,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          width: double.infinity,
          height: 400,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          margin: const EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(
                height: 35,
                child: Center(
                  child: Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer
                            .withOpacity(0.5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3))),
                  ),
                ),
              ),
              Expanded(
                  child: Material(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ListTile(
                      onTap: () {},
                      dense: true,
                      enabled: false,
                      leading:
                          const Icon(Icons.network_cell_outlined, size: 20),
                      title: const Text('省流模式'),
                      subtitle: Text('低画质 ｜ 减少视频缓存', style: subTitleStyle),
                      trailing: Transform.scale(
                        scale: 0.75,
                        child: Switch(
                          thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                              (Set<MaterialState> states) {
                            if (states.isNotEmpty &&
                                states.first == MaterialState.selected) {
                              return const Icon(Icons.done);
                            }
                            return null; // All other states will use the default thumbIcon.
                          }),
                          value: false,
                          onChanged: (value) => {},
                        ),
                      ),
                    ),
                    Obx(
                      () => ListTile(
                        onTap: () => {Get.back(), showSetSpeedSheet()},
                        dense: true,
                        leading: const Icon(Icons.speed_outlined, size: 20),
                        title: const Text('播放速度'),
                        subtitle: Text(
                            '当前倍速 x${widget.controller!.playbackSpeed}',
                            style: subTitleStyle),
                      ),
                    ),
                    ListTile(
                      onTap: () => {Get.back(), showSetVideoQa()},
                      dense: true,
                      leading: const Icon(Icons.play_circle_outline, size: 20),
                      title: const Text('选择画质'),
                      subtitle: Text(
                          '当前画质 ${widget.videoDetailCtr!.currentVideoQa.description}',
                          style: subTitleStyle),
                    ),
                    ListTile(
                      onTap: () => {Get.back(), showSetAudioQa()},
                      dense: true,
                      leading: const Icon(Icons.album_outlined, size: 20),
                      title: const Text('选择音质'),
                      subtitle: Text(
                          '当前音质 ${widget.videoDetailCtr!.currentAudioQa.description}',
                          style: subTitleStyle),
                    ),
                    ListTile(
                      onTap: () {},
                      dense: true,
                      enabled: false,
                      leading: const Icon(Icons.play_circle_outline, size: 20),
                      title: const Text('播放设置'),
                    ),
                    ListTile(
                      onTap: () {},
                      dense: true,
                      enabled: false,
                      leading: const Icon(Icons.subtitles_outlined, size: 20),
                      title: const Text('弹幕设置'),
                    ),
                  ],
                ),
              ))
            ],
          ),
        );
      },
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
    );
  }

  /// 选择倍速
  void showSetSpeedSheet() {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 450,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          margin: const EdgeInsets.all(12),
          child: Material(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const SizedBox(
                  height: 45,
                  child: Center(
                    child: Text('播放速度'),
                  ),
                ),
                for (var i in playSpeed) ...[
                  ListTile(
                    onTap: () {
                      widget.controller!.setPlaybackSpeed(i.value);
                      Get.back(result: {'playbackSpeed': i.value});
                    },
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 20, right: 20),
                    title: Text(i.description),
                    trailing: i.value == widget.controller!.playbackSpeed
                        ? Icon(
                            Icons.done,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  /// 选择画质
  void showSetVideoQa() {
    List<FormatItem> videoFormat = videoInfo.supportFormats!;
    VideoQuality currentVideoQa = widget.videoDetailCtr!.currentVideoQa;

    /// 总质量分类
    int totalQaSam = videoFormat.length;

    /// 可用的质量分类
    int userfulQaSam = 0;
    List<VideoItem> video = videoInfo.dash!.video!;
    Set<int> idSet = {};
    for (var item in video) {
      int id = item.id!;
      if (!idSet.contains(id)) {
        idSet.add(id);
        userfulQaSam++;
      }
    }

    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 310,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          margin: const EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(
                height: 45,
                child: GestureDetector(
                  onTap: () {
                    SmartDialog.showToast('标灰画质可能需要bilibili会员');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('选择画质'),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.outline,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        for (var i = 0; i < totalQaSam; i++) ...[
                          ListTile(
                            onTap: () {
                              final int quality = videoFormat[i].quality!;
                              widget.videoDetailCtr!.currentVideoQa =
                                  VideoQualityCode.fromCode(quality)!;
                              widget.videoDetailCtr!.updatePlayer();
                              Get.back();
                            },
                            dense: true,
                            // 可能包含会员解锁画质
                            enabled: i >= totalQaSam - userfulQaSam,
                            contentPadding:
                                const EdgeInsets.only(left: 20, right: 20),
                            title: Text(videoFormat[i].newDesc!),
                            subtitle: Text(
                              videoFormat[i].format!,
                              style: subTitleStyle,
                            ),
                            trailing: currentVideoQa.code ==
                                    videoFormat[i].quality
                                ? Icon(
                                    Icons.done,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : const SizedBox(),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 选择音质
  void showSetAudioQa() {
    List<FormatItem> videoFormat = videoInfo.supportFormats!;
    AudioQuality currentAudioQa = widget.videoDetailCtr!.currentAudioQa;

    List<AudioItem> audio = videoInfo.dash!.audio!;
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 250,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          margin: const EdgeInsets.all(12),
          child: Column(
            children: [
              const SizedBox(height: 45, child: Center(child: Text('选择音质'))),
              Expanded(
                child: Material(
                  child: ListView(
                    children: [
                      for (var i in audio) ...[
                        ListTile(
                          onTap: () {
                            final int quality = i.id!;
                            widget.videoDetailCtr!.currentAudioQa =
                                AudioQualityCode.fromCode(quality)!;
                            widget.videoDetailCtr!.updatePlayer();
                            Get.back();
                          },
                          dense: true,
                          contentPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                          title: Text(i.quality!),
                          subtitle: Text(
                            i.codecs!,
                            style: subTitleStyle,
                          ),
                          trailing: currentAudioQa.code == i.id
                              ? Icon(
                                  Icons.done,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : const SizedBox(),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _ = widget.controller!;
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      primary: false,
      centerTitle: false,
      automaticallyImplyLeading: false,
      titleSpacing: 14,
      title: Row(
        children: [
          ComBtn(
            icon: const Icon(
              FontAwesomeIcons.arrowLeft,
              size: 15,
              color: Colors.white,
            ),
            fuc: () => Get.back(),
          ),
          const SizedBox(width: 4),
          ComBtn(
            icon: const Icon(
              FontAwesomeIcons.house,
              size: 15,
              color: Colors.white,
            ),
            fuc: () => Get.offAll(const HomePage()),
          ),
          const Spacer(),
          // ComBtn(
          //   icon: const Icon(
          //     FontAwesomeIcons.cropSimple,
          //     size: 15,
          //     color: Colors.white,
          //   ),
          //   fuc: () => _.screenshot(),
          // ),
          Obx(
            () => SizedBox(
              width: 45,
              height: 34,
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () {
                  _.togglePlaybackSpeed();
                },
                child: Text(
                  '${_.playbackSpeed.toString()}X',
                  style: textStyle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          ComBtn(
            icon: const Icon(
              FontAwesomeIcons.sliders,
              size: 15,
              color: Colors.white,
            ),
            fuc: () => showSettingSheet(),
          ),
        ],
      ),
    );
  }
}
