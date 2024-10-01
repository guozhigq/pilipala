import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class MineEditPage extends StatefulWidget {
  const MineEditPage({super.key});

  @override
  State<MineEditPage> createState() => _MineEditPageState();
}

class _MineEditPageState extends State<MineEditPage> {
  final MineEditController ctr = Get.put(MineEditController());
  late Future _futureBuilderFuture;

  @override
  void initState() {
    super.initState();
    _futureBuilderFuture = ctr.getAccountInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑资料'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: _futureBuilderFuture,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return const SizedBox();
                }
                if (snapshot.data['status']) {
                  return Form(
                    key: ctr.formKey,
                    child: Column(
                      children: [
                        // 用户头像
                        // InkWell(
                        //   onTap: () {},
                        //   child: CircleAvatar(
                        //     radius: 50,
                        //     backgroundColor: Colors.transparent,
                        //     backgroundImage:
                        //         NetworkImage(ctr.userInfo.face), // 替换为实际的头像路径
                        //   ),
                        // ),
                        const SizedBox(height: 24.0),
                        // 昵称
                        TextFormField(
                          controller: ctr.unameCtr,
                          decoration: const InputDecoration(
                            labelText: '昵称',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入昵称';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        // 用户名
                        TextFormField(
                          controller: ctr.useridCtr,
                          decoration: const InputDecoration(
                            labelText: '用户名',
                            border: OutlineInputBorder(),
                            enabled: false,
                          ),
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入用户名';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        // 签名
                        TextFormField(
                          controller: ctr.signCtr,
                          decoration: const InputDecoration(
                            labelText: '签名',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入签名';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        // 性别
                        DropdownButtonFormField<String>(
                          value: ctr.sex,
                          decoration: const InputDecoration(
                            labelText: '性别',
                            border: OutlineInputBorder(),
                          ),
                          items: ['男', '女', '保密'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            ctr.sex = newValue;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请选择性别';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        // 出生日期
                        TextFormField(
                          controller: ctr.birthdayCtr,
                          decoration: const InputDecoration(
                            labelText: '出生日期',
                            border: OutlineInputBorder(),
                          ),
                          enabled: false,
                          readOnly: true,
                          onTap: () async {
                            // DateTime? pickedDate = await showDatePicker(
                            //   context: context,
                            //   initialDate: DateTime(1995, 12, 23),
                            //   firstDate: DateTime(1900),
                            //   lastDate: DateTime(2100),
                            // );
                            // if (pickedDate != null) {
                            //   ctr.birthdayCtr.text =
                            //       "${pickedDate.toLocal()}".split(' ')[0];
                            // }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请选择出生日期';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30.0),
                        // 提交按钮
                        ElevatedButton(
                          onPressed: () {
                            if (ctr.formKey.currentState!.validate()) {
                              // 处理表单提交
                              ctr.updateAccountInfo();
                            }
                          },
                          child: const Text('提交'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              } else {
                return const SizedBox();
              }
            })),
      ),
    );
  }
}
