import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginPageController _loginPageCtr = Get.put(LoginPageController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Obx(
          () => _loginPageCtr.currentIndex.value == 0
              ? IconButton(
                  onPressed: () async {
                    _loginPageCtr.mobTextFieldNode.unfocus();
                    await Future.delayed(const Duration(milliseconds: 200));
                    Get.back();
                  },
                  icon: const Icon(Icons.close_outlined),
                )
              : IconButton(
                  onPressed: () => _loginPageCtr.previousPage(),
                  icon: const Icon(Icons.arrow_back),
                ),
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _loginPageCtr.pageViewController,
        onPageChanged: (int index) => _loginPageCtr.onPageChange(index),
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: MediaQuery.of(context).padding.bottom + 10,
            ),
            child: Form(
              key: _loginPageCtr.mobFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    '登录',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        letterSpacing: 1,
                        height: 2.1,
                        fontSize: 34,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Text(
                        '请使用您的 BiliBili 账号登录。',
                        style: Theme.of(context).textTheme.titleSmall!,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(Icons.info_outline, size: 16),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 38, bottom: 15),
                    child: TextFormField(
                      controller: _loginPageCtr.mobTextController,
                      focusNode: _loginPageCtr.mobTextFieldNode,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: '输入手机号码',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                      // 校验用户名
                      validator: (v) {
                        return v!.trim().isNotEmpty ? null : "手机号码不能为空";
                      },
                      onSaved: (val) {
                        print(val);
                      },
                      onEditingComplete: () {
                        _loginPageCtr.nextStep();
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offNamed(
                        '/webview',
                        parameters: {
                          'url':
                              'https://passport.bilibili.com/h5-app/passport/login',
                          'type': 'login',
                          'pageTitle': '登录bilibili',
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        '使用网页端登录',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(onPressed: () {}, child: const Text('中国大陆')),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary, // 设置按钮背景色
                        ),
                        onPressed: () => _loginPageCtr.nextStep(),
                        child: const Text('下一步'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: MediaQuery.of(context).padding.bottom + 10,
            ),
            child: Obx(
              () => _loginPageCtr.loginType.value == 0
                  ? Form(
                      key: _loginPageCtr.passwordFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Text(
                                '密码登录',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        letterSpacing: 1,
                                        height: 2.1,
                                        fontSize: 34,
                                        fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    return Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1);
                                  }),
                                ),
                                onPressed: () =>
                                    _loginPageCtr.changeLoginType(),
                                icon: const Icon(Icons.swap_vert_outlined),
                              )
                            ],
                          ),
                          Text(
                            '请输入您的 BiliBili 密码。',
                            style: Theme.of(context).textTheme.titleSmall!,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 38, bottom: 15),
                            child: TextFormField(
                              controller: _loginPageCtr.passwordTextController,
                              focusNode: _loginPageCtr.passwordTextFieldNode,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: '输入密码',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                              ),
                              // 校验用户名
                              validator: (v) {
                                return v!.trim().isNotEmpty ? null : "密码不能为空";
                              },
                              onSaved: (val) {
                                print(val);
                              },
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _loginPageCtr.previousPage(),
                                child: const Text('上一步'),
                              ),
                              const SizedBox(width: 15),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primary, // 设置按钮背景色
                                ),
                                onPressed: () =>
                                    _loginPageCtr.loginInByAppPassword(),
                                child: const Text('确认登录'),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : Form(
                      key: _loginPageCtr.msgCodeFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Text(
                                '验证码登录',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        letterSpacing: 1,
                                        height: 2.1,
                                        fontSize: 34,
                                        fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    return Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.1);
                                  }),
                                ),
                                onPressed: () =>
                                    _loginPageCtr.changeLoginType(),
                                icon: const Icon(Icons.swap_vert_outlined),
                              )
                            ],
                          ),
                          Text(
                            '请输入收到到验证码。',
                            style: Theme.of(context).textTheme.titleSmall!,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 38, bottom: 15),
                            child: Stack(
                              children: [
                                TextFormField(
                                  controller:
                                      _loginPageCtr.msgCodeTextController,
                                  focusNode: _loginPageCtr.msgCodeTextFieldNode,
                                  maxLength: 6,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: '输入验证码',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                  ),
                                  // 校验用户名
                                  validator: (v) {
                                    return v!.trim().isNotEmpty
                                        ? null
                                        : "验证码不能为空";
                                  },
                                  onSaved: (val) {
                                    print(val);
                                  },
                                ),
                                Positioned(
                                  right: 8,
                                  top: 4,
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () =>
                                          _loginPageCtr.getMsgCode(),
                                      child: const Text('获取验证码'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _loginPageCtr.previousPage(),
                                child: const Text('上一步'),
                              ),
                              const SizedBox(width: 15),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onPrimary,
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primary, // 设置按钮背景色
                                ),
                                onPressed: () => _loginPageCtr.loginInByCode(),
                                child: const Text('确认登录'),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
