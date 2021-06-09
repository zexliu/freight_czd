import 'package:flutter/material.dart';
import 'package:flutterdriver/http/common.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/dict_entry_entity.dart';
import 'package:flutterdriver/utils/Toast.dart';
import 'package:flutterdriver/widget/loading_dialog.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class OrderCancelPage extends StatefulWidget {
  final String id;

  OrderCancelPage(this.id);

  @override
  _OrderCancelPageState createState() => _OrderCancelPageState();
}

class _OrderCancelPageState extends State<OrderCancelPage> {
  FocusNode _focusNode = FocusNode();
  TextEditingController _editingController = TextEditingController();

  Future<DictEntryEntity> _future;
  var checkedDescription = "";

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _focusNode),
    ], nextFocus: false);
  }

  @override
  void initState() {
    _future = fetchDict("driver_cancel_description");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("取消运单"),
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<DictEntryEntity>(
          future: _future,
          builder: (c, s) {
            if (s.connectionState == ConnectionState.done) {
              if (s.hasError) {
                return Text("服务错误 ${s.error}");
              } else {
                var records = [];
                records.addAll(s.data.records);
                final DictEntryRecord record = DictEntryRecord();
                record.dictEntryName = "其他";
                records.add(record);
                var tiles = ListTile.divideTiles(
                    context: c,
                    tiles: records.map((e) {
                      return RadioListTile(
                        title: Text(e.dictEntryName),
                        onChanged: (v) {
                          setState(() {
                            checkedDescription = e.dictEntryName;
                          });
                        },
                        groupValue: checkedDescription,
                        value: e.dictEntryName,
                      );
                    })).toList();
                return SafeArea(
                  child: KeyboardActions(
                    config: _buildConfig(context),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey.shade200,
                              child: Text("请选择取消运单原因"),
                            ),
                            ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: tiles,
                            ),
                            Visibility(
                              visible: checkedDescription == "其他",
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                                child: TextField(
                                  controller: _editingController,
                                  focusNode: _focusNode,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    hintText: "请填写具体取消原因",
                                    fillColor: Colors.grey.shade200,
                                    filled: true,
                                    isDense: true,
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(fontSize: 16),
                                  minLines: 3,
                                  maxLines: 3,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "*取消运单前请先和司机协商一致",
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 14),
                              ),
                            )
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: MaterialButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              if (checkedDescription == "") {
                                Toast.show("请选择取消原因");
                                return;
                              }
                              if (checkedDescription == "其他") {
                                if (_editingController.text.isEmpty) {
                                  Toast.show("请输入取消原因");
                                  return;
                                }
                              } else {
                              }

                              showLoadingDialog();
                              HttpManager.getInstance()
                                  .post("/api/v1/orders/${widget.id}/cancel")
                                  .then((value) => {
                                        hideLoadingDialog(),
                                        Navigator.of(context).pop("success")
                                      })
                                  .catchError((e) => {hideLoadingDialog()});
                            },
                            child: Text("提交"),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
