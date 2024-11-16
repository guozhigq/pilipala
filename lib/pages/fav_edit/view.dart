import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class FavEditPage extends StatefulWidget {
  const FavEditPage({super.key});

  @override
  State<FavEditPage> createState() => _FavEditPageState();
}

class _FavEditPageState extends State<FavEditPage> {
  final FavEditController _favEditController = Get.put(FavEditController());
  String title = '';
  String content = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => _favEditController.type.value == 'add'
              ? Text(
                  '新建收藏夹',
                  style: Theme.of(context).textTheme.titleMedium,
                )
              : Text(
                  '编辑收藏夹',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
        ),
        actions: [
          Obx(
            () => _favEditController.privacy.value == 0
                ? IconButton(
                    onPressed: () {
                      _favEditController.privacy.value = 1;
                    },
                    icon: const Icon(Icons.lock_open_outlined))
                : IconButton(
                    onPressed: () {
                      _favEditController.privacy.value = 0;
                    },
                    icon: Icon(
                      Icons.lock_outlined,
                      color: Theme.of(context).colorScheme.error,
                    )),
          ),
          TextButton(
              onPressed: _favEditController.onSubmit, child: const Text('保存')),
          const SizedBox(width: 14),
        ],
      ),
      body: Form(
        key: _favEditController.formKey, //设置globalKey，用于后面获取FormState
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                  ),
                ),
              ),
              child: TextFormField(
                autofocus: true,
                controller: _favEditController.titleController,
                focusNode: _favEditController.titleTextFieldNode,
                decoration: const InputDecoration(
                  hintText: "收藏夹名称",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                // 校验标题
                validator: (v) {
                  return v!.trim().isNotEmpty ? null : "请输入收藏夹名称";
                },
                onChanged: (val) {
                  _favEditController.title = val;
                },
              ),
            ),
            Expanded(
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  child: TextFormField(
                    controller: _favEditController.contentController,
                    minLines: 1,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        hintText: '输入收藏夹简介', border: InputBorder.none),
                    style: Theme.of(context).textTheme.bodyLarge,
                    onChanged: (val) {
                      _favEditController.intro = val;
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
