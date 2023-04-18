import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:pilipala/router/app_pages.dart';
import 'package:pilipala/pages/main/view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: ((lightDynamic, darkDynamic) {
        return GetMaterialApp(
          title: 'PiLiPaLa',
          theme: ThemeData(
              colorScheme: lightDynamic ??
                  ColorScheme.fromSeed(
                      seedColor: Colors.green, brightness: Brightness.light),
              useMaterial3: true),
          darkTheme: ThemeData(colorScheme: darkDynamic, useMaterial3: true),
          getPages: Routes.getPages,
          home: const MainApp(),
          // home: const Scaffold(),
        );
      }),
    );
  }
}
