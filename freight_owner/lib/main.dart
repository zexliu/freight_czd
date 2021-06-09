import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluwx/fluwx.dart';
import 'package:freightowner/pages/splash_page.dart';
import 'package:freightowner/global.dart';
import 'package:freightowner/utils/shared_preferences.dart';
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
    iosKey: '7e4c0be3df98c55ba7ae2bc2714b7962',
    androidKey: '093a1459cd85c45825041982b72413bb',
  );
  await registerWxApi(appId: "wx56c14b5a20672152",universalLink: "https://www.czdhy.com");

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Global.navigatorKey,
      title: '车真多货主',
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
          primarySwatch: Colors.orange,
          textTheme:
              TextTheme(button: TextStyle(fontSize: 14, color: Colors.white))),
      home: SplashPage(),
    );
  }
}
