import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/read/opus.dart';
import 'package:pilipala/plugin/pl_gallery/hero_dialog_route.dart';
import 'package:pilipala/plugin/pl_gallery/interactiveviewer_gallery.dart';
import 'controller.dart';
import 'text_helper.dart';

class OpusPage extends StatefulWidget {
  const OpusPage({super.key});

  @override
  State<OpusPage> createState() => _OpusPageState();
}

class _OpusPageState extends State<OpusPage> {
  final OpusController controller = Get.put(OpusController());
  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = controller.fetchOpusData();
  }

  void onPreviewImg(picList, initIndex, context) {
    Navigator.of(context).push(
      HeroDialogRoute<void>(
        builder: (BuildContext context) => InteractiveviewerGallery(
          sources: picList,
          initIndex: initIndex,
          itemBuilder: (
            BuildContext context,
            int index,
            bool isFocus,
            bool enablePageView,
          ) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (enablePageView) {
                  Navigator.of(context).pop();
                }
              },
              child: Center(
                child: Hero(
                  tag: picList[index],
                  child: CachedNetworkImage(
                    fadeInDuration: const Duration(milliseconds: 0),
                    imageUrl: picList[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },
          onPageChanged: (int pageIndex) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                controller.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  height: 1.5,
                ),
              ),
            ),
            FutureBuilder(
              future: _futureBuilderFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return const SizedBox();
                  }
                  if (snapshot.data['status']) {
                    final modules = controller.opusData.value.detail!.modules!;
                    final ModuleStat moduleStat = modules.last.moduleStat!;
                    late ModuleContent moduleContent;
                    final int moduleIndex = modules
                        .indexWhere((module) => module.moduleContent != null);
                    if (moduleIndex != -1) {
                      moduleContent = modules[moduleIndex].moduleContent!;
                    } else {
                      print('No moduleContent found');
                    }
                    // 获取所有的图片链接
                    final List<String> picList = [];
                    for (var paragraph in moduleContent.paragraphs!) {
                      if (paragraph.paraType == 2) {
                        for (var pic in paragraph.pic!.pics!) {
                          picList.add(pic.url!);
                        }
                      }
                    }
                    return Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16,
                          MediaQuery.of(context).padding.bottom + 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: SelectableText.rich(
                              TextSpan(
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline,
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                                children: [
                                  TextSpan(
                                      text: '${moduleStat.comment!.count}评论'),
                                  const TextSpan(text: ' '),
                                  const TextSpan(text: ' '),
                                  TextSpan(text: '${moduleStat.like!.count}赞'),
                                  const TextSpan(text: ' '),
                                  const TextSpan(text: ' '),
                                  TextSpan(
                                      text: '${moduleStat.favorite!.count}转发'),
                                ],
                              ),
                            ),
                          ),
                          ...moduleContent.paragraphs!.map(
                            (ModuleParagraph paragraph) {
                              return Column(
                                children: [
                                  if (paragraph.paraType == 1) ...[
                                    Container(
                                      alignment: TextHelper.getAlignment(
                                          paragraph.align),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text.rich(
                                        TextSpan(
                                          children: paragraph.text?.nodes
                                                  ?.map((node) {
                                                return TextHelper.buildTextSpan(
                                                    node,
                                                    paragraph.align,
                                                    context);
                                              }).toList() ??
                                              [],
                                        ),
                                      ),
                                    )
                                  ] else if (paragraph.paraType == 2) ...[
                                    ...paragraph.pic?.pics?.map(
                                          (Pic pic) => Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: InkWell(
                                                onTap: () {
                                                  onPreviewImg(
                                                    picList,
                                                    picList.indexOf(pic.url!),
                                                    context,
                                                  );
                                                },
                                                child: NetworkImgLayer(
                                                  src: pic.url,
                                                  width: (Get.size.width - 32) *
                                                      pic.scale!,
                                                  height:
                                                      (Get.size.width - 32) *
                                                          pic.scale! /
                                                          pic.aspectRatio!,
                                                  type: 'emote',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ) ??
                                        [],
                                  ] else
                                    const SizedBox(),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    // 请求错误
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(snapshot.data['message']),
                      ),
                    );
                  }
                } else {
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
