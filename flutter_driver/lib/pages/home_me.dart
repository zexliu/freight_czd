import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterdriver/event/events.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/me_statistical_entity.dart';
import 'package:flutterdriver/pages/authentication_page2.dart';
import 'package:flutterdriver/pages/setting_page.dart';
import 'package:flutterdriver/pages/transaction_page.dart';
import 'package:flutterdriver/utils/map_utils.dart';
import 'package:flutterdriver/utils/shared_preferences.dart';
import 'package:flutterdriver/widget/loading_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:mobpush_plugin/mobpush_plugin.dart';
import '../global.dart';
import 'announcement_page.dart';
import 'authentication_page.dart';
import 'evaluation_page.dart';
import 'feedback_page.dart';
import 'login.dart';
import 'me_cs.dart';
import 'nav_compute_page.dart';

class HomeMePage extends StatefulWidget {
  @override
  _HomeMePageState createState() => _HomeMePageState();
}

class _HomeMePageState extends State<HomeMePage> {
  StreamSubscription<AuthenticatedEvent> _listen;

  MeStatisticalEntity _meStatisticalEntity = MeStatisticalEntity();

  @override
  void initState() {
    super.initState();
    _listen = eventBus.on<AuthenticatedEvent>().listen((event) {
      _getStatistical();
    });

    _getStatistical();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 0,
            ),
            Text(
              "我的",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
           Positioned(
             right: 0,
             child: IconButton(
               icon: Icon(
                 Icons.settings,
                 color: Theme.of(context).primaryColor,
               ),
               onPressed: () => {
                 Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                   return SettingPage();
                 }))
               },
             ),
           )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: _buildContent(),
          ),
        ),
      ),
    );
  }

  _buildUnAuthentication() {
    return [
      Row(
        children: <Widget>[
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: Global.userEntity.avatar == null ? "":Global.userEntity.avatar ,
              placeholder: (context, url) => Image.asset(
                "images/default_avatar.png",
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
              fit: BoxFit.cover,
              width: 60,
              height: 60,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    Global.userEntity.mobile.replaceRange(5, 9, "****"),
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "未认证",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text("认证后享受更多服务",
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                  ))
            ],
          )
        ],
      ),
      SizedBox(
        height: 16,
      ),
      GestureDetector(
        onTap: () => {_onAuthenticationPressed()},
        child: Image.asset(
          "images/authentication.png",
          fit: BoxFit.fill,
        ),
      )
    ];
  }

  List<Widget> _buildAuthentication() {
    return [
      Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      // showCupertinoModalPopup(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return CupertinoActionSheet(
                      //         actions: <Widget>[
                      //           CupertinoActionSheetAction(
                      //             child: Text('拍摄'),
                      //             onPressed: () {
                      //               Navigator.of(context).pop();
                      //               getImage(ImageSource.camera);
                      //             },
                      //             isDefaultAction: true,
                      //           ),
                      //           CupertinoActionSheetAction(
                      //             child: Text('从手机相册选择'),
                      //             onPressed: () {
                      //               Navigator.of(context).pop();
                      //               getImage(ImageSource.gallery);
                      //             },
                      //             isDestructiveAction: true,
                      //           ),
                      //           CupertinoActionSheetAction(
                      //             child: Text(
                      //               '取消',
                      //               style: TextStyle(color: Colors.blue),
                      //             ),
                      //             onPressed: () {
                      //               Navigator.of(context).pop();
                      //             },
                      //           ),
                      //         ],
                      //       );
                      //     });
                    },
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: Global.userEntity.avatar,
                        placeholder: (context, url) => Image.asset(
                          "images/default_avatar.png",
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            Global.userEntity.realName,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4),
                          Text(
                            "已认证",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4),
//                          Text(
//                            "23123到期",
//                            style: TextStyle(color: Colors.grey, fontSize: 10),
//                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${_meStatisticalEntity.carLong}  |  ${_meStatisticalEntity.carModel}",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        height: 16,
                      ),
//                      Row(
//                        children: <Widget>[
//                          Text(
//                            "成长",
//                            style: TextStyle(fontSize: 12),
//                          ),
//                          SizedBox(
//                            width: 8,
//                          ),
//                          SizedBox(
//                            width: 120,
//                            height: 10,
//                            child: LinearProgressIndicator(
//                              backgroundColor: Colors.grey[200],
//                              valueColor: AlwaysStoppedAnimation(
//                                  Theme.of(context).primaryColor),
//                              value: .5,
//                            ),
//                          ),
//                          SizedBox(
//                            width: 8,
//                          ),
//                          Text(
//                            "1232/43221",
//                            style: TextStyle(fontSize: 12),
//                          ),
//                        ],
//                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () => {

                      Navigator.of(context).push(MaterialPageRoute(builder: (c){
                        return AuthenticationPage2();
                      }))
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          color: Colors.white),
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: Text(
                        "编辑资料",
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ))
            ],
          ),
          SizedBox(height: 8),
          Card(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                  return TransactionPage();
                }));
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              "钱包余额",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "0.00元",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          "进入钱包",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
//          Card(
//            child: Padding(
//              padding: EdgeInsets.all(16),
//              child: Column(
//                children: <Widget>[
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      Text(
//                        "我的钱包",
//                        style: TextStyle(
//                            color: Colors.black,
//                            fontSize: 14,
//                            fontWeight: FontWeight.bold),
//                      ),
//                      GestureDetector(
//                        onTap: () => {print("点击  进入钱包")},
//                        child: Text(
//                          "进入钱包",
//                          style: TextStyle(
//                            color: Colors.black,
//                            fontSize: 12,
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                  Padding(
//                    padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Column(
//                          children: <Widget>[
//                            Text(
//                              "0.00元",
//                              style: TextStyle(
//                                  color: Colors.black,
//                                  fontSize: 18,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            SizedBox(
//                              height: 8,
//                            ),
//                            Text(
//                              "余额",
//                              style: TextStyle(fontSize: 12),
//                            )
//                          ],
//                        ),
//                        Column(
//                          children: <Widget>[
//                            Text(
//                              "0",
//                              style: TextStyle(
//                                  color: Colors.black,
//                                  fontSize: 18,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            SizedBox(
//                              height: 8,
//                            ),
//                            Text(
//                              "我的券",
//                              style: TextStyle(fontSize: 12),
//                            )
//                          ],
//                        ),
//                        Column(
//                          children: <Widget>[
//                            Text(
//                              "0",
//                              style: TextStyle(
//                                  color: Colors.black,
//                                  fontSize: 18,
//                                  fontWeight: FontWeight.bold),
//                            ),
//                            SizedBox(
//                              height: 8,
//                            ),
//                            Text(
//                              "积分",
//                              style: TextStyle(fontSize: 12),
//                            )
//                          ],
//                        )
//                      ],
//                    ),
//                  )
//                ],
//              ),
//            ),
//          )
        ],
      )
    ];
  }

  _buildConsistent() {
    return [
      SizedBox(
        height: 8,
      ),
      Card(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "常用工具",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: double.infinity,
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
//                GestureDetector(
//                  onTap: () => {print("点击了 客户服务")},
//                  child: Column(
//                    children: <Widget>[
//                      Image.asset(
//                        "images/me_cs.png",
//                        width: 32,
//                        height: 32,
//                      ),
//                      SizedBox(height: 8),
//                      Text("客户服务")
//                    ],
//                  ),
//                ),
                GestureDetector(
                  onTap: () => {
                    Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                      return EvaluationPage();
                    }))
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "images/me_comment.png",
                        width: 32,
                        height: 32,
                      ),
                      SizedBox(height: 8),
                      Text("评价管理")
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                      return FeedbackPage();
                    }))
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "images/me_feedback.png",
                        width: 32,
                        height: 32,
                      ),
                      SizedBox(height: 8),
                      Text("意见反馈")
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new NavComputePage();
                    }))
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "images/me_ruler.png",
                        width: 32,
                        height: 32,
                      ),
                      SizedBox(height: 8),
                      Text("里程计算")
                    ],
                  ),
                ),
                // GestureDetector(
                //   onTap: () => {openMapsSheet(context)},
                //   child: Column(
                //     children: <Widget>[
                //       Image.asset(
                //         "images/me_navi.png",
                //         width: 32,
                //         height: 32,
                //       ),
                //       SizedBox(height: 8),
                //       Text("货车导航")
                //     ],
                //   ),
                // )
              ],
            )
          ],
        ),
      )),
      SizedBox(
        height: 8,
      ),
      Card(
          child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "我的服务",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: double.infinity,
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => {
                    Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                      return AnnouncementPage();
                    }))
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "images/me_notice.png",
                        width: 32,
                        height: 32,
                      ),
                      SizedBox(height: 8),
                      Text("法律公告")
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                      return MeServicePage();
                    }))
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "images/me_cs.png",
                        width: 32,
                        height: 32,
                      ),
                      SizedBox(height: 8),
                      Text("联系客服")
                    ],
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 0),
                  opacity: 0,
                  child: Column(
                    children: <Widget>[Text("意见反馈")],
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 0),
                  opacity: 0,
                  child: Column(
                    children: <Widget>[Text("意见反馈")],
                  ),
                ),
              ],
            )
          ],
        ),
      )),
      SizedBox(height: 32,),
    ];
  }

  _buildContent() {
    List<Widget> contentWidgets = [];
    if (Global.isAuthenticated()) {
      contentWidgets.addAll(_buildAuthentication());
//      contentWidgets.addAll(_buildUnAuthentication());
    } else {
      contentWidgets.addAll(_buildUnAuthentication());
    }
    contentWidgets.addAll(_buildConsistent());

    return contentWidgets;
  }

  _onAuthenticationPressed() async {
    await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      return AuthenticationPage2();
    }));
  }

  @override
  void dispose() {
    _listen.cancel();
    super.dispose();
  }

  openMapsSheet(context) async {
    try {
      final coords = Coords(39.90828781, 116.3973999);
      final title = "车真多";
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                        ),
                        title: Text(MapUtils.mapMap[map.mapName]),
                        leading: Image(
                          image: map.icon,
                          height: 40.0,
                          width: 40.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void _getStatistical() {
    HttpManager.getInstance().get("/api/v1/statistical/me").then((value) {
      setState(() {
        _meStatisticalEntity = MeStatisticalEntity().fromJson(value);
      });
    });
  }



  final picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(
        source: imageSource, maxHeight: 600, maxWidth: 600, imageQuality: 30);
    FormData formData = FormData.fromMap({
      "file":
      await MultipartFile.fromFile(pickedFile.path, filename: "upload.jpg")
    });
    showLoadingDialog();
    HttpManager.getInstance()
        .post("/api/v1/upload", data: formData)
        .then((value) {
      HttpManager.getInstance()
          .put("/api/v1/users/avatar", params: {"avatar": value}).then((v) {
        hideLoadingDialog();
        setState(() {
          Global.userEntity.avatar = value;
        });
      });
    }).catchError((e) {
      hideLoadingDialog();
    });
    // var response = await dio.post("/info", data: formData);
  }
}
