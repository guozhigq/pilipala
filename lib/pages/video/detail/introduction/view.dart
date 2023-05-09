import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/pages/video/detail/widgets/expandable_section.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/common/widgets/stat/danmu.dart';
import 'package:pilipala/common/widgets/stat/view.dart';
import 'package:pilipala/models/video_detail_res.dart';
import 'package:pilipala/pages/video/detail/introduction/controller.dart';
import 'package:pilipala/utils/utils.dart';

class VideoIntroPanel extends StatefulWidget {
  const VideoIntroPanel({Key? key}) : super(key: key);

  @override
  State<VideoIntroPanel> createState() => _VideoIntroPanelState();
}

class _VideoIntroPanelState extends State<VideoIntroPanel>
    with AutomaticKeepAliveClientMixin {
  final VideoIntroController videoIntroController =
      Get.put(VideoIntroController(), tag: Get.arguments['heroTag']);
  VideoDetailData? videoDetail;

  // 添加页面缓存
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    videoIntroController.videoDetail.listen((value) {
      videoDetail = value;
    });
  }

  @override
  void dispose() {
    videoIntroController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: videoIntroController.queryVideoIntro(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data['status']) {
            // 请求成功
            // return _buildView(context, false, videoDetail);
            return VideoInfo(
                loadingStatus: false,
                videoDetail: videoDetail,
                videoIntroController: videoIntroController);
          } else {
            // 请求错误
            return HttpError(
              errMsg: snapshot.data['msg'],
              fn: () => setState(() {}),
            );
          }
        } else {
          return VideoInfo(
              loadingStatus: true,
              videoDetail: videoDetail,
              videoIntroController: videoIntroController);
        }
      },
    );
  }
}

class VideoInfo extends StatefulWidget {
  bool loadingStatus = false;
  VideoDetailData? videoDetail;
  VideoIntroController? videoIntroController;

  VideoInfo(
      {Key? key,
      required this.loadingStatus,
      this.videoDetail,
      this.videoIntroController})
      : super(key: key);

  @override
  State<VideoInfo> createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> with TickerProviderStateMixin {
  Map videoItem = Get.put(VideoIntroController()).videoItem!;
  bool isExpand = false;

  /// 手动控制动画的控制器
  late AnimationController? _manualController;

  /// 手动控制
  late Animation<double>? _manualAnimation;

  @override
  void initState() {
    super.initState();

    /// 不设置重复，使用代码控制进度，动画时间1秒
    _manualController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _manualAnimation =
        Tween<double>(begin: 0.5, end: 1.5).animate(_manualController!);
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
      sliver: SliverToBoxAdapter(
        child: !widget.loadingStatus || videoItem.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableRegion(
                    magnifierConfiguration: const TextMagnifierConfiguration(),
                    focusNode: FocusNode(),
                    selectionControls: MaterialTextSelectionControls(),
                    child: Text(
                      !widget.loadingStatus
                          ? widget.videoDetail!.title
                          : videoItem['title'],
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      _manualController!.animateTo(isExpand ? 0 : 0.5);
                      setState(() {
                        isExpand = !isExpand;
                      });
                    },
                    child: Row(
                      children: [
                        const SizedBox(width: 2),
                        StatView(
                          theme: 'gray',
                          view: !widget.loadingStatus
                              ? widget.videoDetail!.stat!.view
                              : videoItem['stat'].view,
                          size: 'medium',
                        ),
                        const SizedBox(width: 10),
                        StatDanMu(
                          theme: 'gray',
                          danmu: !widget.loadingStatus
                              ? widget.videoDetail!.stat!.danmaku
                              : videoItem['stat'].danmaku,
                          size: 'medium',
                        ),
                        const SizedBox(width: 10),
                        Text(
                          Utils.dateFormat(
                              !widget.loadingStatus
                                  ? widget.videoDetail!.pubdate
                                  : videoItem['pubdate'],
                              formatType: 'detail'),
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.outline),
                        ),
                        const Spacer(),
                        RotationTransition(
                          turns: _manualAnimation!,
                          child: SizedBox(
                            width: 35,
                            height: 35,
                            child: IconButton(
                              padding: const EdgeInsets.all(2.0),
                              onPressed: () {
                                /// 0.5代表 180弧度
                                _manualController!
                                    .animateTo(isExpand ? 0 : 0.5);
                                setState(() {
                                  isExpand = !isExpand;
                                });
                              },
                              icon: Icon(
                                FontAwesomeIcons.angleUp,
                                size: 15,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      NetworkImgLayer(
                        type: 'avatar',
                        src: !widget.loadingStatus
                            ? widget.videoDetail!.owner!.face
                            : videoItem['owner'].face,
                        width: 38,
                        height: 38,
                        fadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(!widget.loadingStatus
                              ? widget.videoDetail!.owner!.name
                              : videoItem['owner'].name),
                          // const SizedBox(width: 10),
                          Text(
                            widget.loadingStatus
                                ? '- 粉丝'
                                : '${Utils.numFormat(widget.videoIntroController!.userStat['follower'])}粉丝',
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .fontSize,
                                color: Theme.of(context).colorScheme.outline),
                          ),
                        ],
                      ),
                      const Spacer(),
                      AnimatedOpacity(
                        opacity: widget.loadingStatus ? 0 : 1,
                        duration: const Duration(milliseconds: 150),
                        child: SizedBox(
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              children: const [
                                Icon(
                                  CupertinoIcons.plus,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text('关注'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // 简介 默认收起
                  if (!widget.loadingStatus)
                    ExpandedSection(
                      expand: isExpand,
                      begin: 0.0,
                      end: 1.0,
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          height: 1.5,
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SelectableRegion(
                            magnifierConfiguration:
                                const TextMagnifierConfiguration(),
                            focusNode: FocusNode(),
                            selectionControls: MaterialTextSelectionControls(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.videoDetail!.bvid!),
                                Text(widget.videoDetail!.desc!),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 5),
                  _actionGrid(context),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  // 喜欢 投币 分享
  Widget _actionGrid(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: constraints.maxWidth / 5 * 0.8,
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(0),
          crossAxisCount: 5,
          childAspectRatio: 1.25,
          children: <Widget>[
            ActionItem(
                icon: const Icon(FontAwesomeIcons.thumbsUp),
                onTap: () => {},
                selectStatus: false,
                loadingStatus: widget.loadingStatus,
                text: !widget.loadingStatus
                    ? widget.videoDetail!.stat!.like!.toString()
                    : '-'),
            ActionItem(
                icon: const Icon(FontAwesomeIcons.thumbsDown),
                onTap: () => {},
                selectStatus: false,
                loadingStatus: widget.loadingStatus,
                text: '不喜欢'),
            ActionItem(
                icon: const Icon(FontAwesomeIcons.b),
                onTap: () => {},
                selectStatus: false,
                loadingStatus: widget.loadingStatus,
                text: !widget.loadingStatus
                    ? widget.videoDetail!.stat!.coin!.toString()
                    : '-'),
            ActionItem(
                icon: const Icon(FontAwesomeIcons.star),
                onTap: () => {},
                selectStatus: false,
                loadingStatus: widget.loadingStatus,
                text: !widget.loadingStatus
                    ? widget.videoDetail!.stat!.favorite!.toString()
                    : '-'),
            ActionItem(
                icon: const Icon(FontAwesomeIcons.shareFromSquare),
                onTap: () => {},
                selectStatus: false,
                loadingStatus: widget.loadingStatus,
                text: !widget.loadingStatus
                    ? widget.videoDetail!.stat!.share!.toString()
                    : '-'),
          ],
        ),
      );
    });
  }
}

class ActionItem extends StatelessWidget {
  Icon? icon;
  Function? onTap;
  bool? loadingStatus;
  String? text;
  bool selectStatus = false;

  ActionItem({
    Key? key,
    this.icon,
    this.onTap,
    this.loadingStatus,
    this.text,
    required this.selectStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        child: InkWell(
          onTap: () {},
          borderRadius: StyleString.mdRadius,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon!.icon!,
                  size: 21,
                  color: selectStatus
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.outline),
              const SizedBox(height: 4),
              AnimatedOpacity(
                opacity: loadingStatus! ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  text!,
                  style: TextStyle(
                      color: selectStatus
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.outline,
                      fontSize:
                          Theme.of(context).textTheme.labelSmall?.fontSize),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
