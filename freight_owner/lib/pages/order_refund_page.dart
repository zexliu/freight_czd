import 'package:flutter/material.dart';
import 'package:freightowner/http/common.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/dict_entry_entity.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:freightowner/widget/loading_dialog.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class OrderRefundPage extends StatefulWidget {
  final String id;
  final double amount;

  OrderRefundPage(this.id,this.amount);

  @override
  _OrderRefundPageState createState() => _OrderRefundPageState();
}

class _OrderRefundPageState extends State<OrderRefundPage> {
  FocusNode focusNode = FocusNode();
  TextEditingController editingController = TextEditingController();

  Future<DictEntryEntity> _future;
  var checkedDescription = "";

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: focusNode),
    ], nextFocus: false);
  }

  @override
  void initState() {
    _future = fetchDict("user_refund_description");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("退还订金"),
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
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("退还订金"),
                                  Text("${widget.amount}元"),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey.shade200,
                              child: Text("请选择退还订金原因"),
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
                                  controller: editingController,
                                  focusNode: focusNode,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    hintText: "请填写具体退款原因",
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
                                Toast.show("请选择退款原因");
                                return;
                              }
                              if (checkedDescription == "其他") {
                                if (editingController.text.isEmpty) {
                                  Toast.show("请输入退款原因");
                                  return;
                                }
                              } else {
                              }

                              showLoadingDialog();
                              HttpManager.getInstance()
                                  .post("/api/v1/orders/${widget.id}/refund")
                                  .then((value) => {
                                        hideLoadingDialog(),
                                        Navigator.of(context).pop("success")
                                      })
                                  .catchError((e) => {hideLoadingDialog()});
                            },
                            child: Text("确认退还"),
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
