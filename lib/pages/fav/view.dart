import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/pages/fav/index.dart';
import 'package:pilipala/pages/fav/widgets/item.dart';
import 'package:pilipala/utils/route_push.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  final FavController _favController = Get.put(FavController());
  late Future _futureBuilderFuture;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = _favController.queryFavFolder();
    scrollController = _favController.scrollController;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 300) {
          EasyThrottle.throttle('history', const Duration(seconds: 1), () {
            _favController.onLoad();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          '我的收藏',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(
                '/favSearch?searchType=1&mediaId=${_favController.favFolderData.value.list!.first.id}'),
            icon: const Icon(Icons.search_outlined),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: FutureBuilder(
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map? data = snapshot.data;
            if (data != null && data['status']) {
              return Obx(
                () => ListView.builder(
                  controller: scrollController,
                  itemCount: _favController.favFolderList.length,
                  itemBuilder: (context, index) {
                    return FavItem(
                        favFolderItem: _favController.favFolderList[index]);
                  },
                ),
              );
            } else {
              return CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  HttpError(
                    errMsg: data?['msg'] ?? '请求异常',
                    btnText: data?['code'] == -101 ? '去登录' : null,
                    fn: () {
                      if (data?['code'] == -101) {
                        RoutePush.loginRedirectPush();
                      } else {
                        setState(() {
                          _futureBuilderFuture =
                              _favController.queryFavFolder();
                        });
                      }
                    },
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
