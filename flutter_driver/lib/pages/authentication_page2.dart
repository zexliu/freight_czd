import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterdriver/event/events.dart';
import 'package:flutterdriver/http/common.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/dict_entry_entity.dart';
import 'package:flutterdriver/model/driver_extension_entity.dart';
import 'package:flutterdriver/utils/Toast.dart';
import 'package:flutterdriver/widget/loading_dialog.dart';
import 'package:flutterdriver/widget/select_button.dart';
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

  final TextEditingController _carNoController = TextEditingController();
  FocusNode _carNoNode = FocusNode();
  List<DictEntryRecord> deliverNatures;
  List<DictEntryRecord> carModels;
  List<DictEntryRecord> carLongs;

  String selectedNature;
  String selectedCarLong;
  String selectedCarModel;
  StreamSubscription<AuthenticatedEvent> _listen;


  DriverExtensionEntity _extension;

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _realNameNode),
      KeyboardActionsItem(focusNode: _carNoNode),
    ]);
  }

  @override
  void initState() {
    var entry = fetchDict("driver_nature");
    entry.then((value) => this.deliverNatures = value.records);
    fetchDict("car_model").then((value) => this.carModels = value.records);
    fetchDict("car_long").then((value) => this.carLongs = value.records);
    _listen = eventBus.on<AuthenticatedEvent>().listen((event) {
      _fetch();
    });
    _fetch();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "司机认证",
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
          _extension.vehicleLicense = value;
          // _extension.businessLicense
        } else if (type == 6) {
          _extension.vehicleLicenseBackend = value;
        } else if (type == 7) {
          _extension.driverLicense = value;
          // _extension.businessLicense
        } else if (type == 8) {
          _extension.driverLicenseBackend = value;
        }else if(type == 9){
          _extension.carGroupPhoto = value;
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
        await HttpManager.getInstance().get("/api/v1/driver/extension/self");
    if (json == "") {
      _extension = DriverExtensionEntity();
    } else {
      _extension = DriverExtensionEntity().fromJson(json);

      _realNameController.text = _extension.realName;
      _carNoController.text = _extension.carNo;
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
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: [
              Text("车牌号"),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  enabled: _extension.auditStatus != "PENDING",
                  focusNode: _carNoNode,
                  controller: _carNoController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.transparent,
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle:
                      TextStyle(color: Colors.black54, fontSize: 14),
                      contentPadding: EdgeInsets.all(6.0),
                      hintText: "请输入车牌号"),
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
            this.selectedNature = _extension.carLong;
            FocusScope.of(context).requestFocus(FocusNode());
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (content1, state) {
                      return SafeArea(child: Container(
                          height: 160,
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
                                    "营运性质",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        if (selectedNature == null) {
                                          Toast.show("请选择营运性质");
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
                          )),);
                    },
                  );
                });
          },
          title: Text(
            "营运性质",
            style: TextStyle(fontSize: 14),
          ),
          trailing: Text(
              this._extension.nature == null
                  ? "请选择营运性质"
                  : this._extension.nature,
              style: TextStyle(color: Colors.grey)),
        ),
        Divider(
          height: 1,
        ),
        ListTile(
          onTap: _extension.auditStatus == "PENDING"
              ? null
              : () {
                  this.selectedCarModel = _extension.carModel;
                  FocusScope.of(context).requestFocus(FocusNode());
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (content1, state) {
                            return SafeArea(
                              child: Container(
                                  height: 260,
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
                                            "车型",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                if (selectedCarModel == null) {
                                                  Toast.show("请选择车型");
                                                  return;
                                                }
                                                this._extension.carModel =
                                                    selectedCarModel;
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
                                          itemCount: carModels == null
                                              ? 0
                                              : carModels.length,
                                          itemBuilder: (BuildContext context,
                                              int position) {
                                            return SelectButton(
                                              text: carModels[position]
                                                  .dictEntryName,
                                              isSelected: (this.selectedCarModel ==
                                                  carModels[position]
                                                      .dictEntryName),
                                              onTap: () {
                                                state(() {
                                                  this.selectedCarModel =
                                                      carModels[position]
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
            "车型",
            style: TextStyle(fontSize: 14),
          ),
          trailing: Text(
              this._extension.carModel == null
                  ? "请选择车型"
                  : this._extension.carModel,
              style: TextStyle(color: Colors.grey)),
        ),
        Divider(
          height: 1,
        ),
        ListTile(
          onTap: _extension.auditStatus == "PENDING"
              ? null
              : () {
            this.selectedCarLong = _extension.carLong;
            FocusScope.of(context).requestFocus(FocusNode());
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (content1, state) {
                      return SafeArea(child:
                      Container(
                          height: 360,
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
                                    "车长",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        if (selectedCarLong == null) {
                                          Toast.show("请选择车长");
                                          return;
                                        }
                                        this._extension.carLong =
                                            selectedCarLong;
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
                                  itemCount: carLongs == null
                                      ? 0
                                      : carLongs.length,
                                  itemBuilder: (BuildContext context,
                                      int position) {
                                    return SelectButton(
                                      text: carLongs[position]
                                          .dictEntryName,
                                      isSelected: (this.selectedCarLong ==
                                          carLongs[position]
                                              .dictEntryName),
                                      onTap: () {
                                        state(() {
                                          this.selectedCarLong =
                                              carLongs[position]
                                                  .dictEntryName;
                                        });
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
                          )),);
                    },
                  );
                });
          },
          title: Text(
            "车长",
            style: TextStyle(fontSize: 14),
          ),
          trailing: Text(
              this._extension.carLong == null
                  ? "请选择车长"
                  : this._extension.carLong,
              style: TextStyle(color: Colors.grey)),
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
        //
        //

        ListTile(
          title: Text(
            "行驶证 (必填)",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: InkWell(
            child: CachedNetworkImage(
              imageUrl: _extension.vehicleLicense == null
                  ? Global.defaultNoneString
                  : _extension.vehicleLicense,
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
          ),
        ),

        // Padding(
        //   padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        //   child: Row(
        //     children: [
        //       InkWell(
        //         child: CachedNetworkImage(
        //           imageUrl: _extension.vehicleLicense == null
        //               ? Global.defaultNoneString
        //               : _extension.vehicleLicense,
        //           placeholder: (context, url) => Image.asset(
        //             "images/default_avatar.png",
        //             width: (MediaQuery.of(context).size.width - 16 * 3) / 2,
        //             height:
        //             (MediaQuery.of(context).size.width - 16 * 3) / 2 / 1.58,
        //             fit: BoxFit.cover,
        //           ),
        //           fit: BoxFit.cover,
        //           width: (MediaQuery.of(context).size.width - 16 * 3) / 2,
        //           height:
        //           (MediaQuery.of(context).size.width - 16 * 3) / 2 / 1.58,
        //         ),
        //         onTap: _extension.auditStatus == "PENDING"
        //             ? null
        //             : () {
        //           _showImageDialog(5);
        //         },
        //       ),
        //       SizedBox(
        //         width: 16,
        //       ),
        //       InkWell(
        //         child: CachedNetworkImage(
        //           imageUrl: _extension.vehicleLicenseBackend == null
        //               ? Global.defaultNoneString
        //               : _extension.vehicleLicenseBackend,
        //           placeholder: (context, url) => Image.asset(
        //             "images/default_avatar.png",
        //             width: (MediaQuery.of(context).size.width - 16 * 3) / 2,
        //             height:
        //             (MediaQuery.of(context).size.width - 16 * 3) / 2 / 1.58,
        //             fit: BoxFit.cover,
        //           ),
        //           fit: BoxFit.cover,
        //           width: (MediaQuery.of(context).size.width - 16 * 3) / 2,
        //           height:
        //           (MediaQuery.of(context).size.width - 16 * 3) / 2 / 1.58,
        //         ),
        //         onTap: _extension.auditStatus == "PENDING"
        //             ? null
        //             : () {
        //           _showImageDialog(6);
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        //
        //

        ListTile(
          title: Text(
            "驾驶证",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: InkWell(
            child: CachedNetworkImage(
              imageUrl: _extension.driverLicense == null
                  ? Global.defaultNoneString
                  : _extension.driverLicense,
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
              _showImageDialog(7);
            },
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        //   child: Row(
        //     children: [
        //       InkWell(
        //         child: CachedNetworkImage(
        //           imageUrl: _extension.driverLicense == null
        //               ? Global.defaultNoneString
        //               : _extension.driverLicense,
        //           placeholder: (context, url) => Image.asset(
        //             "images/default_avatar.png",
        //             width: (MediaQuery.of(context).size.width - 16 * 3) / 2,
        //             height:
        //             (MediaQuery.of(context).size.width - 16 * 3) / 2 / 1.58,
        //             fit: BoxFit.cover,
        //           ),
        //           fit: BoxFit.cover,
        //           width: (MediaQuery.of(context).size.width - 16 * 3) / 2,
        //           height:
        //           (MediaQuery.of(context).size.width - 16 * 3) / 2 / 1.58,
        //         ),
        //         onTap: _extension.auditStatus == "PENDING"
        //             ? null
        //             : () {
        //           _showImageDialog(7);
        //         },
        //       ),
        //       SizedBox(
        //         width: 16,
        //       ),
        //       InkWell(
        //         child: CachedNetworkImage(
        //           imageUrl: _extension.driverLicenseBackend == null
        //               ? Global.defaultNoneString
        //               : _extension.driverLicenseBackend,
        //           placeholder: (context, url) => Image.asset(
        //             "images/default_avatar.png",
        //             width: (MediaQuery.of(context).size.width - 16 * 3) / 2,
        //             height:
        //             (MediaQuery.of(context).size.width - 16 * 3) / 2 / 1.58,
        //             fit: BoxFit.cover,
        //           ),
        //           fit: BoxFit.cover,
        //           width: (MediaQuery.of(context).size.width - 16 * 3) / 2,
        //           height:
        //           (MediaQuery.of(context).size.width - 16 * 3) / 2 / 1.58,
        //         ),
        //         onTap: _extension.auditStatus == "PENDING"
        //             ? null
        //             : () {
        //           _showImageDialog(8);
        //         },
        //       ),
        //     ],
        //   ),
        // ),


        // ListTile(
        //   title: Text(
        //     "上传人车合影 ",
        //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        //   ),
        // ),
        // Padding(
        //   padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        //   child: InkWell(
        //     child: CachedNetworkImage(
        //       imageUrl: _extension.carGroupPhoto == null
        //           ? Global.defaultNoneString
        //           : _extension.carGroupPhoto,
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
        //             _showImageDialog(9);
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
                    if (_carNoController.text == "") {
                      Toast.show("请输入车牌号");
                      return;
                    }
                    if (_extension.carModel == null) {
                      Toast.show("请选择车型");
                      return;
                    }
                    if (_extension.carLong == null) {
                      Toast.show("请选择车长");
                      return;
                    }
                    // if (_extension.nature == null) {
                    //   Toast.show("请选择营运性质");
                    //   return;
                    // }
                    // if (_extension.identityCard == null) {
                    //   Toast.show("请上传身份证正面");
                    //   return;
                    // }
                    if (_extension.identityCard == null) {
                      Toast.show("请上传身份证");
                      return;
                    }
                    // if (_extension.identityCardBackend == null) {
                    //   Toast.show("请上传身份证反面");
                    //   return;
                    // }
                    // if (_extension.identityCardTake == null) {
                    //   Toast.show("请上传手持身份证照片");
                    //   return;
                    // }
                    if (_extension.vehicleLicense == null) {
                      Toast.show("请上传行驶证");
                      return;
                    }
                    // if (_extension.vehicleLicense == null) {
                    //   Toast.show("请上传行驶证正面");
                    //   return;
                    // }
                    // if (_extension.vehicleLicenseBackend == null) {
                    //   Toast.show("请上传行驶证反面");
                    //   return;
                    // }
                    // if (_extension.driverLicense == null) {
                    //   Toast.show("请驾驶证正面");
                    //   return;
                    // }
                    // if (_extension.driverLicenseBackend == null) {
                    //   Toast.show("请上传驾驶证反面");
                    //   return;
                    // }
                    // if (_extension.carGroupPhoto == null) {
                    //   Toast.show("请上传人车合影");
                    //   return;
                    // }
                    _extension.realName = _realNameController.text;
                    _extension.carNo = _carNoController.text;
                    showLoadingDialog();
                    if(_extension.id == null){
                      HttpManager.getInstance()
                          .post("/api/v1/driver/extension", data: _extension)
                          .then((value) {
                        print("on ok");
                        hideLoadingDialog();
                        _extension = DriverExtensionEntity().fromJson(value);
                        setState(() {});
                      });
                    }else{
                      HttpManager.getInstance()
                          .put("/api/v1/driver/extension/${_extension.id}", data: _extension)
                          .then((value) {
                        print("on ok");
                        hideLoadingDialog();
                        _extension = DriverExtensionEntity().fromJson(value);
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
