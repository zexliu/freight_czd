import 'dart:async';
import 'package:flutterdriver/generated/json/base/json_convert_content.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/utils/json.dart';
import 'package:flutterdriver/utils/shared_preferences.dart';
import '../global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'home.dart';
import 'login.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer _timer;

  @override
  void initState() {
    rootBundle.loadString('json/area.json').then((response) {
      Global.areas = JsonUtils.convertList(response);
      return Global.areas;
    });
    int _count = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _count++;
      if (_count == 2) {
        String accessToken =
            DefaultSharedPreferences.getInstance().get("ACCESS_TOKEN");
        if (accessToken == null) {
          _toLogin(context);
        } else {
          HttpManager.getInstance().get("/api/v1/users/self").then((value) {
            Global.userEntity = JsonConvert.fromJsonAsT(value);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) {
                      return HomePage();
                    },
                    settings: RouteSettings(name: HomePage.routeKey)),((route)=>false));
            _timer.cancel();
          }).catchError((){
            _toLogin(context);
          });
        }
      }

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    color: Colors.white,
    child: Image.asset("images/splash.jpg",fit: BoxFit.fill,),
    );
  }

  void _toLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return LoginPage();
    }),((route) => false));
  }
}
