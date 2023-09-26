import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/models/video_detail_res.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/utils/id_utils.dart';

class SeasonPanel extends StatefulWidget {
  final UgcSeason ugcSeason;
  final int? cid;
  final double? sheetHeight;
  final Function? changeFuc;

  const SeasonPanel({
    super.key,
    required this.ugcSeason,
    this.cid,
    this.sheetHeight,
    this.changeFuc,
  });

  @override
  State<SeasonPanel> createState() => _SeasonPanelState();
}

class _SeasonPanelState extends State<SeasonPanel> {
  late List<EpisodeItem> episodes;
  late int cid;
  late int currentIndex;
  String heroTag = Get.arguments['heroTag'];
  late VideoDetailController _videoDetailController;

  @override
  void initState() {
    super.initState();
    cid = widget.cid!;
    _videoDetailController = Get.find<VideoDetailController>(tag: heroTag);

    /// 根据 cid 找到对应集，找到对应 episodes
    /// 有多个episodes时，只显示其中一个
    /// TODO 同时显示多个合集
    List<SectionItem> sections = widget.ugcSeason.sections!;
    for (int i = 0; i < sections.length; i++) {
      List<EpisodeItem> episodesList = sections[i].episodes!;
      for (int j = 0; j < episodesList.length; j++) {
        if (episodesList[j].cid == cid) {
          episodes = episodesList;
          continue;
        }
      }
    }

    /// 取对应 season_id 的 episodes
    // episodes = widget.ugcSeason.sections!
    //     .firstWhere((e) => e.seasonId == widget.ugcSeason.id)
    //     .episodes!;
    currentIndex = episodes.indexWhere((e) => e.cid == cid);
    _videoDetailController.cid.listen((p0) {
      cid = p0;
      setState(() {});
      currentIndex = episodes.indexWhere((e) => e.cid == cid);
    });
  }

  void changeFucCall(item, i) async {
    await widget.changeFuc!(
      IdUtils.av2bv(item.aid),
      item.cid,
      item.aid,
    );
    currentIndex = i;
    setState(() {});
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
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
            onTap: () => showBottomSheet(
              context: context,
              builder: (_) => Container(
                height: widget.sheetHeight,
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  children: [
                    Container(
                      height: 45,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '合集（${episodes.length}）',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Theme.of(context).dividerColor.withOpacity(0.1),
                    ),
                    Expanded(
                      child: Material(
                        child: ListView.builder(
                          itemCount: episodes.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () =>
                                  changeFucCall(episodes[index], index),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 15, right: 15),
                                child: Text(
                                  episodes[index].title!,
                                  style: TextStyle(
                                      color: index == currentIndex
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '合集：${widget.ugcSeason.title!}',
                      style: Theme.of(context).textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Image.asset(
                    'assets/images/live.gif',
                    color: Theme.of(context).colorScheme.primary,
                    height: 12,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${currentIndex + 1}/${episodes.length}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
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

// Widget seasonPanel(UgcSeason ugcSeason, cid, sheetHeight) {
//   return Builder(builder: (context) {
//     List<EpisodeItem> episodes = ugcSeason.sections!.first.episodes!;
//     int currentIndex = episodes.indexWhere((e) => e.cid == cid);
//     return Container(
//       margin: const EdgeInsets.only(
//         top: 8,
//         left: 2,
//         right: 2,
//         bottom: 2,
//       ),
//       child: Material(
//         color: Theme.of(context).colorScheme.onInverseSurface,
//         borderRadius: BorderRadius.circular(6),
//         clipBehavior: Clip.hardEdge,
//         child: InkWell(
//           onTap: () => showBottomSheet(
//             context: context,
//             builder: (_) => Container(
//               height: sheetHeight,
//               color: Theme.of(context).colorScheme.background,
//               child: Column(
//                 children: [
//                   Container(
//                     height: 45,
//                     padding: const EdgeInsets.only(left: 14, right: 14),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '合集（${episodes.length}）',
//                           style: Theme.of(context).textTheme.titleMedium,
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.close),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(
//                     height: 1,
//                     color: Theme.of(context).dividerColor.withOpacity(0.1),
//                   ),
//                   Expanded(
//                     child: Material(
//                       child: ListView.builder(
//                         itemCount: episodes.length,
//                         itemBuilder: (context, index) {
//                           return InkWell(
//                             onTap: () {},
//                             child: Padding(
//                               padding: const EdgeInsets.only(
//                                   top: 10, bottom: 10, left: 15, right: 15),
//                               child: Text(
//                                 episodes[index].title!,
//                                 style: TextStyle(
//                                     color: index == currentIndex
//                                         ? Theme.of(context).colorScheme.primary
//                                         : Theme.of(context)
//                                             .colorScheme
//                                             .onSurface),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     '合集：${ugcSeason.title!}',
//                     style: Theme.of(context).textTheme.labelMedium,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 const SizedBox(width: 15),
//                 Image.asset(
//                   'assets/images/live.gif',
//                   color: Theme.of(context).colorScheme.primary,
//                   height: 12,
//                 ),
//                 const SizedBox(width: 10),
//                 Text(
//                   '${currentIndex + 1}/${ugcSeason.epCount}',
//                   style: Theme.of(context).textTheme.labelMedium,
//                 ),
//                 const SizedBox(width: 6),
//                 const Icon(
//                   Icons.arrow_forward_ios_outlined,
//                   size: 13,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   });
// }
