import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:pilipala/http/fav.dart';

class FavEditController extends GetxController {
  final GlobalKey formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final FocusNode titleTextFieldNode = FocusNode();
  final FocusNode contentTextFieldNode = FocusNode();

  // 默认新建
  RxString type = 'add'.obs;

  String? mediaId;
  String cover = ''; // 封面
  String title = ''; // 名称
  String intro = ''; // 简介
  RxInt privacy = 0.obs; // 是否公开 0公开 1私密

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    if (args != null) {
      type.value = 'edit';
      mediaId = args['mediaId'];
      title = args['title'];
      intro = args['intro'];
      cover = args['cover'];
      privacy.value = args['privacy'];
      titleController.text = title;
      contentController.text = intro;
    }
  }

  void onSubmit() async {
    // 表单验证
    if ((formKey.currentState as FormState).validate()) {
      if (type.value == 'edit') {
        await editFolder();
      } else {
        await addFolder();
      }
    }
  }

  Future<void> editFolder() async {
    var res = await FavHttp.editFolder(
      title: title,
      intro: intro,
      mediaId: mediaId!,
      cover: cover,
      privacy: privacy.value,
    );
    if (res['status']) {
      SmartDialog.showToast('编辑成功');
      Get.back(result: {'title': title});
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  Future<void> addFolder() async {
    var res = await FavHttp.addFolder(
      title: title,
      intro: intro,
    );
    if (res['status']) {
      SmartDialog.showToast('新建成功');
      Get.back();
    } else {
      SmartDialog.showToast(res['msg']);
    }
  }

  void togglePrivacy() {
    if (privacy.value == 0) {
      privacy.value = 1;
      SmartDialog.showToast('设置为私密后，只有自己可见');
    } else {
      privacy.value = 0;
      SmartDialog.showToast('设置为公开后，所有人可见');
    }
  }
}
