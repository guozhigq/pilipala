import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/pages/fav/index.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  final FavController _favController = Get.put(FavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('我的收藏'),
      ),
      body: FutureBuilder(
        future: _favController.queryFavFolder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map data = snapshot.data as Map;
            if (data['status']) {
              return Obx(
                () => ListView.builder(
                  itemCount: _favController.favFolderData.value.list!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => Get.toNamed(
                        '/favDetail',
                        arguments:
                            _favController.favFolderData.value.list![index],
                        parameters: {
                          'mediaId': _favController
                              .favFolderData.value.list![index].id
                              .toString(),
                        },
                      ),
                      leading: const Icon(Icons.folder_special_outlined),
                      minLeadingWidth: 0,
                      title: Text(_favController
                          .favFolderData.value.list![index].title!),
                      subtitle: Text(
                        '${_favController.favFolderData.value.list![index].mediaCount}个内容',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .fontSize),
                      ),
                    );
                  },
                ),
              );
            } else {
              return CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  HttpError(
                    errMsg: data['msg'],
                    fn: () => setState(() {}),
                  ),
                ],
              );
            }
          } else {
            // 骨架屏
            return const Text('请求中');
          }
        },
      ),
    );
  }
}
