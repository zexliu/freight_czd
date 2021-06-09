import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterdriver/http/common.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/dict_entry_entity.dart';
import 'package:flutterdriver/utils/Toast.dart';
import 'package:flutterdriver/widget/loading_dialog.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  List<DictEntryRecord> types = [];
  DictEntryRecord selectedType;
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();

  List<Asset> images = [];

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _focusNode),
    ], nextFocus: false);
  }

  @override
  void initState() {
    super.initState();
    fetchDict("feedback_type").then((value) {
      setState(() {
        types = value.records;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("意见反馈"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          child: KeyboardActions(
        config: _buildConfig(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      "反馈类型",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: selectedType == null
                          ? Text("请选择反馈类型")
                          : Text(selectedType.dictEntryName,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (c) {
                    return StatefulBuilder(builder: (c, state) {
                      return SafeArea(
                        child: ListView.builder(
                          itemBuilder: (c, i) {
                            var item = types[i];
                            return CheckboxListTile(
                              title: Text(item.dictEntryName),
                              onChanged: (v) {
                                setState(() {
                                  selectedType = item;
                                  Navigator.of(context).pop();
                                });
                              },
                              value: selectedType == null
                                  ? false
                                  : item.dictEntryValue ==
                                      selectedType.dictEntryValue,
                            );
                          },
                          itemCount: types.length,
                          shrinkWrap: true,
                        ),
                      );
                    });
                  },
                );
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: TextField(
                controller: _editingController,
                focusNode: _focusNode,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    hintText: "请输入反馈意见",
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    isDense: true,
                    border: InputBorder.none,
                    counterText: ""),
                style: TextStyle(fontSize: 14),
                minLines: 5,
                maxLines: 5,
                maxLength: 200,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child:Row(
                children: [
                  Text(
                    "上传照片",
                    textAlign: TextAlign.start,
                    style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " (3张)",
                    textAlign: TextAlign.start,
                    style:
                    TextStyle(color: Colors.grey, ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (item, position) {
                    if (position == images.length) {
                      return OutlineButton(
                        highlightedBorderColor: Colors.grey.shade300,
                        child: Center(
                          child: Icon(
                            Icons.add_photo_alternate,
                            color: Colors.grey,
                            size: 50,
                          ),
                        ),
                        onPressed: loadAssets,
                      );
                    } else {
                      Asset asset = images[position];
                      return InkWell(
                          onTap: loadAssets,
                          child: AssetThumb(
                            asset: asset,
                            height: MediaQuery.of(context).size.width.toInt(),
                            width: MediaQuery.of(context).size.width.toInt(),
                          ));
                    }
                  },
                  itemCount: images.length >= 3 ? 3 : images.length + 1,
                  shrinkWrap: true,
                )),

            Padding(
              padding: EdgeInsets.all(16),
              child: MaterialButton(
                minWidth: double.infinity,
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  if(selectedType == null){
                    Toast.show("请选择反馈类型");
                    return;
                  }
                  if(_editingController.text.isEmpty){
                    Toast.show("请输入反馈意见");
                    return;
                  }
                  showLoadingDialog();
                  String urls;
                  if(images.isNotEmpty){
                    //上传图片
//                    FormData formData = FormData.fromMap({
//                      "file":images.map((e) async {
//                        ByteData byteData = await e.getByteData();
//                        return  MultipartFile.fromBytes(byteData.buffer.asUint8List(),filename: "test.jpg");
//                      })
//                    });


                    List<MapEntry<String,MultipartFile>> mapEntries = [];
                  for (int i = 0; i< images.length ; i++){
                    var image = images[i];
                    ByteData byteData = await image.getByteData(quality: 30);
                    var multipartFile = MultipartFile.fromBytes(byteData.buffer.asUint8List(),filename: "${image.identifier}.jpg");
                    MapEntry<String,MultipartFile> entry = MapEntry("files", multipartFile);
                    mapEntries.add(entry);
                  }

                    var formData = FormData();
                    formData.files.addAll(mapEntries);
                    var result  = await  HttpManager.getInstance()
                        .post("/api/v1/upload/multi", data: formData);
                    urls = result.join(",");
                  }
                  print("post feedback");
                  HttpManager.getInstance().post("/api/v1/feedbacks",data: {"content":_editingController.text,"images":urls,"type":selectedType.dictEntryValue}).then((value) => {
                    hideLoadingDialog(),
                    Toast.show("提交成功"),
                    Navigator.of(context).pop()
                  });


                },
                child: Text("提交"),
                textColor: Colors.white,
              ),
            )
          ],
        ),
      )),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList;
    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: 3, selectedAssets: images, enableCamera: true);
    } on Exception catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (resultList == null) {
        images = [];
      } else {
        images = resultList;
      }
    });
  }
}
