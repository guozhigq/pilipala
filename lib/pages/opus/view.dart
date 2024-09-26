import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/read/opus.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            _buildFutureContent(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: StreamBuilder(
        stream: controller.appbarStream.stream.distinct(),
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return AnimatedOpacity(
            opacity: snapshot.data ? 1 : 0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 500),
            child: Obx(
              () => Text(
                controller.title.value,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () {},
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Obx(
        () => Text(
          controller.title.value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildFutureContent() {
    return FutureBuilder(
      future: _futureBuilderFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const SizedBox();
          }
          if (snapshot.data['status']) {
            return _buildContent(controller.opusData.value);
          } else {
            return _buildError(snapshot.data['message']);
          }
        } else {
          return _buildLoading();
        }
      },
    );
  }

  Widget _buildContent(OpusDataModel opusData) {
    final modules = opusData.detail!.modules!;
    late ModuleContent moduleContent;
    // 获取所有的图片链接
    final List<String> picList = [];
    final int moduleIndex =
        modules.indexWhere((module) => module.moduleContent != null);
    if (moduleIndex != -1) {
      moduleContent = modules[moduleIndex].moduleContent!;
      for (var paragraph in moduleContent.paragraphs!) {
        if (paragraph.paraType == 2) {
          for (var pic in paragraph.pic!.pics!) {
            picList.add(pic.url!);
          }
        }
      }
    } else {
      print('No moduleContent found');
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 0, 16, MediaQuery.of(context).padding.bottom + 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: _buildStatsWidget(opusData),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildAuthorWidget(opusData),
          ),
          ...moduleContent.paragraphs!.map(
            (ModuleParagraph paragraph) {
              return Column(
                children: [
                  if (paragraph.paraType == 1) ...[
                    Container(
                      alignment: TextHelper.getAlignment(paragraph.align),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Text.rich(
                        TextSpan(
                          children: paragraph.text?.nodes?.map((node) {
                                return TextHelper.buildTextSpan(
                                    node, paragraph.align, context);
                              }).toList() ??
                              [],
                        ),
                      ),
                    )
                  ] else if (paragraph.paraType == 2) ...[
                    ...paragraph.pic?.pics?.map(
                          (Pic pic) => Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: InkWell(
                                onTap: () {
                                  controller.onPreviewImg(
                                    picList,
                                    picList.indexOf(pic.url!),
                                    context,
                                  );
                                },
                                child: NetworkImgLayer(
                                  src: pic.url,
                                  width: (Get.size.width - 32) * pic.scale!,
                                  height: (Get.size.width - 32) *
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
  }

  Widget _buildAuthorWidget(OpusDataModel opusData) {
    final modules = opusData.detail!.modules!;
    late ModuleAuthor moduleAuthor;
    final int moduleIndex =
        modules.indexWhere((module) => module.moduleAuthor != null);
    if (moduleIndex != -1) {
      moduleAuthor = modules[moduleIndex].moduleAuthor!;
    } else {
      return const SizedBox();
    }
    return Row(
      children: [
        NetworkImgLayer(
          width: 48,
          height: 48,
          type: 'avatar',
          src: moduleAuthor.face,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              moduleAuthor.name!,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            StyledText(moduleAuthor.pubTime!),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsWidget(OpusDataModel opusData) {
    final modules = opusData.detail!.modules!;
    final ModuleStat moduleStat = modules.last.moduleStat!;
    return Row(
      children: [
        StyledText('${moduleStat.comment!.count}评论'),
        const SizedBox(width: 10),
        StyledText('${moduleStat.like!.count}赞'),
        const SizedBox(width: 10),
        StyledText('${moduleStat.favorite!.count}转发'),
      ],
    );
  }

  Widget _buildError(String message) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(message),
      ),
    );
  }

  Widget _buildLoading() {
    return const SizedBox(
      height: 100,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class StyledText extends StatelessWidget {
  final String text;

  const StyledText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
