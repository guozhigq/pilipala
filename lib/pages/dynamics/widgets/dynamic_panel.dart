import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilipala/pages/dynamics/index.dart';
import 'action_panel.dart';
import 'author_panel.dart';
import 'content_panel.dart';
import 'forward_panel.dart';

class DynamicPanel extends StatelessWidget {
  var item;
  String? source;
  DynamicPanel({this.item, this.source, Key? key}) : super(key: key);
  final DynamicsController _dynamicsController = Get.put(DynamicsController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: source == 'detail'
          ? const EdgeInsets.only(bottom: 12)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 8,
            color: Theme.of(context).dividerColor.withOpacity(0.05),
          ),
        ),
      ),
      child: Material(
        elevation: 0,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: InkWell(
          onTap: () => _dynamicsController.pushDetail(item, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              author(item, context),
              if (item!.modules!.moduleDynamic!.desc != null)
                content(item, context, source),
              forWard(item, context, _dynamicsController, source),
              const SizedBox(height: 2),
              if (source == null) ActionPanel(item: item),
            ],
          ),
        ),
      ),
    );
  }
}
