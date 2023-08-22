import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/common/widgets/video_card_h.dart';
import 'package:pilipala/models/common/search_type.dart';
import 'package:pilipala/pages/searchPanel/index.dart';

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
          padding: const EdgeInsets.only(top: 34),
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
                child: VideoCardH(videoItem: i),
              );
            },
          ),
        ),
        // 分类筛选
        Container(
          width: double.infinity,
          height: 34,
          padding: const EdgeInsets.only(left: 8, top: 0, right: 12),
          // decoration: BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(
          //       color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          //     ),
          //   ),
          // ),
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
                        ctr!.order.value = i['type'].toString().split('.').last;
                        SmartDialog.showLoading(msg: 'loooad');
                        await ctr!.onRefresh();
                        SmartDialog.dismiss();
                      },
                    ),
                  ]
                ],
              ),
            ),
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
      height: 32,
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

  onSelect() {}
}
