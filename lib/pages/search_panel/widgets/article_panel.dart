import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/constants.dart';
import 'package:pilipala/common/widgets/http_error.dart';
import 'package:pilipala/common/widgets/network_img_layer.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/pages/search_panel/index.dart';
import 'package:pilipala/utils/utils.dart';

class SearchArticlePanel extends StatelessWidget {
  SearchArticlePanel({
    required this.ctr,
    this.list,
    Key? key,
  }) : super(key: key);

  final SearchPanelController ctr;
  final List? list;

  final ArticlePanelController controller = Get.put(ArticlePanelController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        searchArticlePanel(context, ctr, list),
        Container(
          width: double.infinity,
          height: 36,
          padding: const EdgeInsets.only(left: 8, top: 0, right: 8),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(
                    () => Wrap(
                      // spacing: ,
                      children: [
                        for (var i in controller.filterList) ...[
                          CustomFilterChip(
                            label: i['label'],
                            type: i['type'],
                            selectedType: controller.selectedType.value,
                            callFn: (bool selected) async {
                              controller.selectedType.value = i['type'];
                              ctr.order.value =
                                  i['type'].toString().split('.').last;
                              SmartDialog.showLoading(msg: 'loading');
                              await ctr.onRefresh();
                              SmartDialog.dismiss();
                            },
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget searchArticlePanel(BuildContext context, ctr, list) {
  TextStyle textStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
      color: Theme.of(context).colorScheme.outline);
  return Padding(
    padding: const EdgeInsets.only(top: 36),
    child: list!.isNotEmpty
        ? ListView.builder(
            controller: ctr!.scrollController,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.toNamed('/read', parameters: {
                    'title': list[index].subTitle,
                    'id': list[index].id.toString(),
                    'articleType': 'read'
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      StyleString.safeSpace, 5, StyleString.safeSpace, 5),
                  child: LayoutBuilder(builder: (context, boxConstraints) {
                    final double width = (boxConstraints.maxWidth -
                            StyleString.cardSpace *
                                6 /
                                MediaQuery.textScalerOf(context).scale(1.0)) /
                        2;
                    return Container(
                      constraints: const BoxConstraints(minHeight: 88),
                      height: width / StyleString.aspectRatio,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (list[index].imageUrls != null &&
                              list[index].imageUrls.isNotEmpty)
                            AspectRatio(
                              aspectRatio: StyleString.aspectRatio,
                              child: LayoutBuilder(
                                  builder: (context, boxConstraints) {
                                double maxWidth = boxConstraints.maxWidth;
                                double maxHeight = boxConstraints.maxHeight;
                                return NetworkImgLayer(
                                  width: maxWidth,
                                  height: maxHeight,
                                  src: list[index].imageUrls.first,
                                );
                              }),
                            ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 2, 6, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    maxLines: 2,
                                    text: TextSpan(
                                      children: [
                                        for (var i in list[index].title) ...[
                                          TextSpan(
                                            text: i['text'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.3,
                                              color: i['type'] == 'em'
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                            ),
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                      Utils.dateFormat(list[index].pubTime,
                                          formatType: 'detail'),
                                      style: textStyle),
                                  Row(
                                    children: [
                                      Text('${list[index].view}浏览',
                                          style: textStyle),
                                      Text(' • ', style: textStyle),
                                      Text('${list[index].reply}评论',
                                          style: textStyle),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              );
            },
          )
        : HttpError(
            errMsg: '没有数据',
            isShowBtn: false,
            fn: () => {},
            isInSliver: false,
          ),
  );
}

class CustomFilterChip extends StatelessWidget {
  const CustomFilterChip({
    this.label,
    this.type,
    this.selectedType,
    this.callFn,
    Key? key,
  }) : super(key: key);

  final String? label;
  final ArticleFilterType? type;
  final ArticleFilterType? selectedType;
  final Function? callFn;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: FilterChip(
        padding: const EdgeInsets.only(left: 11, right: 11),
        labelPadding: EdgeInsets.zero,
        label: Text(
          label!,
          style: const TextStyle(fontSize: 13),
        ),
        labelStyle: TextStyle(
            color: type == selectedType
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline),
        selected: type == selectedType,
        showCheckmark: false,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        selectedColor: Colors.transparent,
        // backgroundColor:
        //     Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        backgroundColor: Colors.transparent,
        side: BorderSide.none,
        onSelected: (bool selected) => callFn!(selected),
      ),
    );
  }
}

class ArticlePanelController extends GetxController {
  RxList<Map> filterList = [{}].obs;
  Rx<ArticleFilterType> selectedType = ArticleFilterType.values.first.obs;

  @override
  void onInit() {
    List<Map<String, dynamic>> list = ArticleFilterType.values
        .map((type) => {
              'label': type.description,
              'type': type,
            })
        .toList();
    filterList.value = list;
    super.onInit();
  }
}
