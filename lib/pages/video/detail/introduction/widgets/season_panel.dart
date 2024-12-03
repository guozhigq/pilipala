import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/pages_bottom_sheet.dart';
import 'package:pilipala/models/video_detail_res.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/utils/id_utils.dart';
import '../../../../../models/common/video_episode_type.dart';
import '../controller.dart';

class SeasonPanel extends StatefulWidget {
  const SeasonPanel({
    super.key,
    required this.ugcSeason,
    this.cid,
    this.sheetHeight,
    this.changeFuc,
    required this.videoIntroCtr,
  });
  final UgcSeason ugcSeason;
  final int? cid;
  final double? sheetHeight;
  final Function? changeFuc;
  final VideoIntroController videoIntroCtr;

  @override
  State<SeasonPanel> createState() => _SeasonPanelState();
}

class _SeasonPanelState extends State<SeasonPanel> {
  List<EpisodeItem>? episodes;
  late int cid;
  late RxInt currentIndex = (-1).obs;
  final String heroTag = Get.arguments['heroTag'];
  late VideoDetailController _videoDetailController;
  late PersistentBottomSheetController? _bottomSheetController;
  int currentEpisodeIndex = -1;

  @override
  void initState() {
    super.initState();
    cid = widget.cid!;
    _videoDetailController = Get.find<VideoDetailController>(tag: heroTag);

    /// 根据 cid 找到对应集，找到对应 episodes
    getCurrentEpisodeIndex();

    /// 取对应 season_id 的 episodes
    getCurrentIndex();
    _videoDetailController.cid.listen((int p0) {
      cid = p0;
      getCurrentIndex();
      getCurrentEpisodeIndex();
    });
  }

  void changeFucCall(item, int i) async {
    widget.changeFuc?.call(
      IdUtils.av2bv(item.aid),
      item.cid,
      item.aid,
      item.cover,
    );
    currentIndex.value = i;
    _bottomSheetController?.close();
  }

  // 获取currentIndex
  void getCurrentIndex() {
    if (episodes != null) {
      currentIndex.value =
          episodes!.indexWhere((EpisodeItem e) => e.cid == cid);
    }
    final List<SectionItem> sections = widget.ugcSeason.sections!;
    if (sections.length == 1 && sections.first.type == 1) {
      final List<EpisodeItem> episodesList = sections.first.episodes!;
      for (int i = 0; i < episodesList.length; i++) {
        for (int j = 0; j < episodesList[i].pages!.length; j++) {
          if (episodesList[i].pages![j].cid == cid) {
            currentIndex.value = i;
            episodes = episodesList;
            continue;
          }
        }
      }
    }
  }

  // 获取currentEpisodeIndex
  void getCurrentEpisodeIndex() {
    final List<SectionItem> sections = widget.ugcSeason.sections!;
    for (int i = 0; i < sections.length; i++) {
      final List<EpisodeItem> episodesList = sections[i].episodes!;
      for (int j = 0; j < episodesList.length; j++) {
        if (episodesList[j].cid == cid) {
          currentEpisodeIndex = i;
          episodes = episodesList;
          continue;
        }
      }
    }
  }

  Widget buildEpisodeListItem(
    EpisodeItem episode,
    int index,
    bool isCurrentIndex,
  ) {
    Color primary = Theme.of(context).colorScheme.primary;
    return ListTile(
      onTap: () => changeFucCall(episode, index),
      dense: false,
      leading: isCurrentIndex
          ? Image.asset(
              'assets/images/live.png',
              color: primary,
              height: 12,
            )
          : null,
      title: Text(
        episode.title!,
        style: TextStyle(
          fontSize: 14,
          color: isCurrentIndex
              ? primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return Container(
        margin: const EdgeInsets.only(
          top: 8,
          left: 2,
          right: 2,
          bottom: 2,
        ),
        child: Material(
          color: Theme.of(context).colorScheme.onInverseSurface,
          borderRadius: BorderRadius.circular(6),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              widget.videoIntroCtr.bottomSheetController =
                  _bottomSheetController = EpisodeBottomSheet(
                currentCid: cid,
                episodes: episodes!,
                changeFucCall: changeFucCall,
                sheetHeight: widget.sheetHeight,
                dataType: VideoEpidoesType.videoEpisode,
                ugcSeason: widget.ugcSeason,
                currentEpisodeIndex: currentEpisodeIndex,
                currentIndex: currentIndex.value,
              ).show(context);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '合集：${widget.ugcSeason.title!}',
                      style: Theme.of(context).textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Image.asset(
                    'assets/images/live.png',
                    color: Theme.of(context).colorScheme.primary,
                    height: 12,
                  ),
                  const SizedBox(width: 10),
                  Obx(() => Text(
                        '${currentIndex.value + 1}/${episodes!.length}',
                        style: Theme.of(context).textTheme.labelMedium,
                      )),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 13,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
