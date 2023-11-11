import 'dart:io';

import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:ns_danmaku/ns_danmaku.dart';
import 'package:pilipala/models/video/play/quality.dart';
import 'package:pilipala/models/video/play/url.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/pages/video/detail/introduction/widgets/menu_row.dart';
import 'package:pilipala/plugin/pl_player/index.dart';
import 'package:pilipala/plugin/pl_player/models/play_repeat.dart';
import 'package:pilipala/utils/storage.dart';

class HeaderControl extends StatefulWidget implements PreferredSizeWidget {
  final PlPlayerController? controller;
  final VideoDetailController? videoDetailCtr;
  final Floating? floating;
  const HeaderControl({
    this.controller,
    this.videoDetailCtr,
    this.floating,
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
  TextStyle titleStyle = const TextStyle(fontSize: 14);
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
  Box localCache = GStrorage.localCache;
  Box videoStorage = GStrorage.video;
  late List speedsList;
  double buttonSpace = 8;

  @override
  void initState() {
    super.initState();
    videoInfo = widget.videoDetailCtr!.data;
    speedsList = widget.controller!.speedsList;
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
          height: 440,
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
                  children: [
                    ListTile(
                      onTap: () {},
                      dense: true,
                      enabled: false,
                      leading:
                          const Icon(Icons.network_cell_outlined, size: 20),
                      title: Text('省流模式', style: titleStyle),
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
                    // Obx(
                    //   () => ListTile(
                    //     onTap: () => {Get.back(), showSetSpeedSheet()},
                    //     dense: true,
                    //     leading: const Icon(Icons.speed_outlined, size: 20),
                    //     title: Text('播放速度', style: titleStyle),
                    //     subtitle: Text(
                    //         '当前倍速 x${widget.controller!.playbackSpeed}',
                    //         style: subTitleStyle),
                    //   ),
                    // ),
                    ListTile(
                      onTap: () => {Get.back(), showSetVideoQa()},
                      dense: true,
                      leading: const Icon(Icons.play_circle_outline, size: 20),
                      title: Text('选择画质', style: titleStyle),
                      subtitle: Text(
                          '当前画质 ${widget.videoDetailCtr!.currentVideoQa.description}',
                          style: subTitleStyle),
                    ),
                    if (widget.videoDetailCtr!.currentAudioQa != null)
                      ListTile(
                        onTap: () => {Get.back(), showSetAudioQa()},
                        dense: true,
                        leading: const Icon(Icons.album_outlined, size: 20),
                        title: Text('选择音质', style: titleStyle),
                        subtitle: Text(
                            '当前音质 ${widget.videoDetailCtr!.currentAudioQa!.description}',
                            style: subTitleStyle),
                      ),
                    ListTile(
                      onTap: () => {Get.back(), showSetDecodeFormats()},
                      dense: true,
                      leading: const Icon(Icons.av_timer_outlined, size: 20),
                      title: Text('解码格式', style: titleStyle),
                      subtitle: Text(
                          '当前解码格式 ${widget.videoDetailCtr!.currentDecodeFormats.description}',
                          style: subTitleStyle),
                    ),
                    ListTile(
                      onTap: () => {Get.back(), showSetRepeat()},
                      dense: true,
                      leading: const Icon(Icons.repeat, size: 20),
                      title: Text('播放顺序', style: titleStyle),
                      subtitle: Text(widget.controller!.playRepeat.description,
                          style: subTitleStyle),
                    ),
                    ListTile(
                      onTap: () => {Get.back(), showSetDanmaku()},
                      dense: true,
                      leading: const Icon(Icons.subtitles_outlined, size: 20),
                      title: Text('弹幕设置', style: titleStyle),
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
    double currentSpeed = widget.controller!.playbackSpeed;
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text('播放速度'),
          content: StatefulBuilder(builder: (context, StateSetter setState) {
            return Wrap(
              alignment: WrapAlignment.start,
              spacing: 8,
              runSpacing: 2,
              children: [
                for (var i in speedsList) ...[
                  if (i == currentSpeed) ...[
                    FilledButton(
                      onPressed: () async {
                        // setState(() => currentSpeed = i),
                        await widget.controller!.setPlaybackSpeed(i);
                        Get.back();
                      },
                      child: Text(i.toString()),
                    ),
                  ] else ...[
                    FilledButton.tonal(
                      onPressed: () async {
                        // setState(() => currentSpeed = i),
                        await widget.controller!.setPlaybackSpeed(i);
                        Get.back();
                      },
                      child: Text(i.toString()),
                    ),
                  ]
                ]
              ],
            );
          }),
          actions: [
            TextButton(
              onPressed: () => SmartDialog.dismiss(),
              child: Text(
                '取消',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                await widget.controller!.setDefaultSpeed();
                Get.back();
              },
              child: const Text('默认速度'),
            ),
          ],
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
                      Text('选择画质', style: titleStyle),
                      SizedBox(width: buttonSpace),
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
                              if (currentVideoQa.code ==
                                  videoFormat[i].quality) {
                                return;
                              }
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
    AudioQuality currentAudioQa = widget.videoDetailCtr!.currentAudioQa!;

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
              SizedBox(
                  height: 45,
                  child: Center(child: Text('选择音质', style: titleStyle))),
              Expanded(
                child: Material(
                  child: ListView(
                    children: [
                      for (var i in audio) ...[
                        ListTile(
                          onTap: () {
                            if (currentAudioQa.code == i.id) return;
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

  // 选择解码格式
  void showSetDecodeFormats() {
    // 当前选中的解码格式
    VideoDecodeFormats currentDecodeFormats =
        widget.videoDetailCtr!.currentDecodeFormats;
    VideoItem firstVideo = widget.videoDetailCtr!.firstVideo;
    // 当前视频可用的解码格式
    List<FormatItem> videoFormat = videoInfo.supportFormats!;
    List list = videoFormat
        .firstWhere((e) => e.quality == firstVideo.quality!.code)
        .codecs!;

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
              SizedBox(
                  height: 45,
                  child: Center(child: Text('选择解码格式', style: titleStyle))),
              Expanded(
                child: Material(
                  child: ListView(
                    children: [
                      for (var i in list) ...[
                        ListTile(
                          onTap: () {
                            if (i.startsWith(currentDecodeFormats.code)) return;
                            widget.videoDetailCtr!.currentDecodeFormats =
                                VideoDecodeFormatsCode.fromString(i)!;
                            widget.videoDetailCtr!.updatePlayer();
                            Get.back();
                          },
                          dense: true,
                          contentPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                          title: Text(VideoDecodeFormatsCode.fromString(i)!
                              .description!),
                          subtitle: Text(
                            i!,
                            style: subTitleStyle,
                          ),
                          trailing: i.startsWith(currentDecodeFormats.code)
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

  /// 弹幕功能
  void showSetDanmaku() async {
    // 屏蔽类型
    List<Map<String, dynamic>> blockTypesList = [
      {'value': 5, 'label': '顶部'},
      {'value': 2, 'label': '滚动'},
      {'value': 4, 'label': '底部'},
      {'value': 6, 'label': '彩色'},
    ];
    List blockTypes = widget.controller!.blockTypes;
    // 显示区域
    List<Map<String, dynamic>> showAreas = [
      {'value': 0.25, 'label': '1/4屏'},
      {'value': 0.5, 'label': '半屏'},
      {'value': 0.75, 'label': '3/4屏'},
      {'value': 1.0, 'label': '满屏'},
    ];
    double showArea = widget.controller!.showArea;
    // 不透明度
    double opacityVal = widget.controller!.opacityVal;
    // 字体大小
    double fontSizeVal = widget.controller!.fontSizeVal;
    // 弹幕速度
    double danmakuSpeedVal = widget.controller!.danmakuSpeedVal;

    DanmakuController danmakuController = widget.controller!.danmakuController!;
    await showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Container(
            width: double.infinity,
            height: 580,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 45,
                    child: Center(child: Text('弹幕设置', style: titleStyle)),
                  ),
                  const SizedBox(height: 10),
                  const Text('按类型屏蔽'),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 18),
                    child: Row(
                      children: [
                        for (var i in blockTypesList) ...[
                          ActionRowLineItem(
                            onTap: () async {
                              bool isChoose = blockTypes.contains(i['value']);
                              if (isChoose) {
                                blockTypes.remove(i['value']);
                              } else {
                                blockTypes.add(i['value']);
                              }
                              widget.controller!.blockTypes = blockTypes;
                              setState(() {});
                              try {
                                DanmakuOption currentOption =
                                    danmakuController.option;
                                DanmakuOption updatedOption =
                                    currentOption.copyWith(
                                  hideTop: blockTypes.contains(5),
                                  hideBottom: blockTypes.contains(4),
                                  hideScroll: blockTypes.contains(2),
                                  // 添加或修改其他需要修改的选项属性
                                );
                                danmakuController.updateOption(updatedOption);
                              } catch (_) {}
                            },
                            text: i['label'],
                            selectStatus: blockTypes.contains(i['value']),
                          ),
                          const SizedBox(width: 10),
                        ]
                      ],
                    ),
                  ),
                  const Text('显示区域'),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 18),
                    child: Row(
                      children: [
                        for (var i in showAreas) ...[
                          ActionRowLineItem(
                            onTap: () {
                              showArea = i['value'];
                              widget.controller!.showArea = showArea;
                              setState(() {});
                              try {
                                DanmakuOption currentOption =
                                    danmakuController.option;
                                DanmakuOption updatedOption =
                                    currentOption.copyWith(area: i['value']);
                                danmakuController.updateOption(updatedOption);
                              } catch (_) {}
                            },
                            text: i['label'],
                            selectStatus: showArea == i['value'],
                          ),
                          const SizedBox(width: 10),
                        ]
                      ],
                    ),
                  ),
                  Text('不透明度 ${opacityVal * 100}%'),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 6,
                      left: 10,
                      right: 10,
                    ),
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackShape: MSliderTrackShape(),
                        thumbColor: Theme.of(context).colorScheme.primary,
                        activeTrackColor: Theme.of(context).colorScheme.primary,
                        trackHeight: 10,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6.0),
                      ),
                      child: Slider(
                        min: 0,
                        max: 1,
                        value: opacityVal,
                        divisions: 10,
                        label: '${opacityVal * 100}%',
                        onChanged: (double val) {
                          opacityVal = val;
                          widget.controller!.opacityVal = opacityVal;
                          setState(() {});
                          try {
                            DanmakuOption currentOption =
                                danmakuController.option;
                            DanmakuOption updatedOption =
                                currentOption.copyWith(opacity: val);
                            danmakuController.updateOption(updatedOption);
                          } catch (_) {}
                        },
                      ),
                    ),
                  ),
                  Text('字体大小 ${(fontSizeVal * 100).toStringAsFixed(1)}%'),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 6,
                      left: 10,
                      right: 10,
                    ),
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackShape: MSliderTrackShape(),
                        thumbColor: Theme.of(context).colorScheme.primary,
                        activeTrackColor: Theme.of(context).colorScheme.primary,
                        trackHeight: 10,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6.0),
                      ),
                      child: Slider(
                        min: 0.5,
                        max: 2.5,
                        value: fontSizeVal,
                        divisions: 20,
                        label: '${(fontSizeVal * 100).toStringAsFixed(1)}%',
                        onChanged: (double val) {
                          fontSizeVal = val;
                          widget.controller!.fontSizeVal = fontSizeVal;
                          setState(() {});
                          try {
                            DanmakuOption currentOption =
                                danmakuController.option;
                            DanmakuOption updatedOption =
                                currentOption.copyWith(
                              fontSize: (15 * fontSizeVal).toDouble(),
                            );
                            danmakuController.updateOption(updatedOption);
                          } catch (_) {}
                        },
                      ),
                    ),
                  ),
                  Text('弹幕时长 ${danmakuSpeedVal.toString()}'),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 6,
                      left: 10,
                      right: 10,
                    ),
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackShape: MSliderTrackShape(),
                        thumbColor: Theme.of(context).colorScheme.primary,
                        activeTrackColor: Theme.of(context).colorScheme.primary,
                        trackHeight: 10,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6.0),
                      ),
                      child: Slider(
                        min: 1,
                        max: 8,
                        value: danmakuSpeedVal,
                        divisions: 14,
                        label: danmakuSpeedVal.toString(),
                        onChanged: (double val) {
                          danmakuSpeedVal = val;
                          widget.controller!.danmakuSpeedVal = danmakuSpeedVal;
                          setState(() {});
                          try {
                            DanmakuOption currentOption =
                                danmakuController.option;
                            DanmakuOption updatedOption =
                                currentOption.copyWith(duration: val);
                            danmakuController.updateOption(updatedOption);
                          } catch (_) {}
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  /// 播放顺序
  void showSetRepeat() async {
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
              SizedBox(
                  height: 45,
                  child: Center(child: Text('选择播放顺序', style: titleStyle))),
              Expanded(
                child: Material(
                  child: ListView(
                    children: [
                      for (var i in PlayRepeat.values) ...[
                        ListTile(
                          onTap: () {
                            widget.controller!.setPlayRepeat(i);
                            Get.back();
                          },
                          dense: true,
                          contentPadding:
                              const EdgeInsets.only(left: 20, right: 20),
                          title: Text(i.description),
                          trailing: widget.controller!.playRepeat == i
                              ? Icon(
                                  Icons.done,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : const SizedBox(),
                        )
                      ],
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
          SizedBox(width: buttonSpace),
          ComBtn(
            icon: const Icon(
              FontAwesomeIcons.house,
              size: 15,
              color: Colors.white,
            ),
            fuc: () async {
              // 销毁播放器实例
              await widget.controller!.dispose(type: 'all');
              if (mounted) {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
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
          SizedBox(
            width: 34,
            height: 34,
            child: Obx(
              () => IconButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () {
                  _.isOpenDanmu.value = !_.isOpenDanmu.value;
                },
                icon: Icon(
                  _.isOpenDanmu.value
                      ? Icons.subtitles_outlined
                      : Icons.subtitles_off_outlined,
                  size: 19,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: buttonSpace),
          if (Platform.isAndroid) ...[
            SizedBox(
              width: 34,
              height: 34,
              child: IconButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () async {
                  bool canUsePiP = false;
                  widget.controller!.hiddenControls(false);
                  try {
                    canUsePiP = await widget.floating!.isPipAvailable;
                  } on PlatformException catch (_) {
                    canUsePiP = false;
                  }
                  if (canUsePiP) {
                    final aspectRatio = Rational(
                      widget.videoDetailCtr!.data.dash!.video!.first.width!,
                      widget.videoDetailCtr!.data.dash!.video!.first.height!,
                    );
                    await widget.floating!.enable(aspectRatio: aspectRatio);
                  } else {}
                },
                icon: const Icon(
                  Icons.picture_in_picture_outlined,
                  size: 19,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: buttonSpace),
          ],
          Obx(
            () => SizedBox(
              width: 45,
              height: 34,
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
                onPressed: () => showSetSpeedSheet(),
                child: Text(
                  '${_.playbackSpeed.toString()}X',
                  style: textStyle,
                ),
              ),
            ),
          ),
          SizedBox(width: buttonSpace),
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

class MSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    SliderThemeData? sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    const double trackHeight = 3;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2 + 4;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
