import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/event/events.dart';
import 'package:freightowner/generated/json/base/json_convert_content.dart';
import 'package:freightowner/http/common.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/dict_entry_entity.dart';
import 'package:freightowner/plugin/baidu_face_plugin.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:freightowner/widget/select_button.dart';
import '../global.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  List<DictEntryRecord> deliverNatures;

  String avatar = Global.userEntity.authenticationAvatar != null ? Global.userEntity.authenticationAvatar: Global.defaultNoneString ;
  String identityCard =  Global.userEntity.identityCard != null ? Global.userEntity.identityCard: Global.defaultNoneString ;
  String currentNature;
  IdentityResult identity;
  DictEntryRecord selectedNature;



  @override
  void initState() {
    var entry = fetchDict("deliver_nature");
    entry.then((value) => this.deliverNatures = value.records);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "货主认证",
          style: TextStyle(color: Theme
              .of(context)
              .primaryColor),
        ),
        iconTheme: IconThemeData(color: Theme
            .of(context)
            .primaryColor),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Container(
          child: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Divider(
                    height: 16,
                  ),
                  Container(
                    color: Colors.white,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("点击下图上传本人头像"),
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () => {_liveness()},
                          child: CachedNetworkImage(
                            imageUrl: avatar,
                            placeholder: (context, url) =>
                                Image.asset(
                                  "images/default_avatar.png",
                                  width: 88,
                                  height: 88,
                                  fit: BoxFit.cover,
                                ),
                            fit: BoxFit.cover,
                            width: 88,
                            height: 88,
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 8,
                  ),
                  Container(
                    color: Colors.white,
                    height:
                    (MediaQuery
                        .of(context)
                        .size
                        .width - 128) / 1.6 + 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                          child: Text("上传本人身份证(必填)"),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(64, 0, 64, 0),
                          child: GestureDetector(
                            onTap: () => {_identityCard()},
                            child: CachedNetworkImage(
                              imageUrl: identityCard,
                              placeholder: (context, url) =>
                                  Image.asset(
                                    "images/default_avatar.png",
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width - 128,
                                    height:
                                    (MediaQuery
                                        .of(context)
                                        .size
                                        .width - 128) /
                                        1.6,
                                    fit: BoxFit.cover,
                                  ),
                              fit: BoxFit.cover,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 128,
                              height:
                              (MediaQuery
                                  .of(context)
                                  .size
                                  .width - 128) /
                                  1.6,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () =>
                    {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (content1, state) {
                                return Container(
                                    height: 200,
                                    padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            MaterialButton(
                                              onPressed: () =>
                                              {Navigator.pop(context)},
                                              child: Text("取消"),
                                              minWidth: 48,
                                            ),
                                            Text(
                                              "发货性质",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            MaterialButton(
                                              onPressed: () {
                                                setState(() {
                                                  this.selectedNature =
                                                      _getNature();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: Text(
                                                "确定",
                                                style: TextStyle(
                                                    color: Theme
                                                        .of(context)
                                                        .primaryColor),
                                              ),
                                              minWidth: 48,
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: GridView.builder(
                                            gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              childAspectRatio: 3,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10,
                                            ),
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            itemCount: deliverNatures == null
                                                ? 0
                                                : deliverNatures.length,
                                            itemBuilder: (BuildContext context,
                                                int position) {
                                              return SelectButton(
                                                text: deliverNatures[position]
                                                    .dictEntryName,
                                                isSelected: (this
                                                    .currentNature !=
                                                    null &&
                                                    this.currentNature ==
                                                        deliverNatures[position]
                                                            .dictEntryValue),
                                                onTap: () {
                                                  state(() {
                                                    this.currentNature =
                                                        deliverNatures[position]
                                                            .dictEntryValue;
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ));
                              },
                            );
                          })
                    },
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("发货性质"),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  this.selectedNature == null
                                      ? "请选择发货性质"
                                      : this.selectedNature.dictEntryName,
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                            Icon(Icons.keyboard_arrow_right)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: MaterialButton(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    minWidth: MediaQuery
                        .of(context)
                        .size
                        .width - 32,
                    onPressed: () => {_onSubmitPressed()},
                    child: Text(
                      "提交审核",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  _liveness() async {
    LivenessResult result = await new BaiduFacePlugin().liveness();
    //上传图片
    if (result.success == "true") {
      FormData formData = FormData.fromMap({
        "base64": "data:image/jpeg;base64," + result.image,
        "fileName": "temp.jpeg"
      });
      HttpManager.getInstance()
          .post("/api/v1/upload/base64", data: formData)
          .then((value) {
        setState(() {
          setState(() {
            this.avatar = value;
          });
        });
      });
    }
  }
  //
  // _detect() async {
  //   DetectResult result = await new BaiduFacePlugin().detect();
  //   //上传图片
  //   if (result.success == "true") {
  //     FormData formData = FormData.fromMap({
  //       "base64": "data:image/jpeg;base64," + result.image,
  //       "fileName": "temp.jpeg"
  //     });
  //     HttpManager.getInstance()
  //         .post("/api/v1/upload/base64", data: formData)
  //         .then((value) {
  //       setState(() {
  //         setState(() {
  //           this.avatar = value;
  //         });
  //       });
  //     });
  //   }
  // }

  _identityCard() async {
    IdentityResult result = await new BaiduFacePlugin().localIdentity();
    //上传图片
    if (result.success == "true") {
      if (result.identityCardNo.length == 18) {
        Toast.show(result.toString());
        identity = result;
        FormData formData = FormData.fromMap({
          "base64": "data:image/jpeg;base64," + result.image,
          "fileName": "temp.jpeg"
        });
        HttpManager.getInstance()
            .post("/api/v1/upload/base64", data: formData)
            .then((value) {
          setState(() {
            setState(() {
              this.identityCard = value;
            });
          });
        });
      } else {
        Toast.show("身份证识别失败,请重新识别");
      }
    }
  }

  DictEntryRecord _getNature() {
    if (this.currentNature == null) {
      return null;
    }
    for (var value in this.deliverNatures) {
      if (value.dictEntryValue == this.currentNature) {
        return value;
      }
    }
    return null;
  }

  _onSubmitPressed() {
    if (this.avatar == Global.defaultNoneString) {
      Toast.show("请上传本人头像");
      return;
    } else if (this.identityCard == Global.defaultNoneString) {
      Toast.show("请上传本人身份证");
      return;
    } else if (this.selectedNature == null) {
      Toast.show("请选择发货性质");
      return;
    }

    String birthdayStr;
    int gender ;
    if(identity != null){
      if (identity.gender == "男") {
        gender = 1;
      } else if (identity.gender == "女") {
        gender = 2;
      }

      if (identity.birthDay.length == 8) {
        birthdayStr = identity.birthDay.substring(0,4) + "-"
            +identity.birthDay.substring(4,6) + "-"
            + identity.birthDay.substring(6);
      }
    }

    HttpManager.getInstance().post("/api/v1/authenticate/shipper", data: {
      "authenticationAvatar": avatar,
      "national": identity == null ? null :identity.national,
      "identityCardNo":identity == null ? null : identity.identityCardNo,
      "identityCard": identityCard,
      "birthDay": birthdayStr,
      "genderType": gender,
      "address": identity == null ? null : identity.address,
      "realName": identity == null ? null : identity.name,
      "nature": selectedNature.dictEntryValue,
    }).then((value) {
      HttpManager.getInstance().get("/api/v1/users/self").then((value) {
        Global.userEntity = JsonConvert.fromJsonAsT(value);
        eventBus.fire(AuthenticatedEvent());
        Navigator.pop(context);
      });
    });
  }
}
