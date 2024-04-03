import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/pages/search_panel/index.dart';

class SearchVideoPanel extends StatelessWidget {
  SearchVideoPanel({
    this.ctr,
    this.list,
    Key? key,
  }) : super(key: key);

  final SearchPanelController? ctr;
  final List? list;

  final VideoPanelController controller = Get.put(VideoPanelController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 36),
          child: ListView.builder(
            controller: ctr!.scrollController,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            itemCount: list!.length,
            itemBuilder: (context, index) {
              var i = list![index];
              return Padding(
                padding: index == 0
                    ? const EdgeInsets.only(top: 2)
                    : EdgeInsets.zero,
                child: VideoCardH(videoItem: i, showPubdate: true),
              );
            },
          ),
        ),
        // 分类筛选
        Container(
          width: double.infinity,
          height: 36,
          padding: const EdgeInsets.only(left: 8, top: 0, right: 12),
          // decoration: BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(
          //       color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          //     ),
          //   ),
          // ),
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
                              ctr!.order.value =
                                  i['type'].toString().split('.').last;
                              SmartDialog.showLoading(msg: 'loading');
                              await ctr!.onRefresh();
                              SmartDialog.dismiss();
                            },
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
              const VerticalDivider(indent: 7, endIndent: 8),
              const SizedBox(width: 3),
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () => controller.onShowFilterDialog(ctr),
                  icon: Icon(
                    Icons.filter_list_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ), // 放置在ListView.builder()上方的组件
      ],
    );
  }
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
  final ArchiveFilterType? type;
  final ArchiveFilterType? selectedType;
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

class VideoPanelController extends GetxController {
  RxList<Map> filterList = [{}].obs;
  Rx<ArchiveFilterType> selectedType = ArchiveFilterType.values.first.obs;
  List<Map<String, dynamic>> timeFiltersList = [
    {'label': '全部时长', 'value': 0},
    {'label': '0-10分钟', 'value': 1},
    {'label': '10-30分钟', 'value': 2},
    {'label': '30-60分钟', 'value': 3},
    {'label': '60分钟+', 'value': 4},
  ];
  RxInt currentTimeFilterval = 0.obs;

  @override
  void onInit() {
    List<Map<String, dynamic>> list = ArchiveFilterType.values
        .map((type) => {
              'label': type.description,
              'type': type,
            })
        .toList();
    filterList.value = list;
    super.onInit();
  }

  onShowFilterDialog(searchPanelCtr) {
    SmartDialog.show(
      animationType: SmartAnimationType.centerFade_otherSlide,
      builder: (BuildContext context) {
        TextStyle textStyle = Theme.of(context).textTheme.titleMedium!;
        return AlertDialog(
          title: const Text('时长筛选'),
          contentPadding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
          content: StatefulBuilder(builder: (context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i in timeFiltersList) ...[
                  RadioListTile(
                    value: i['value'],
                    autofocus: true,
                    title: Text(i['label'], style: textStyle),
                    groupValue: currentTimeFilterval.value,
                    onChanged: (value) async {
                      currentTimeFilterval.value = value!;
                      setState(() {});
                      SmartDialog.dismiss();
                      SmartDialog.showToast("「${i['label']}」的筛选结果");
                      SearchPanelController ctr =
                          Get.find<SearchPanelController>(
                              tag: 'video${searchPanelCtr.keyword!}');
                      ctr.duration.value = i['value'];
                      SmartDialog.showLoading(msg: 'loading');
                      await ctr.onRefresh();
                      SmartDialog.dismiss();
                    },
                  ),
                ],
              ],
            );
          }),
        );
      },
    );
  }
}
