import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/user/fav_folder.dart';
import 'package:pilipala/pages/media/index.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage>
    with AutomaticKeepAliveClientMixin {
  final MediaController _mediaController = Get.put(MediaController());
  Future? _futureBuilderFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _mediaController.queryFavFolder();
  }

  @override
  Widget build(BuildContext context) {
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
          for (var i in _mediaController.list) ...[
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
          favFolder()
        ],
      ),
    );
  }

  Widget favFolder() {
    return Column(
      children: [
        Divider(
          height: 35,
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
        ListTile(
          onTap: () {},
          leading: null,
          dense: true,
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Obx(
              () => Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '收藏夹 ',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleMedium!.fontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    if (_mediaController.favFolderData.value.count != null)
                      TextSpan(
                        text: _mediaController.favFolderData.value.count
                            .toString(),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleSmall!.fontSize,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          trailing: IconButton(
            onPressed: () => _mediaController.queryFavFolder(),
            icon: const Icon(
              Icons.refresh,
              size: 20,
            ),
          ),
        ),
        // const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 170,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 20),
              FutureBuilder(
                  future: _futureBuilderFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map data = snapshot.data;
                      if (data['status']) {
                        return Obx(() => Row(
                              children: [
                                if (_mediaController.favFolderData.value.list !=
                                    null) ...[
                                  for (FavFolderItemData i in _mediaController
                                      .favFolderData.value.list!) ...[
                                    FavFolderItem(item: i),
                                    const SizedBox(width: 14)
                                  ]
                                ]
                              ],
                            ));
                      } else {
                        return SizedBox(
                          height: 160,
                          child: Center(child: Text(data['msg'])),
                        );
                      }
                    } else {
                      // 骨架屏
                      return SizedBox();
                    }
                  }),
              // for (var i in [1, 2, 3]) ...[const FavFolderItem()],
              const SizedBox(width: 10)
            ],
          ),
        ),
      ],
    );
  }
}

class FavFolderItem extends StatelessWidget {
  FavFolderItem({super.key, this.item});
  FavFolderItemData? item;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/favDetail', arguments: item, parameters: {
        'mediaId': item!.id.toString(),
      }),
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
                return NetworkImgLayer(
                  src: item!.cover,
                  width: box.maxWidth,
                  height: box.maxHeight,
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
    );
  }
}
