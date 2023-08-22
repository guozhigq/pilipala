import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:hive/hive.dart';
import 'package:pilipala/common/widgets/custom_toast.dart';
import 'package:pilipala/http/init.dart';
import 'package:pilipala/models/common/color_type.dart';
import 'package:pilipala/models/common/theme_type.dart';
import 'package:pilipala/pages/search/index.dart';
import 'package:pilipala/pages/video/detail/index.dart';
import 'package:pilipala/router/app_pages.dart';
import 'package:pilipala/pages/main/view.dart';
import 'package:pilipala/utils/data.dart';
import 'package:pilipala/utils/storage.dart';
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) async {
    await GStrorage.init();
    runApp(const MyApp());
    await Request.setCookie();
    await Data.init();
    await GStrorage.lazyInit();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Box setting = GStrorage.setting;
    // 主题色
    Color defaultColor =
        colorThemeTypes[setting.get(SettingBoxKey.customColor, defaultValue: 0)]
            ['color'];
    Color brandColor = defaultColor;
    // 主题模式
    ThemeType currentThemeValue = ThemeType.values[setting
        .get(SettingBoxKey.themeMode, defaultValue: ThemeType.system.code)];
    // 是否动态取色
    bool isDynamicColor =
        setting.get(SettingBoxKey.dynamicColor, defaultValue: true);

    return DynamicColorBuilder(
      builder: ((ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme? lightColorScheme;
        ColorScheme? darkColorScheme;
        if (lightDynamic != null && darkDynamic != null && isDynamicColor) {
          // dynamic取色成功
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // dynamic取色失败，采用品牌色
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: brandColor,
            brightness: Brightness.light,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: brandColor,
            brightness: Brightness.dark,
          );
        }
        // 图片缓存
        // PaintingBinding.instance.imageCache.maximumSizeBytes = 1000 << 20;
        return GetMaterialApp(
          title: 'PiLiPaLa',
          theme: ThemeData(
            // fontFamily: 'HarmonyOS',
            colorScheme: currentThemeValue == ThemeType.dark
                ? darkColorScheme
                : lightColorScheme,
            useMaterial3: true,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: ZoomPageTransitionsBuilder(
                  allowEnterRouteSnapshotting: false,
                ),
              },
            ),
          ),
          darkTheme: ThemeData(
            // fontFamily: 'HarmonyOS',
            colorScheme: currentThemeValue == ThemeType.light
                ? lightColorScheme
                : darkColorScheme,
            useMaterial3: true,
          ),
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: const Locale("zh", "CN"),
          supportedLocales: const [Locale("zh", "CN"), Locale("en", "US")],
          fallbackLocale: const Locale("zh", "CN"),
          getPages: Routes.getPages,
          home: const MainApp(),
          builder: (BuildContext context, Widget? child) {
            return FlutterSmartDialog(
              toastBuilder: (String msg) => CustomToast(msg: msg),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              ),
            );
          },
          navigatorObservers: [
            VideoDetailPage.routeObserver,
            SearchPage.routeObserver,
          ],
        );
      }),
    );
  }
}
