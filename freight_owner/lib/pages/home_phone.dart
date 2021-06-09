import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/event/events.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/call_entity.dart';
import 'package:freightowner/utils/area_utils.dart';
import 'package:freightowner/utils/phone_utils.dart';
import 'package:freightowner/utils/text_input_formatter.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'empty_page.dart';

class HomePhonePage extends StatefulWidget {
  @override
  _HomePhonePageState createState() => _HomePhonePageState();
}

class _HomePhonePageState extends State<HomePhonePage>
    with WidgetsBindingObserver {
  List<CallRecord> _items = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController _amountController1 = TextEditingController();
  TextEditingController _amountController2 = TextEditingController();
  FocusNode _amountNode1 = FocusNode();
  FocusNode _amountNode2 = FocusNode();
  StreamSubscription<HomePageChangedEvent> _listen;

  KeyboardActionsConfig _buildAlertConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _amountNode1),
      KeyboardActionsItem(focusNode: _amountNode2),
    ], nextFocus: true);
  }

  var _current = 1;
  var _size = 10;
  var _enablePullUp = false;

  @override
  void initState() {
    _onRefresh();
    super.initState();
    _listen = eventBus.on<HomePageChangedEvent>().listen((event) {
      if (event.index == 1) {
        _onRefresh();
      }
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onRefresh();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _listen.cancel();
    super.dispose();
  }

  void _onRefresh() async {
    _refreshController.resetNoData();
    _current = 1;
    HttpManager.getInstance().get("/api/v1/calls",
        params: {"current": _current, "size": _size}).then((value) {
      _refreshController.refreshCompleted();
      _items.clear();
      _items = CallEntity().fromJson(value).records;
      _enablePullUp = _items.length == _size;
      if (mounted) setState(() {});
    }).catchError((e) => {_refreshController.refreshFailed()});
  }

  void _onLoading() async {
    _current++;
    HttpManager.getInstance().get("/api/v1/calls",
        params: {"current": _current, "size": _size}).then((value) {
      var values = CallEntity().fromJson(value).records;
      _items.addAll(values);
      if (values.length < _size) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
      if (mounted) setState(() {});
    }).catchError((e) => {_refreshController.loadFailed()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "通话记录",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: _enablePullUp,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child:
              _items.length == 0 ? _buildEmpty(context) : _buildList(context),
        ));
  }

  Widget _buildEmpty(BuildContext context) {
    return EmptyPage(
      image: "images/empty_phone.png",
      children: <Widget>[
        SizedBox(
          height: 16,
        ),
        Text("暂无数据"),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemBuilder: (c, i) {
        var item = _items[i];
        return Padding(
          padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Card(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: item.type == true
                                ? item.fromAvatar
                                : item.toAvatar,
                            placeholder: (context, url) => Image.asset(
                              "images/default_avatar.png",
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                            ),
                            fit: BoxFit.cover,
                            width: 48,
                            height: 48,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    item.type == true
                                        ? item.fromNickname
                                        : item.toNickname,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    item.type == true
                                        ? item.fromMobile
                                        : item.toMobile,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    AreaUtils.getCityAndDistrictName(
                                        item.loadProvinceCode,
                                        item.loadCityCode,
                                        item.loadDistrictCode),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Image.asset(
                                    "images/arrow_right_alt.png",
                                    width: 40,
                                    height: 28,
                                  ),
                                  Text(
                                    AreaUtils.getCityAndDistrictName(
                                        item.unloadProvinceCode,
                                        item.unloadCityCode,
                                        item.unloadDistrictCode),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(56, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              item.goodsStatus == 1 ? "发货中" : "已下架",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12),
                            ),
                            Row(
                              children: <Widget>[
                                Visibility(
                                  visible: item.goodsStatus == 1,
                                  child: InkWell(
                                    onTap: () {
                                      _showDialog(item);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 1),
                                          color: Colors.grey.shade300),
                                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                      child: Text(
                                        "指定承运",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
//                                GestureDetector(
//                                  child: Container(
//                                    decoration: BoxDecoration(
//                                        border: Border.all(
//                                            color: Theme.of(context)
//                                                .primaryColor,
//                                            width: 1),
//                                        color: true
//                                            ? Colors.transparent
//                                            : Colors.grey.shade300),
//                                    padding:
//                                    EdgeInsets.fromLTRB(8, 4, 8, 4),
//                                    child: Text(
//                                      "  聊天  ",
//                                      style: TextStyle(
//                                          fontSize: 12,
//                                          color: true
//                                              ? Theme.of(context)
//                                              .primaryColor
//                                              : Theme.of(context)
//                                              .primaryColor),
//                                    ),
//                                  ),
//                                ),
//                                SizedBox(
//                                  width: 8,
//                                ),
                                InkWell(
                                  onTap: () {
                                    PhoneUtils.call(
                                        item.type == true
                                            ? item.fromMobile
                                            : item.toMobile,
                                        item.type == true
                                            ? item.fromUserId
                                            : item.toUserId,
                                        item.goodsId);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1),
                                        color: Theme.of(context).primaryColor),
                                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                    child: Text(
                                      " 打电话 ",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ))),
        );
      },
      itemCount: _items.length,
    );
  }

  void _showDialog(CallRecord item) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return new CupertinoAlertDialog(
            title: new Text("指定司机承运"),
            content: KeyboardActions(
              config: _buildAlertConfig(context),
              autoScroll: false,
              isDialog: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 4,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "您指定司机",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        children: [
                          TextSpan(
                            text:
                                "${item.type ? item.fromNickname : item.toNickname}",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          TextSpan(
                              text: "承运",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                        ]),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      "${AreaUtils.findCity(item.loadProvinceCode, item.loadCityCode).label} ${AreaUtils.findDistrict(item.loadProvinceCode, item.loadCityCode, item.loadDistrictCode).label} → ${AreaUtils.findCity(item.unloadProvinceCode, item.unloadCityCode).label} ${AreaUtils.findDistrict(item.unloadProvinceCode, item.unloadCityCode, item.unloadDistrictCode).label}",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      "${item.carLongs.replaceAll(",", "米/")} ${item.carModels.replaceAll(",", "/")} ${item.weight == null ? "" : " ${item.weight}吨"}${item.volume == null ? "" : " ${item.volume}方"}",
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    color: Colors.grey.shade200,
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "应付运费:",
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: TextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9.]")),
                              //只输入数字
                              UsNumberTextInputFormatter(50000),
                              //只输入数字
                            ],
                            focusNode: _amountNode1,
                            controller: _amountController1,
                            textInputAction: TextInputAction.search,
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.end,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.all(0),
                              suffixText: " 元",
                              hintText: "必填10-50000",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    color: Colors.grey.shade200,
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "订金:",
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: TextField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9.]")),
                              //只输入数字
                              UsNumberTextInputFormatter(1000),
                              //只输入数字
                            ],
                            focusNode: _amountNode2,
                            controller: _amountController2,
                            textInputAction: TextInputAction.search,
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.end,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(fontSize: 12),
                              contentPadding: EdgeInsets.all(0),
                              suffixText: " 元",
                              hintText: "必填50-1000",
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  if (_amountController1.text.isEmpty ||
                      double.parse(_amountController1.text) < 10) {
                    Toast.show("请输入有效应付运费");
                    return;
                  }
                  if (_amountController2.text.isEmpty ||
                      double.parse(_amountController2.text) < 50) {
                    Toast.show("请输入有效订金");
                    return;
                  }

                  Map<String, dynamic> formData = {};
                  formData['deliveryId'] = item.goodsId;
                  formData['driverId'] =
                      item.type ? item.fromUserId : item.toUserId;
                  formData['amount'] = _amountController2.text;
                  formData['freightAmount'] = _amountController1.text;
                  HttpManager.getInstance()
                      .post('/api/v1/orders', data: formData)
                      .then((value) {
                    eventBus.fire(DeliveryOrderedEvent());
                    Navigator.of(context).pop();
                    Toast.show("发货成功");
                    item.goodsStatus = 0;
                    setState(() {});
                  });
                },
                child: new Text(
                  "确认",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  _amountController1.text = "";
                  _amountController2.text = "";
                  Navigator.of(context).pop();
                },
                child: new Text("取消"),
              ),
            ],
          );
        });
  }
}
