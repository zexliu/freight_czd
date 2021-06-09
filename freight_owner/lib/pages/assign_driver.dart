import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freightowner/event/events.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/simple_driver_entity.dart';
import 'package:freightowner/utils/area_utils.dart';
import 'package:freightowner/utils/text_input_formatter.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:freightowner/widget/loading_dialog.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'home.dart';

class AssignDriver extends StatefulWidget {
  final Map<String, dynamic> formData;
  final type;
  AssignDriver(this.formData,this.type);

  @override
  _AssignDriverState createState() => _AssignDriverState();
}

class _AssignDriverState extends State<AssignDriver> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _amountController1 = TextEditingController();
  TextEditingController _amountController2 = TextEditingController();
  FocusNode _searchNode = FocusNode();
  FocusNode _amountNode1 = FocusNode();
  FocusNode _amountNode2 = FocusNode();
  bool _enablePullUp = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _current = 1;

  int _size = 10;
  List<SimpleDriverRecord> _orderDrivers = [];
  SimpleDriverRecord _searchDriver;

  bool _isSearching = false;

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _searchNode),
    ], nextFocus: false);
  }

  KeyboardActionsConfig _buildAlertConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _amountNode1),
      KeyboardActionsItem(focusNode: _amountNode2),
    ], nextFocus: true);
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  void _onRefresh() {
    // monitor network fetch
    _refreshController.resetNoData();
    _current = 1;
    HttpManager.getInstance().get("/api/v1/orders/drivers", params: {
      "current": _current,
      "size": _size,
    }).then((value) {
      _refreshController.refreshCompleted();
      _orderDrivers.clear();
      _orderDrivers = SimpleDriverEntity().fromJson(value).records;
      _enablePullUp = _orderDrivers.length == _size;
      if (mounted) setState(() {});
    }).catchError((e) => {_refreshController.refreshFailed()});
    // if failed,use refreshFailed()
  }

  void _onLoading() {
    // monitor network fetch
    _current++;
    HttpManager.getInstance().get("/api/v1/orders/drivers", params: {
      "current": _current,
      "size": _size,
    }).then((value) {
      var values = SimpleDriverEntity().fromJson(value).records;
      _orderDrivers.addAll(values);
      if (values.length < 10) {
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
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("指定司机"),
      ),
      body: SafeArea(
        child: KeyboardActions(
          config: _buildConfig(context),
          autoScroll: false,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: TextField(
                  onChanged: (value) => {_fetchDriver(value)},
                  focusNode: _searchNode,
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(fontSize: 12),
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding: EdgeInsets.all(0),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: InkWell(
                      onTap: () => {
                        _searchController.clear(),
                        _fetchDriver(_searchController.text)
                      },
                      child: Icon(Icons.clear),
                    ),
                    hintText: "请输入手机号码查找司机",
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                ),
              ),
              Expanded(
                  child: _searchController.text == null ||
                          _searchController.text.length == 0
                      ? _buildList()
                      : _searchController.text.length == 11 && !_isSearching
                          ? _buildSearch()
                          : Container())
            ],
          ),
        ),
      ),
    );
  }

  _fetchDriver(String value) {
    if (value.length == 11) {
      _isSearching = true;
      HttpManager.getInstance()
          .get("/api/v1/users/driver", params: {"mobile": value}).then((value) {
        setState(() {
          print("获取陈宫");
          _isSearching = false;
          if (value != "") {
            print("有数据");
            _searchDriver = SimpleDriverRecord().fromJson(value);
          } else {
            print("没数据");
            _searchDriver = null;
          }
        });
      });
    } else if (value.length == 0) {
      setState(() {});
    }
  }

  _buildList() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: _enablePullUp,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
          itemCount: _orderDrivers.length,
          itemBuilder: (c, i) {
            var item = _orderDrivers[i];
            return Padding(
              padding: EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: item.avatar,
                                placeholder: (context, url) =>
                                    Image.asset("images/default_avatar.png",fit: BoxFit.cover,
                                      width: 30,
                                      height: 30,),
                                fit: BoxFit.cover,
                                width: 30,
                                height: 30,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(item.nickname)
                            ],
                          ),
                          Text(
                            "已认证",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        item.mobile,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "${item.carLong}  ${item.carModel}",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      ),
                      Divider(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(),
                          MaterialButton(
                            child: Text("指定承运"),
                            onPressed: () {
                              _showDialog(item);
                            },
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  _buildSearch() {
    print("build search");
    return _searchDriver == null || _searchDriver.carLong == null
        ? Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: _searchDriver == null
                                  ? ""
                                  : _searchDriver.avatar,
                              placeholder: (context, url) =>
                                  Image.asset("images/default_avatar.png", fit: BoxFit.cover,
                                    width: 30,
                                    height: 30,),
                              fit: BoxFit.cover,
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(_searchDriver == null ? "未注册司机" : "未认证司机")
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(_searchDriver == null
                        ? "很遗憾,该司机未注册司机端,无法承运,如需与其成交,请联系该司机注册"
                        : "很遗憾,该司机未认证司机端,无法承运,如需与其成交,请联系该司机认证"),
                    SizedBox(
                      height: 4,
                    ),
                  ],
                ),
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: _searchDriver.avatar,
                              placeholder: (context, url) =>
                                  Image.asset("images/default_avatar.png",fit: BoxFit.cover,
                                    width: 30,
                                    height: 30,),
                              fit: BoxFit.cover,
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(_searchDriver.nickname)
                          ],
                        ),
                        Text(
                          "已认证",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      _searchDriver.mobile,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "${_searchDriver.carLong}  ${_searchDriver.carModel}",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        )
                      ],
                    ),
                    Divider(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(),
                        MaterialButton(
                          child: Text("指定承运"),
                          onPressed: () {
                            _showDialog(_searchDriver);
                          },
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }

  void _showDialog(SimpleDriverRecord item) {
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
                                "${item.nickname}(${item.carLong}/${item.carModel})",
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
                      "${AreaUtils.findCity(widget.formData["loadProvinceCode"], widget.formData["loadCityCode"]).label} ${AreaUtils.findDistrict(widget.formData["loadProvinceCode"], widget.formData["loadCityCode"], widget.formData["loadDistrictCode"]).label} → ${AreaUtils.findCity(widget.formData["unloadProvinceCode"], widget.formData["unloadCityCode"]).label} ${AreaUtils.findDistrict(widget.formData["unloadProvinceCode"], widget.formData["unloadCityCode"], widget.formData["unloadDistrictCode"]).label}",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      "${(widget.formData["carLongs"] as List).join("米/")} ${(widget.formData["carModels"] as List).join("/")} ${widget.formData["weight"] == null ? "" : " ${widget.formData["weight"]}吨"}${widget.formData["volume"] == null ? "" : " ${widget.formData["volume"]}方"}",
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
                              FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                              //只输入数字
                              UsNumberTextInputFormatter(50000),
                              //只输入数字
                            ],
                            focusNode: _amountNode1,
                            controller: _amountController1,
                            textInputAction: TextInputAction.next,
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
                              FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                              //只输入数字
                              UsNumberTextInputFormatter(1000),
                              //只输入数字
                            ],
                            focusNode: _amountNode2,
                            controller: _amountController2,
                            textInputAction: TextInputAction.done,
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
                  if (_amountController1.text.isEmpty || double.parse(_amountController1.text) < 10) {
                    Toast.show("请输入有效应付运费");
                    return;
                  }
                  if (_amountController2.text.isEmpty || double.parse(_amountController2.text) < 50) {
                    Toast.show("请输入有效订金");
                    return;
                  }
                  widget.formData['driverId'] = item.id;
                  widget.formData['amount'] = _amountController2.text;
                  widget.formData['freightAmount'] = _amountController1.text;
                  showLoadingDialog();
                  HttpManager.getInstance().post(widget.type == 1 ? "/api/v1/deliver/goods": '/api/v1/orders',data: widget.formData).then((value){
                    hideLoadingDialog();
                    eventBus.fire(DeliveryOrderedEvent());
                    Navigator.popUntil(
                        context, ModalRoute.withName(HomePage.routeKey));
                  }).catchError(hideLoadingDialog());
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
