
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutterdriver/global.dart';
import 'package:flutterdriver/pages/splash_page.dart';
import 'package:flutterdriver/utils/shared_preferences.dart';
import 'package:fluwx/fluwx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Future<void> main() async {
  //炫彩边框效果
//  debugRepaintRainbowEnabled = true;
  //展示所有盒子范围
//  debugPaintSizeEnabled = true;
  //展示可点击区域范围
//  debugPaintPointersEnabled = true;
  //所有layer展示橙色边框
//  debugPaintLayerBordersEnabled = true;
  runApp(MyApp());
  DefaultSharedPreferences.getInstance();
  await enableFluttifyLog(false);
  await AmapService.instance.init(
    iosKey: '2ef1da24a539c6811f412bdf38d69b89',
    androidKey: '80bdc2b88702bb1ae4330bd31061c3af',
  );

  await registerWxApi(appId: "wx3f0a32fbe408864f",universalLink: "https://www.czdhy.com");


}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Global.navigatorKey,
      title: '车真多司机',
      localizationsDelegates: [
        // 这行是关键
        RefreshLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      locale: const Locale('zh'),
      supportedLocales: [
        const Locale('en'),
        const Locale('zh'),
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        //print("change language");
        return locale;
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
          primarySwatch: Colors.orange,
          textTheme:
          TextTheme(button: TextStyle(fontSize: 14, color: Colors.white))),
      home: SplashPage(),
    );
  }
}


