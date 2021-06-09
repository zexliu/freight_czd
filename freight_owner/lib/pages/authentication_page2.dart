import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/event/events.dart';
import 'package:freightowner/http/common.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/delivery_extension_entity.dart';
import 'package:freightowner/model/dict_entry_entity.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:freightowner/widget/loading_dialog.dart';
import 'package:freightowner/widget/select_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import '../global.dart';

class AuthenticationPage2 extends StatefulWidget {
  @override
  _AuthenticationPage2State createState() => _AuthenticationPage2State();
}

class _AuthenticationPage2State extends State<AuthenticationPage2> {
  final TextEditingController _realNameController = TextEditingController();
  FocusNode _realNameNode = FocusNode();


  final TextEditingController _companyNameController = TextEditingController();
  FocusNode _companyNameNode = FocusNode();

  List<DictEntryRecord> deliverNatures;

  String selectedNature;

  DeliveryExtensionEntity _extension;
  StreamSubscription<AuthenticatedEvent> _listen;


  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _realNameNode),
      KeyboardActionsItem(focusNode: _companyNameNode),
    ]);
  }

  @override
  void initState() {
    var entry = fetchDict("deliver_nature");
    entry.then((value) => this.deliverNatures = value.records);
    _fetch();
    _listen = eventBus.on<AuthenticatedEvent>().listen((event) {
      _fetch();
    });
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
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
          child: KeyboardActions(
        config: _buildConfig(context),
        autoScroll: true,
        child: _buildContent(context),
      )),
    );
  }

  final picker = ImagePicker();

  Future _getImage(ImageSource imageSource, int type) async {
    final pickedFile = await picker.getImage(
        source: imageSource, maxHeight: 1024, maxWidth: 1024, imageQuality: 30);
    FormData formData = FormData.fromMap({
      "file":
          await MultipartFile.fromFile(pickedFile.path, filename: "upload.jpg")
    });
    showLoadingDialog();
    HttpManager.getInstance()
        .post("/api/v1/upload", data: formData)
        .then((value) {
      hideLoadingDialog();
      setState(() {
        if (type == 1) {
          _extension.avatar = value;
        } else if (type == 2) {
          _extension.identityCard = value;
        } else if (type == 3) {
          _extension.identityCardBackend = value;
        } else if (type == 4) {
          _extension.identityCardTake = value;
        } else if (type == 5) {
          _extension.businessLicense = value;
          // _extension.businessLicense
        } else if (type == 6) {
          _extension.shopGroupPhoto = value;
        }
      });
    }).catchError((e) {
      hideLoadingDialog();
      print(e);
    });
    // var response = await dio.post("/info", data: formData);
    setState(() {});
  }

  _fetch() async {
    var json =
        await HttpManager.getInstance().get("/api/v1/delivery/extension/self");
    if (json == "") {
      _extension = DeliveryExtensionEntity();
    } else {
      _extension = DeliveryExtensionEntity().fromJson(json);

      _realNameController.text = _extension.realName;
      _companyNameController.text = _extension.companyName;
    }
    setState(() {});
  }

  void _showImageDialog(int type) {
    FocusScope.of(context).requestFocus(FocusNode());
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('拍摄'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.camera, type);
                },
                isDefaultAction: true,
              ),
              CupertinoActionSheetAction(
                child: Text('从手机相册选择'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.gallery, type);
                },
                isDestructiveAction: true,
              ),
              CupertinoActionSheetAction(
                child: Text(
                  '取消',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _buildContent(BuildContext context) {
    if (_extension == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      List<Widget> widgets = [
        ListTile(
          title: Text(
            "基本信息 (必填)",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          onTap: _extension.auditStatus == "PENDING"
              ? null
              : () {
                  _showImageDialog(1);
                },
          title: Text(
            "个人头像",
            style: TextStyle(fontSize: 14),
          ),
          trailing: CachedNetworkImage(
            imageUrl: _extension.avatar == null
                ? Global.defaultNoneString
                : _extension.avatar,
            placeholder: (context, url) => Image.asset(
              "images/default_avatar.png",
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
            fit: BoxFit.cover,
            width: 48,
            height: 48,
          ),
        ),
        Divider(
          height: 1,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: [
              Text("真实姓名"),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  enabled: _extension.auditStatus != "PENDING",
                  focusNode: _realNameNode,
                  controller: _realNameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.transparent,
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle:
                          TextStyle(color: Colors.black54, fontSize: 14),
                      contentPadding: EdgeInsets.all(6.0),
                      hintText: "请输入真实姓名"),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
        ),
        ListTile(
          onTap: _extension.auditStatus == "PENDING"
              ? null
              : () {
                  this.selectedNature = _extension.nature;
                  FocusScope.of(context).requestFocus(FocusNode());
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (content1, state) {
                            return SafeArea(
                              child:  Container(
                                  height: 200,
                                  padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                                if (selectedNature == null) {
                                                  Toast.show("请选择发货性质");
                                                  return;
                                                }
                                                this._extension.nature =
                                                    selectedNature;
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text(
                                              "确定",
                                              style: TextStyle(
                                                  color: Theme.of(context)
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
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: deliverNatures == null
                                              ? 0
                                              : deliverNatures.length,
                                          itemBuilder: (BuildContext context,
                                              int position) {
                                            return SelectButton(
                                              text: deliverNatures[position]
                                                  .dictEntryName,
                                              isSelected: (this.selectedNature ==
                                                  deliverNatures[position]
                                                      .dictEntryName),
                                              onTap: () {
                                                state(() {
                                                  this.selectedNature =
                                                      deliverNatures[position]
                                                          .dictEntryName;
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  )),
                            );
                          },
                        );
                      });
                },
          title: Text(
            "发货性质",
            style: TextStyle(fontSize: 14),
          ),
          trailing: Text(
              this._extension.nature == null
                  ? "请选择发货性质"
                  : this._extension.nature,
              style: TextStyle(color: Colors.grey)),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: [
              Text("公司名称"),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  enabled: _extension.auditStatus != "PENDING",
                  focusNode: _companyNameNode,
                  controller: _companyNameController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.transparent,
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle:
                      TextStyle(color: Colors.black54, fontSize: 14),
                      contentPadding: EdgeInsets.all(6.0),
                      hintText: "请输入公司名称"),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
        ),
        Divider(
          height: 1,
        ),
        ListTile(
          title: Text(
            "上传身份证 (必填)",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: InkWell(
            child: CachedNetworkImage(
              imageUrl: _extension.identityCard == null
                  ? Global.defaultNoneString
                  : _extension.identityCard,
              placeholder: (context, url) => Image.asset(
                "images/default_avatar.png",
                width: (MediaQuery.of(context).size.width - 16 * 2),
                height: (MediaQuery.of(context).size.width - 16 * 2) / 1.58,
                fit: BoxFit.cover,
              ),
              fit: BoxFit.cover,
              width: (MediaQuery.of(context).size.width - 16 * 2),
              height: (MediaQuery.of(context).size.width - 16 * 2) / 1.58,
            ),
            onTap: _extension.auditStatus == "PENDING"
                ? null
                : () {
              _showImageDialog(2);
            },
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        //   child: Row(
        //     children: [
        //       InkWell(
        //         child: CachedNetworkImage(
        //           imageUrl: _extension.identityCard == null
        //               ? Global.defaultNoneString
        //               : _extension.identityCard,
        //           placeholder: (context, url) => Image.asset(
        //             "images/default_avatar.png",
        //             width: (MediaQuery.of(context).size.width - 16 * 3) / 2,
        //             height:
        //                 (MediaQuery.of(context).size.width - 16 * 3) / 2 / 1.58,
        //             fit: BoxFit.cover,
        //           ),
        //           fit: BoxFit.cover,
        //           width: (MediaQuery.of(context).size.width - 16 * 3) / 2,
        //           height:
        //               (MediaQuery.of(context).size.width - 16 * 3) / 2 / 1.58,
        //         ),
        //         onTap: _extension.auditStatus == "PENDING"
        //             ? null
        //             : () {
        //                 _showImageDialog(2);
        //               },
        //       ),
        //       SizedBox(
        //         width: 16,
        //       ),
        //       InkWell(
        //         child: CachedNetworkImage(
        //           imageUrl: _extension.identityCardBackend == null
        //               ? Global.defaultNoneString
        //               : _extension.identityCardBackend,
        //           placeholder: (context, url) => Image.asset(
        //             "images/default_avatar.png",
        //             width: (MediaQuery.of(context).size.width - 16 * 3) / 2,
        //             height:
        //                 (MediaQuery.of(context).size.width - 16 * 3) / 2 / 1.58,
        //             fit: BoxFit.cover,
        //           ),
        //           fit: BoxFit.cover,
        //           width: (MediaQuery.of(context).size.width - 16 * 3) / 2,
        //           height:
        //               (MediaQuery.of(context).size.width - 16 * 3) / 2 / 1.58,
        //         ),
        //         onTap: _extension.auditStatus == "PENDING"
        //             ? null
        //             : () {
        //                 _showImageDialog(3);
        //               },
        //       ),
        //     ],
        //   ),
        // ),
        // ListTile(
        //   title: Text(
        //     "手持身份证照片 ",
        //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //   ),
        // ),
        // Padding(
        //   padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        //   child: InkWell(
        //     child: CachedNetworkImage(
        //       imageUrl: _extension.identityCardTake == null
        //           ? Global.defaultNoneString
        //           : _extension.identityCardTake,
        //       placeholder: (context, url) => Image.asset(
        //         "images/default_avatar.png",
        //         width: (MediaQuery.of(context).size.width - 16 * 2),
        //         height: (MediaQuery.of(context).size.width - 16 * 2) / 1.58,
        //         fit: BoxFit.cover,
        //       ),
        //       fit: BoxFit.cover,
        //       width: (MediaQuery.of(context).size.width - 16 * 2),
        //       height: (MediaQuery.of(context).size.width - 16 * 2) / 1.58,
        //     ),
        //     onTap: _extension.auditStatus == "PENDING"
        //         ? null
        //         : () {
        //             _showImageDialog(4);
        //           },
        //   ),
        // ),
        ListTile(
          title: Text(
            "上传营业执照 ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: InkWell(
              child: CachedNetworkImage(
                imageUrl: _extension.businessLicense == null
                    ? Global.defaultNoneString
                    : _extension.businessLicense,
                placeholder: (context, url) => Image.asset(
                  "images/default_avatar.png",
                  width: (MediaQuery.of(context).size.width - 16 * 2),
                  height: (MediaQuery.of(context).size.width - 16 * 2) / 1.58,
                  fit: BoxFit.cover,
                ),
                fit: BoxFit.cover,
                width: (MediaQuery.of(context).size.width - 16 * 2),
                height: (MediaQuery.of(context).size.width - 16 * 2) / 1.58,
              ),
              onTap: _extension.auditStatus == "PENDING"
                  ? null
                  : () {
                      _showImageDialog(5);
                    },
            )),
        // ListTile(
        //   title: Text(
        //     "上传门店和人合影",
        //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //   ),
        // ),
        // Padding(
        //   padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        //   child: InkWell(
        //     child: CachedNetworkImage(
        //       imageUrl: _extension.shopGroupPhoto == null
        //           ? Global.defaultNoneString
        //           : _extension.shopGroupPhoto,
        //       placeholder: (context, url) => Image.asset(
        //         "images/default_avatar.png",
        //         width: (MediaQuery.of(context).size.width - 16 * 2),
        //         height: (MediaQuery.of(context).size.width - 16 * 2) / 1.58,
        //         fit: BoxFit.cover,
        //       ),
        //       fit: BoxFit.cover,
        //       width: (MediaQuery.of(context).size.width - 16 * 2),
        //       height: (MediaQuery.of(context).size.width - 16 * 2) / 1.58,
        //     ),
        //     onTap: _extension.auditStatus == "PENDING"
        //         ? null
        //         : () {
        //             _showImageDialog(6);
        //           },
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
          child: MaterialButton(
            child: Text(
                _extension.auditStatus == "PENDING" ? "审核中,请耐心等待审核结果" : "提交审核"),
            minWidth: double.infinity,
            onPressed: _extension.auditStatus == "PENDING"
                ? null
                : () {
                    if (_extension.avatar == null) {
                      Toast.show("请上传个人头像");
                      return;
                    }
                    if (_realNameController.text == "") {
                      Toast.show("请输入真实姓名");
                      return;
                    }
                    // if (_companyNameController.text == "") {
                    //   Toast.show("请输入公司名称");
                    //   return;
                    // }
                    // if (_extension.nature == null) {
                    //   Toast.show("请选择发货性质");
                    //   return;
                    // }
                    if (_extension.identityCard == null) {
                      Toast.show("请上传身份证");
                      return;
                    }
                    // if (_extension.identityCard == null) {
                    //   Toast.show("请上传身份证正面");
                    //   return;
                    // }
                    // if (_extension.identityCardBackend == null) {
                    //   Toast.show("请上传身份证反面");
                    //   return;
                    // }
                    // if (_extension.identityCardTake == null) {
                    //   Toast.show("请上传手持身份证照片");
                    //   return;
                    // }
                    // if (_extension.businessLicense == null) {
                    //   Toast.show("请上传营业执照");
                    //   return;
                    // }
                    // if (_extension.shopGroupPhoto == null) {
                    //   Toast.show("请上传门店和人合影");
                    //   return;
                    // }
                    _extension.realName = _realNameController.text;
                    _extension.companyName = _companyNameController.text;
                    showLoadingDialog();
                    if(_extension.id == null){
                      HttpManager.getInstance()
                          .post("/api/v1/delivery/extension", data: _extension)
                          .then((value) {
                        print("on ok");
                        hideLoadingDialog();
                        _extension = DeliveryExtensionEntity().fromJson(value);
                        setState(() {});
                      });
                    }else{
                      HttpManager.getInstance()
                          .put("/api/v1/delivery/extension/${_extension.id}", data: _extension)
                          .then((value) {
                        print("on ok");
                        hideLoadingDialog();
                        _extension = DeliveryExtensionEntity().fromJson(value);
                        setState(() {});
                      });
                    }

                  },
            height: 44,
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            disabledTextColor: Colors.white,
            disabledColor: Colors.blueGrey,
          ),
        )
      ];
      if (_extension.auditStatus == 'REJECTED') {
        widgets.insert(
            0,
            ListTile(
              leading: Icon(Icons.warning,color: Colors.redAccent,),
              title: Text("审核被拒绝",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
              subtitle: Text(_extension.histories[0].message ?? "",style: TextStyle(color: Theme.of(context).primaryColor),),
            ));
        widgets.insert(1, Divider(height: 1,));
      }else if(_extension.auditStatus == 'PASSED'){
        widgets.insert(
            0,
            ListTile(
              leading: Icon(Icons.assignment_turned_in,color: Colors.greenAccent,),
              title: Text("审核成功",style: TextStyle(color: Colors.greenAccent,fontWeight: FontWeight.bold),),
            ));
        widgets.insert(1, Divider(height: 1,));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _listen.cancel();
  }
}
