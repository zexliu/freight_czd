import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freightowner/event/events.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/deliver_goods_entity.dart';
import 'package:freightowner/pages/deliver_remark.dart';
import 'package:freightowner/utils/text_input_formatter.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:freightowner/widget/select_button.dart';
import 'package:freightowner/widget/time_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'assign_driver.dart';
import 'home.dart';

class ConfirmDeliverPage extends StatefulWidget {
  final Map<String, dynamic> formData;
  final DeliverGoodsRecord record;
  final bool isEdit;

  ConfirmDeliverPage({@required this.formData,this.record,this.isEdit});

  @override
  _ConfirmDeliverPageState createState() => _ConfirmDeliverPageState();
}

class _ConfirmDeliverPageState extends State<ConfirmDeliverPage> {
  CustomDate _dayTime;
  CustomDate _rangTime;
  CustomDate _itemTime;
  var _dateFormat = DateFormat('yyyy-MM-dd');
  var _dateFormatAll = DateFormat('yyyy-MM-dd HH:mm:ss');

  List<String> _requireList = [];
  String _remark = "";
  FocusNode _moneyNode = FocusNode();

  TextEditingController _textController;

  List<String> _unitList = ["趟", "吨", "方", "件"];

  String _selectedUnit;

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _moneyNode),
    ], nextFocus: false);
  }

  @override
  void initState() {
    _textController = TextEditingController();
    if(widget.record != null){
      if(widget.record.remark != null){
        _remark   = widget.record.remark;
      }
      if(widget.record.requireList != null){
        _requireList = widget.record.requireList.split(",");
      }
      if(widget.record.expectUnit != null){
        _selectedUnit = widget.record.expectUnit;
      }
      if(widget.record.expectMoney != null){
        _textController.text = widget.record.expectMoney.toString();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String datetimeMsg = "";
    String remarkMsg = "";

    if (_dayTime != null && _rangTime != null && _itemTime != null) {
      datetimeMsg =
          "${_dayTime.title} ${_rangTime.title} ${_itemTime.startAt}-${_itemTime.endAt}";
    }

    if (_requireList.isNotEmpty) {
      remarkMsg = _requireList.join(",");
    }
    if (_remark.isNotEmpty) {
      if (remarkMsg.isNotEmpty) {
        remarkMsg += ",";
      }
      remarkMsg += _remark;
    }

    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text("确认运单"),
        ),
        body: SafeArea(
            child: KeyboardActions(
          config: _buildConfig(context),
          autoScroll: false,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Card(
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Text("装货时间"),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return SafeArea(
                                            child: Container(
                                              height: 240,
                                              child: TimePicker(
                                                dayTime: _dayTime,
                                                rangTime: _rangTime,
                                                itemTime: _itemTime,
                                                onChanged: (dayTime, rangTime,
                                                    itemTime) {
                                                  setState(() {
                                                    this._dayTime = dayTime;
                                                    this._rangTime = rangTime;
                                                    this._itemTime = itemTime;
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        });
//                                  showPickerArray(context);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          height: 48,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            datetimeMsg == null
                                                ? "必填 装货时间"
                                                : datetimeMsg,
                                            style: TextStyle(
                                                color: datetimeMsg == null
                                                    ? Colors.grey
                                                    : Colors.black,
                                                fontWeight: datetimeMsg == null
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                                fontSize: datetimeMsg == null
                                                    ? 12
                                                    : 14),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            height: 1,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Text("服务要求和备注"),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return SafeArea(
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.8,
                                              child: DeliverRemark(
                                                onChanged:
                                                    (requireList, remark) {
                                                  setState(() {
                                                    this._requireList =
                                                        requireList;
                                                    this._remark = remark;
                                                  });
                                                },
                                                remark: _remark,
                                                selectedList: _requireList,
                                              ),
                                            ),
                                          );
                                        });
//                                  showPickerArray(context);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              minWidth: double.infinity,
                                              //宽度尽可能大
                                              minHeight: 48 //最小高度为50像素
                                              ),
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              remarkMsg == null
                                                  ? "选填 请输入"
                                                  : remarkMsg,
                                              maxLines: 3,
                                              style: TextStyle(
                                                color: remarkMsg == null
                                                    ? Colors.grey
                                                    : Colors.black,
                                                fontWeight: remarkMsg == null
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                                fontSize:
                                                    remarkMsg == null ? 12 : 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Card(
                        child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("期望运费"),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextField(
                                  focusNode: _moneyNode,
                                  controller: _textController,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  minLines: 1,
                                  maxLines: 1,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9.]")),
                                    //只输入数字
                                    UsNumberTextInputFormatter(),
                                    //只输入数字
                                  ],
                                  textInputAction: TextInputAction.done,
                                  style: TextStyle(fontSize: 14),
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade200,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    hintStyle: TextStyle(fontSize: 14),
                                    contentPadding: EdgeInsets.all(10),
                                    hintText: "选填,请输入运费",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _unitList.length,
                            itemBuilder: (BuildContext context, int position) {
                              var item = _unitList[position];
                              return SelectButton(
                                text: item,
                                isSelected: _selectedUnit == item,
                                onTap: () {
                                  setState(() {
                                    _selectedUnit = item;
                                  });
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ))
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Row(
                  children: <Widget>[
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width / 2,
                      onPressed: () {
                        if(!_setupConfirm()){
                          return;
                        }
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context){
                                return AssignDriver(widget.formData,1);
                              }
                            ));
                      },
                      child: Text("指定司机"),
                      color: Colors.white,
                      height: 48,
                    ),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width / 2,
                      onPressed: () {
                        if(!_setupConfirm()){
                          return;
                        }
                        if(widget.isEdit == null || !widget.isEdit){
                          HttpManager.getInstance()
                              .post("/api/v1/deliver/goods",
                              data: widget.formData)
                              .then((value) {
                            Navigator.popUntil(
                                context, ModalRoute.withName(HomePage.routeKey));
                            eventBus.fire(DeliveryPublishedEvent());
                            Toast.show("发货成功");
                          });
                        }else{
                          HttpManager.getInstance()
                              .put("/api/v1/deliver/goods/${widget.record.id}",
                              data: widget.formData)
                              .then((value) {
                            Navigator.popUntil(
                                context, ModalRoute.withName(HomePage.routeKey));
                            eventBus.fire(DeliveryPublishedEvent());
                            Toast.show("修改成功");
                          });
                        }

                      },
                      child: Text("确认发货"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      height: 48,
                    ),
                  ],
                ),
              )
            ],
          ),
        )));
  }

  bool _setupConfirm() {
    if (_dayTime == null &&
        _rangTime == null &&
        _itemTime == null) {
      Toast.show("请选择装货时间");
      return false;
    }

    if(_textController.text.isNotEmpty && _selectedUnit == null){
      Toast.show("请选择费用单位");
      return false;
    }

    var start;
    var end;
    if (_dayTime.title == "今天或明天") {
      DateTime now = DateTime.now();
      start =
          _dateFormat.format(now) + " " + _itemTime.startAt;
      end = _dateFormat.format(now.add(Duration(days: 1))) +
          " " +
          _itemTime.endAt;
    } else {
      start = _dayTime.date + " " + _itemTime.startAt;
      end = _dayTime.date + " " + _itemTime.endAt;
    }

    widget.formData['loadStartAt'] =
        _dateFormatAll.parse(start).millisecondsSinceEpoch;
    widget.formData['loadEndAt'] =
        _dateFormatAll.parse(end).millisecondsSinceEpoch;
    widget.formData['remark'] = _remark;
    widget.formData['requireList'] = _requireList;
    widget.formData['expectMoney'] = _textController.text;
    widget.formData['expectUnit'] = _selectedUnit;
    return true;
  }
}
