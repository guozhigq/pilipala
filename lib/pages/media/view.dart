import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/pages/media/index.dart';
import 'package:pilipala/utils/utils.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage>
    with AutomaticKeepAliveClientMixin {
  late MediaController mediaController;
  late Future _futureBuilderFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    mediaController = Get.put(MediaController());
    _futureBuilderFuture = mediaController.queryFavFolder();

    mediaController.userLogin.listen((status) {
      setState(() {
        _futureBuilderFuture = mediaController.queryFavFolder();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Color primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(toolbarHeight: 30),
      body: Column(
        children: [
          ListTile(
            leading: null,
            title: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                '媒体库',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          for (var i in mediaController.list) ...[
            ListTile(
              onTap: () => i['onTap'](),
              dense: true,
              leading: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Icon(
                  i['icon'],
                  color: primary,
                ),
              ),
              contentPadding:
                  const EdgeInsets.only(left: 15, top: 2, bottom: 2),
              minLeadingWidth: 0,
              title: Text(
                i['title'],
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ],
      ),
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
      child: GestureDetector(
        onTap: () => Get.toNamed('/favDetail',
            arguments: item,
            parameters: {'mediaId': item!.id.toString(), 'heroTag': heroTag}),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 180,
              height: 110,
              margin: const EdgeInsets.only(bottom: 8),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.onInverseSurface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    offset: const Offset(4, -12), // 阴影与容器的距离
                    blurRadius: 0.0, // 高斯的标准偏差与盒子的形状卷积。
                    spreadRadius: 0.0, // 在应用模糊之前，框应该膨胀的量。
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, BoxConstraints box) {
                  return Hero(
                    tag: heroTag,
                    child: NetworkImgLayer(
                      src: item!.cover,
                      width: box.maxWidth,
                      height: box.maxHeight,
                    ),
                  );
                },
              ),
            ),
            Text(
              ' ${item!.title}',
              overflow: TextOverflow.fade,
              maxLines: 1,
            ),
            Text(
              ' 共${item!.mediaCount}条视频',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall!
                  .copyWith(color: Theme.of(context).colorScheme.outline),
            )
          ],
        ),
      ),
    );
  }
}
