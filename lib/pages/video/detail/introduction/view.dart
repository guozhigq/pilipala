import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pilipala/common/constants.dart';
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
      Get.put(VideoIntroController());
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
      future: videoIntroController.queryVideoDetail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data) {
            // 请求成功
            // return _buildView(context, false, videoDetail);
            return VideoInfo(loadingStatus: false, videoDetail: videoDetail);
          } else {
            // 请求错误
            return Center(
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  setState(() {});
                },
              ),
            );
          }
        } else {
          // return _buildView(context, true, videoDetail);
          return VideoInfo(loadingStatus: true, videoDetail: videoDetail);
        }
      },
    );
  }

  Widget _buildView(context, loadingStatus, videoDetail) {
    // return CustomScrollView(
    //   key: const PageStorageKey<String>('简介'),
    //   slivers: <Widget>[
    //     SliverOverlapInjector(
    //         handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
    //     VideoInfo(loadingStatus: loadingStatus, videoDetail: videoDetail),
    //     SliverToBoxAdapter(
    //       child:
    //           Divider(color: Theme.of(context).dividerColor.withOpacity(0.1)),
    //     ),
    //     const RecommendList()
    //   ],
    // );
    return VideoInfo(loadingStatus: loadingStatus, videoDetail: videoDetail);
  }
}

class VideoInfo extends StatefulWidget {
  bool loadingStatus = false;
  VideoDetailData? videoDetail;

  VideoInfo({Key? key, required this.loadingStatus, this.videoDetail})
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
      padding: const EdgeInsets.only(left: 12, right: 12, top: 25),
      sliver: SliverToBoxAdapter(
        child: !widget.loadingStatus || videoItem.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            const SizedBox(height: 2),
                            // Text.rich(
                            //   TextSpan(
                            //       style: TextStyle(
                            //           color: Theme.of(context)
                            //               .colorScheme
                            //               .outline,
                            //           fontSize: 11),
                            //       children: const [
                            //         TextSpan(text: '2.6万粉丝'),
                            //         TextSpan(text: '  '),
                            //         TextSpan(text: '2.6万粉丝'),
                            //       ]),
                            // ),
                          ]),
                      const Spacer(),
                      AnimatedOpacity(
                        opacity: widget.loadingStatus ? 0 : 1,
                        duration: const Duration(milliseconds: 150),
                        child: SizedBox(
                          height: 35,
                          child: ElevatedButton(
                              onPressed: () {}, child: const Text('+ 关注')),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // 标题 超过两行收起
                  // Container(
                  //   color: Colors.blue[50],
                  //   child: SizedOverflowBox(
                  //     size: const Size(50.0, 50.0),
                  //     alignment: AlignmentDirectional.bottomStart,
                  //     child: Container(height: 150.0, width: 150.0, color: Colors.blue,),
                  //   ),
                  // ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: ExpandedSection(
                  //         expand: false,
                  //         begin: 1,
                  //         end: 1,
                  //         child: Text(
                  //           !widget.loadingStatus
                  //               ? widget.videoDetail!.title
                  //               : videoItem['title'],
                  //           overflow: TextOverflow.ellipsis,
                  //           maxLines: 1,
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10),
                  //     RotationTransition(
                  //       turns: _manualAnimation!,
                  //       child: IconButton(
                  //           onPressed: () {
                  //             /// 获取动画当前的值
                  //             var value = _manualController!.value;

                  //             /// 0.5代表 180弧度
                  //             if (value == 0) {
                  //               _manualController!.animateTo(0.5);
                  //             } else {
                  //               _manualController!.animateTo(0);
                  //             }
                  //             setState(() {
                  //               isExpand = !isExpand;
                  //             });
                  //           },
                  //           icon: const Icon(Icons.expand_less)),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      !widget.loadingStatus
                          ? widget.videoDetail!.title
                          : videoItem['title'],
                      // style: Theme.of(context).textTheme.titleMedium,
                      // maxLines: 2,
                    ),
                  ),
                  // const SizedBox(height: 5),
                  // 播放量、评论、日期
                  Row(
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
                        child: IconButton(
                          onPressed: () {
                            /// 获取动画当前的值
                            var value = _manualController!.value;

                            /// 0.5代表 180弧度
                            if (value == 0) {
                              _manualController!.animateTo(0.5);
                            } else {
                              _manualController!.animateTo(0);
                            }
                            setState(() {
                              isExpand = !isExpand;
                            });
                          },
                          icon: Icon(
                            Icons.expand_less,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 5),
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
                  _actionGrid(context),
                  // const SizedBox(height: 5),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  // 喜欢 投币 分享
  Widget _actionGrid(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: Colors.black12,
        height: constraints.maxWidth / 5,
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(0),
          crossAxisCount: 5,
          children: <Widget>[
            ActionItem(
                icon: const Icon(Icons.thumb_up),
                onTap: () => {},
                selectStatus: false,
                loadingStatus: widget.loadingStatus,
                text: !widget.loadingStatus
                    ? widget.videoDetail!.stat!.like!.toString()
                    : '-'),
            ActionItem(
                icon: const Icon(Icons.thumb_down),
                onTap: () => {},
                selectStatus: false,
                loadingStatus: widget.loadingStatus,
                text: '不喜欢'),
            ActionItem(
                icon: const Icon(Icons.generating_tokens),
                onTap: () => {},
                selectStatus: false,
                loadingStatus: widget.loadingStatus,
                text: !widget.loadingStatus
                    ? widget.videoDetail!.stat!.coin!.toString()
                    : '-'),
            ActionItem(
                icon: const Icon(Icons.star),
                onTap: () => {},
                selectStatus: false,
                loadingStatus: widget.loadingStatus,
                text: !widget.loadingStatus
                    ? widget.videoDetail!.stat!.favorite!.toString()
                    : '-'),
            ActionItem(
                icon: const Icon(Icons.share),
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
                color: selectStatus
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.outline),
            const SizedBox(height: 2),
            AnimatedOpacity(
              opacity: loadingStatus! ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: Text(
                text!,
                style: TextStyle(
                    color: selectStatus
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.outline,
                    fontSize: Theme.of(context).textTheme.labelSmall?.fontSize),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class RecommendList extends StatelessWidget {
  const RecommendList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Material(
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                '$index」 求推荐一些高质量的系统地介绍 ChatGPT 及相关技术的视频、文章或者书',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(height: 1.6),
              ),
            ),
          ),
        );
      }, childCount: 50),
    );
  }
}

class ActionGrid extends StatelessWidget {
  const ActionGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
