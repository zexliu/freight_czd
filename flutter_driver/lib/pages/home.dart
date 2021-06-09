import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdriver/event/events.dart';
import 'package:flutterdriver/generated/json/base/json_convert_content.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/app_version_entity.dart';
import 'package:flutterdriver/model/delivery_details_entity.dart';
import 'package:flutterdriver/pages/home_hall.dart';
import 'package:flutterdriver/pages/home_order.dart';
import 'package:flutterdriver/pages/home_phone.dart';
import 'package:flutterdriver/pages/home_today.dart';
import 'package:flutterdriver/utils/Toast.dart';
import 'package:flutterdriver/utils/apk_download_dialog.dart';
import 'package:flutterdriver/utils/area_utils.dart';
import 'package:flutterdriver/utils/phone_utils.dart';
import 'package:fluwx/fluwx.dart';
import 'package:mobpush_plugin/mobpush_custom_message.dart';
import 'package:mobpush_plugin/mobpush_notify_message.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global.dart';
import 'PrePayPage.dart';
import 'home_me.dart';

class HomePage extends StatefulWidget {
  static String routeKey = "HomePage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;
  var pageList = [
    HomeHallPage(),
    HomeTodayPage(),
    HomeOrderPage(),
    HomePhonePage(),
    HomeMePage()
  ];

  @override
  void initState() {
    super.initState();
    MobpushPlugin.updatePrivacyPermissionStatus(true);
    if (Platform.isIOS) {
      MobpushPlugin.setCustomNotification();
      // 开发环境 false, 线上环境 true
      MobpushPlugin.setAPNsForProduction(true);
    }

    MobpushPlugin.addPushReceiver((event) {
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>>onEvent:' + event.toString());
      setState(() {
        Map<String, dynamic> eventMap = json.decode(event);
        Map<String, dynamic> result = eventMap['result'];
        int action = eventMap['action'];

        switch (action) {
          case 0:
            MobPushCustomMessage message =
                new MobPushCustomMessage.fromJson(result);
            showDialog(
                context: context,
                child: AlertDialog(
                  content: Text(message.content),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("确定"),
                    )
                  ],
                ));
            break;
          case 1:
            _buildNotification(result);
            break;
          case 2:
            _buildNotification(result);
            break;
        }
      });
    }, (error) {
      print("onError$error");
    });

    _fetchVersion();
    Timer(Duration(seconds: 1), () {
      //callback function
      _showShareDialog();
    });
    // shareToWechat(context);
  }

  void shareToWechat_(BuildContext context) {
    // SSDKMap params = SSDKMap()
    //   ..setGeneral(
    //     "下载车真多",
    //     "快速发货，操作简单，实名认证交易更简单",
    //     null,
    //     null,
    //     null,
    //     "https://www.czdhy.com/download",
    //     null,
    //     null,
    //     null,
    //     null,
    //     SSDKContentTypes.webpage,
    //   );
    //
    //
    // SharesdkPlugin.share(ShareSDKPlatforms.wechatSession, params,
    //     (SSDKResponseState state, Map userdata, Map contentEntity,
    //         SSDKError error) {
    //   Toast.show(state.toString());
    // });
  }

  Future<void> _buildNotification(result) async {
    MobPushNotifyMessage message = new MobPushNotifyMessage.fromJson(result);

    if (message.extrasMap["type"] == "1") {
      //指定发货订单
      _showDeliveryDialog(result["title"] as String,
          result["content"] as String, message.extrasMap);
    } else if (message.extrasMap["type"] == "5") {
      // 审核通过
      print("接收到审核推送");
      var userInfo = await HttpManager.getInstance().get("/api/v1/users/self");
      Global.userEntity = JsonConvert.fromJsonAsT(userInfo);
      eventBus.fire(AuthenticatedEvent());
    }
  }

  void _showDeliveryDialog(
      String title, String body, Map<String, Object> extras) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return new CupertinoAlertDialog(
            title: new Text(title),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${AreaUtils.findCity(extras["loadProvinceCode"], extras["loadCityCode"]).label}${AreaUtils.findDistrict(extras["loadProvinceCode"], extras["loadCityCode"], extras["loadDistrictCode"]).label} → ${AreaUtils.findCity(extras["unloadProvinceCode"], extras["unloadCityCode"]).label}${AreaUtils.findDistrict(extras["unloadProvinceCode"], extras["unloadCityCode"], extras["unloadDistrictCode"]).label}",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "${(extras["carLongs"] as String).replaceAll(",", "/")}米　${(extras["carModels"] as String).replaceAll(",", "/")}",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "应收运费",
                      style: TextStyle(color: Colors.black87, fontSize: 10),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "${extras["freightAmount"]}元",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "应付定金",
                      style: TextStyle(color: Colors.black87, fontSize: 10),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "${extras["amount"]}元",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "货主${extras["nickname"]}",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    PhoneUtils.call(context, extras["mobile"], extras["userId"],
                        extras["deliverId"]);
                  },
                  child: Row(
                    children: <Widget>[
                      Text(
                        "${extras["mobile"]}",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.phone_in_talk,
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    DeliveryDetailsEntity entity = DeliveryDetailsEntity();
                    entity.id = extras["orderId"];
                    entity.unloadProvinceCode = extras["unloadProvinceCode"];
                    entity.unloadCityCode = extras["unloadCityCode"];
                    entity.unloadDistrictCode = extras["unloadDistrictCode"];
                    entity.loadProvinceCode = extras["loadProvinceCode"];
                    entity.loadCityCode = extras["loadCityCode"];
                    entity.loadDistrictCode = extras["loadDistrictCode"];
                    entity.loadStartAt = int.parse(extras["loadStartAt"]);
                    entity.loadEndAt = int.parse(extras["loadEndAt"]);
                    return PrePayPage(
                        entity, extras["freightAmount"], extras["amount"], 1);
                  }));
                },
                child: new Text(
                  "支付定金",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("取消"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //在这边加上super.build(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        backgroundColor: Colors.black87,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) => {
          this.setState(() {
            this._currentIndex = index;
            eventBus.fire(HomePageChangedEvent(_currentIndex));
          })
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('images/hall.png'),
            activeIcon: Image.asset('images/hall_active.png'),
            title: Text("配货大厅"),
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/time.png'),
            activeIcon: Image.asset('images/time_active.png'),
            title: Text("当天货源"),
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/order.png'),
            activeIcon: Image.asset('images/order_active.png'),
            title: Text("订单"),
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/phone.png'),
            activeIcon: Image.asset('images/phone_active.png'),
            title: Text("通话记录"),
          ),
          BottomNavigationBarItem(
            icon: Image.asset('images/me.png'),
            activeIcon: Image.asset('images/me_active.png'),
            title: Text("我的"),
          )
        ],
      ),
    );
  }

  Future<void> _fetchVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    int versionCode = int.parse(packageInfo.buildNumber);
    int deviceType;
    if (Platform.isIOS) {
      deviceType = 1;
    } else {
      deviceType = 2;
    }
    HttpManager.getInstance().get("/api/v1/app/version", params: {
      "versionCode": versionCode,
      "type": 2,
      "deviceType": deviceType
    }).then((value) {
      AppVersionEntity appVersion = AppVersionEntity().fromJson(value);
      if (appVersion.versionCode > versionCode) {
        List<Widget> actions = [];
        actions.add(FlatButton(
          onPressed: () async {
            if (Platform.isIOS) {
              if (await canLaunch(appVersion.downloadUrl)) {
                await launch(appVersion.downloadUrl);
              } else {
                Toast.show("Could not launch ${appVersion.downloadUrl}");
              }
            } else {
              Navigator.pop(context);
              print("准备更新");
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: AppDownloadDialog(appVersion),
                    );
                  });
            }
          },
          child: new Text(
            "更新",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ));

        if (!appVersion.isForce) {
          actions.add(FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: new Text("取消"),
          ));
        }

        showCupertinoDialog(
            context: context,
            builder: (c) {
              return WillPopScope(
                onWillPop: () async => false,
                child: new CupertinoAlertDialog(
                  title: Text(
                    "版本更新",
                    style: TextStyle(fontSize: 14),
                  ),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Text("版本: ${appVersion.versionName}"),
                      SizedBox(
                        height: 8,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "${appVersion.content}",
                            style: TextStyle(color: Colors.black87)),
                      ),
                    ],
                  ),
                  actions: actions,
                ),
              );
            },
            barrierDismissible: false);
      }
    });
  }

  void _showShareDialog() {
    showCupertinoDialog(
        context: context,
        builder: (c) {
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 64),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage("images/share_bg.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("images/share_logo.png"),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Image.asset("images/share_1.png"),
                        SizedBox(
                          height: 2,
                        ),
                        Image.asset("images/share_2.png"),
                        SizedBox(
                          height: 16,
                        ),
                        Image.asset("images/share_3.png"),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "我 · 们 · 一 · 直 · 在 · 突 · 破",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    elevation: 0,
                    padding: EdgeInsets.fromLTRB(
                      16,
                      4,
                      16,
                      4,
                    ),
                    shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    color: Color.fromRGBO(245, 81, 56, 1),
                    onPressed: () {
                      shareToWeChat(WeChatShareWebPageModel(
                          "https://www.czdhy.com/download",
                          title: "车真多App",
                          description: "物流发货就用车真多，货主一键发货，司机秒接单",
                          scene: WeChatScene.SESSION));

                      Navigator.pop(context);
                    },
                    child: Text(
                      "立即分享",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        barrierDismissible: true);
  }
}
