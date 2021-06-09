import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/area_entity.dart';
import 'package:flutterdriver/model/order_protocol_entity.dart';
import 'package:flutterdriver/utils/Toast.dart';
import 'package:flutterdriver/utils/area_utils.dart';
import 'package:flutterdriver/utils/date_utils.dart';
import 'package:flutterdriver/utils/text_input_formatter.dart';
import 'package:flutterdriver/widget/car_picker.dart';
import 'package:flutterdriver/widget/city_picker.dart';
import 'package:flutterdriver/widget/loading_dialog.dart';
import 'package:flutterdriver/widget/time_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import 'announcement_details_page.dart';
import 'deliver_adress_input.dart';

class ProtocolPage extends StatefulWidget {
  final String orderId;

  ProtocolPage(this.orderId);

  @override
  _ProtocolPageState createState() => _ProtocolPageState();
}

class _ProtocolPageState extends State<ProtocolPage> {
  FocusNode freightAmountNode = FocusNode();
  FocusNode daysNode = FocusNode();
  FocusNode weightNode = FocusNode();
  FocusNode volumeNode = FocusNode();
  FocusNode carNoNode = FocusNode();
  FocusNode supplementNode = FocusNode();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _freightAmountController =
      TextEditingController();

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _carNoController = TextEditingController();
  final TextEditingController _supplementController = TextEditingController();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: freightAmountNode),
      KeyboardActionsItem(focusNode: daysNode),
      KeyboardActionsItem(focusNode: weightNode),
      KeyboardActionsItem(focusNode: volumeNode),
      KeyboardActionsItem(focusNode: carNoNode),
      KeyboardActionsItem(focusNode: supplementNode),
    ]);
  }

  AreaEntity _uploadProvince;
  AreaEntity _uploadCity;
  AreaEntity _uploadDistrict;

  AreaEntity _loadProvince;
  AreaEntity _loadCity;
  AreaEntity _loadDistrict;

  String _loadAddress = "";
  Poi _loadPoint;

  String _uploadAddress = "";
  Poi _uploadPoint;

  bool protocolChecked = true;
  Future<OrderProtocolEntity> _fetchDetails;
  var _dateFormatAll = DateFormat('yyyy-MM-dd HH:mm:ss');

  @override
  void initState() {
    super.initState();
    _amountController.text = "50";
    _fetchDetails = _fetch();
  }

  Future<OrderProtocolEntity> _fetch() async {
    var v = await HttpManager.getInstance()
        .get("/api/v1/protocols/${widget.orderId}");
    print("fetch protocol----------");

    var entity = OrderProtocolEntity().fromJson(v);
    _amountController.text = entity.amount.toString();
    _freightAmountController.text = entity.freightAmount.toString();
    _loadProvince = AreaUtils.findProvince(entity.loadProvinceCode);
    _loadCity =
        AreaUtils.findCity(entity.loadProvinceCode, entity.loadCityCode);
    _loadDistrict = AreaUtils.findDistrict(
        entity.loadProvinceCode, entity.loadCityCode, entity.loadDistrictCode);

    _uploadProvince = AreaUtils.findProvince(entity.unloadProvinceCode);
    _uploadCity =
        AreaUtils.findCity(entity.unloadProvinceCode, entity.unloadCityCode);
    _uploadDistrict = AreaUtils.findDistrict(entity.unloadProvinceCode,
        entity.unloadCityCode, entity.unloadDistrictCode);

    _loadAddress = entity.loadAddress;
    _uploadAddress = entity.unloadAddress;
    _weightController.text =
        entity.weight == null ? "" : entity.weight.toString();
    _volumeController.text =
        entity.volume == null ? "" : entity.volume.toString();
    _daysController.text =
        entity.payDays == null ? "" : entity.payDays.toString();
    _carNoController.text =
        entity.plateNumber == null ? "" : entity.plateNumber;
    setState(() {});
    return entity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("货物运输协议"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: KeyboardActions(
          config: _buildConfig(context),
          autoScroll: true,
          child: FutureBuilder<OrderProtocolEntity>(
            future: _fetchDetails,
            builder: (c, s) {
              if (s.connectionState == ConnectionState.done) {
                if (s.hasError) {
                  return Text("error ${s.error}");
                } else {
                  String carMsg = "";
                  if (s.data.carType != null) {
                    carMsg = s.data.carType;
                  }
                  if (s.data.carLongs.isNotEmpty) {
                    carMsg += ",${s.data.carLongs.split(",").join("米,")}米";
                  }

                  if (s.data.carModels.isNotEmpty) {
                    carMsg += ",${s.data.carModels}";
                  }
                  return Column(
                    children: [
                      Card(
                        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "定金",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      enabled: false,
                                      controller: _amountController,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                      //输入文本的样式
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[0-9.]")),
                                        //只输入数字
                                        UsNumberTextInputFormatter(1000),
                                        //只输入数字
                                      ],
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 14),
                                        contentPadding: EdgeInsets.all(0),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text("元")
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    "总运费",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      enabled: s.data.id == null,
                                      focusNode: freightAmountNode,
                                      controller: _freightAmountController,
                                      textAlign: TextAlign.end,
                                      onChanged: (v) {
                                        s.data.freightAmount = double.parse(v);
                                      },
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                      //输入文本的样式
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[0-9.]")),
                                        //只输入数字
                                        UsNumberTextInputFormatter(50000),
                                        //只输入数字
                                      ],
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 14),
                                        contentPadding: EdgeInsets.all(0),
                                        hintText: "必填 含预付、到付、回单",
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text("元")
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text(
                                    "最晚卸货后",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      enabled: s.data.id == null,
                                      focusNode: daysNode,
                                      controller: _daysController,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold),
                                      //输入文本的样式
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: false),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[0-9]")),
                                        //只输入数字
                                        UsNumberTextInputFormatter(30),
                                        //只输入数字
                                      ],
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(fontSize: 14),
                                        contentPadding: EdgeInsets.all(0),
                                        hintText: "必填 1-30",
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text("天付运费")
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: InkWell(
                                      onTap: s.data.id != null
                                          ? null
                                          : () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (context) {
                                                    return SafeArea(
                                                      child: Container(
                                                        height: 240,
                                                        child: TimePicker(
                                                          dayTime: null,
                                                          rangTime: null,
                                                          itemTime: null,
                                                          onChanged: (dayTime,
                                                              rangTime,
                                                              itemTime) {
                                                            setState(() {
                                                              s.data.loadStartAt = _dateFormatAll
                                                                  .parse(dayTime
                                                                          .date +
                                                                      " " +
                                                                      itemTime
                                                                          .startAt)
                                                                  .millisecondsSinceEpoch;
                                                              s.data.loadEndAt = _dateFormatAll
                                                                  .parse(dayTime
                                                                          .date +
                                                                      " " +
                                                                      itemTime
                                                                          .endAt)
                                                                  .millisecondsSinceEpoch;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                      child: Column(
                                        children: [
                                          Text(
                                            "装货",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            DateUtils.getDayString(
                                                s.data.loadStartAt,
                                                s.data.loadEndAt),
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            DateUtils.getHourString(
                                                s.data.loadStartAt,
                                                s.data.loadEndAt),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "→→→",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                          "${s.data.loadStartAt != null ? DateUtils.diffDay(s.data.loadStartAt, s.data.unloadEndAt) : "- "}天"),
                                    ],
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: InkWell(
                                      onTap: s.data.id != null
                                          ? null
                                          : () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (context) {
                                                    return SafeArea(
                                                      child: Container(
                                                        height: 240,
                                                        child: TimePicker(
                                                          dayTime: null,
                                                          rangTime: null,
                                                          itemTime: null,
                                                          isMore: true,
                                                          onChanged: (dayTime,
                                                              rangTime,
                                                              itemTime) {
                                                            setState(() {
                                                              s.data.unloadStartAt = _dateFormatAll
                                                                  .parse(dayTime
                                                                          .date +
                                                                      " " +
                                                                      itemTime
                                                                          .startAt)
                                                                  .millisecondsSinceEpoch;
                                                              s.data.unloadEndAt = _dateFormatAll
                                                                  .parse(dayTime
                                                                          .date +
                                                                      " " +
                                                                      itemTime
                                                                          .endAt)
                                                                  .millisecondsSinceEpoch;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                      child: Column(
                                        children: [
                                          Text(
                                            "卸货",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            "${s.data.unloadStartAt != null ? DateUtils.getDayString(s.data.unloadStartAt, s.data.unloadEndAt) : "请选择"}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            "${s.data.unloadStartAt != null ? DateUtils.getHourString(s.data.unloadStartAt, s.data.unloadEndAt) : ""}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      color: Theme.of(context).primaryColor,
                                      height: 20,
                                      width: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "装",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: s.data.id != null
                                                ? null
                                                : () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        builder: (context) {
                                                          return SafeArea(
                                                            child: Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.8,
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          16,
                                                                          4,
                                                                          16,
                                                                          4),
                                                              child: CityPicker(
                                                                title: "选择装货地",
                                                                province:
                                                                    _loadProvince,
                                                                city: _loadCity,
                                                                district:
                                                                    _loadDistrict,
                                                                onChanged:
                                                                    (province,
                                                                        city,
                                                                        district) {
                                                                  setState(() {
                                                                    this._loadProvince =
                                                                        province;
                                                                    this._loadCity =
                                                                        city;
                                                                    this._loadDistrict =
                                                                        district;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 44,
                                              child: _buildAddressText(
                                                  "请输入装货地",
                                                  _loadProvince,
                                                  _loadCity,
                                                  _loadDistrict),
                                            ),
                                          ),
                                          Divider(
                                            height: 1,
                                          ),
                                          InkWell(
                                            onTap: s.data.id != null
                                                ? null
                                                : () {
                                                    if (_loadProvince == null ||
                                                        _loadCity == null ||
                                                        _loadDistrict == null) {
                                                      Toast.show("请选择装货地");
                                                      return;
                                                    }

                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                      return DeliverAddressInput(
                                                          _loadProvince,
                                                          _loadCity,
                                                          _loadDistrict,
                                                          "装货地",
                                                          _loadAddress,
                                                          _loadPoint);
                                                    })).then((value) {
                                                      if (value != null &&
                                                          value is List) {
                                                        setState(() {
                                                          this._loadAddress =
                                                              value[0];
                                                          this._loadPoint =
                                                              value[1];
                                                        });
                                                      }
                                                    });
                                                  },
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 44,
                                              child: Text(
                                                this._loadAddress == ""
                                                    ? s.data.id == null
                                                        ? "请输入详细地址"
                                                        : "--"
                                                    : this._loadAddress,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      color: Colors.blueAccent,
                                      height: 20,
                                      width: 20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "卸",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: s.data.id != null
                                                ? null
                                                : () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        builder: (context) {
                                                          return SafeArea(
                                                            child: Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.8,
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          16,
                                                                          4,
                                                                          16,
                                                                          4),
                                                              child: CityPicker(
                                                                title: "选择卸货地",
                                                                province:
                                                                    _uploadProvince,
                                                                city:
                                                                    _uploadCity,
                                                                district:
                                                                    _uploadDistrict,
                                                                onChanged:
                                                                    (province,
                                                                        city,
                                                                        district) {
                                                                  setState(() {
                                                                    this._uploadProvince =
                                                                        province;
                                                                    this._uploadCity =
                                                                        city;
                                                                    this._uploadDistrict =
                                                                        district;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        });
                                                  },
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 44,
                                              child: _buildAddressText(
                                                  "请输入卸货地",
                                                  _uploadProvince,
                                                  _uploadCity,
                                                  _uploadDistrict),
                                            ),
                                          ),
                                          Divider(
                                            height: 1,
                                          ),
                                          InkWell(
                                            onTap: s.data.id != null
                                                ? null
                                                : () {
                                                    if (_uploadProvince ==
                                                            null ||
                                                        _uploadCity == null ||
                                                        _uploadDistrict ==
                                                            null) {
                                                      Toast.show("请选择装卸地");
                                                      return;
                                                    }
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                      return DeliverAddressInput(
                                                          _uploadProvince,
                                                          _uploadCity,
                                                          _uploadDistrict,
                                                          "卸货地",
                                                          _uploadAddress,
                                                          _uploadPoint);
                                                    })).then((value) {
                                                      if (value != null &&
                                                          value is List) {
                                                        setState(() {
                                                          this._uploadAddress =
                                                              value[0];
                                                          this._uploadPoint =
                                                              value[1];
                                                        });
                                                      }
                                                    });
                                                  },
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 44,
                                              child: Text(
                                                this._uploadAddress == ""
                                                    ? s.data.id == null
                                                        ? "请输入详细地址"
                                                        : "--"
                                                    : this._uploadAddress,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("货物名称"),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    s.data.categoryName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text("车型车长"),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: s.data.id != null
                                          ? null
                                          : () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  builder: (context) {
                                                    return SafeArea(
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                        child: CarPicker(
                                                          carType:
                                                              s.data.carType,
                                                          carLongs: s
                                                              .data.carLongs
                                                              .split(","),
                                                          carModels: s
                                                              .data.carModels
                                                              .split(","),
                                                          isShowPlaceCarLong:
                                                              false,
                                                          onChanged: (carType,
                                                              carLongs,
                                                              placeCarLong,
                                                              carModels) {
                                                            setState(() {
                                                              s.data.carType =
                                                                  carType;
                                                              s.data.carLongs =
                                                                  carLongs.join(
                                                                      ",");
                                                              s.data.carModels =
                                                                  carModels
                                                                      .join(
                                                                          ",");
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                      child: Text(
                                        carMsg.isEmpty ? "必填 请选择车型车长" : carMsg,
                                        style: TextStyle(
                                            color: carMsg.isEmpty
                                                ? Colors.grey
                                                : Colors.black,
                                            fontWeight: carMsg.isEmpty
                                                ? FontWeight.normal
                                                : FontWeight.bold,
                                            fontSize: carMsg.isEmpty ? 12 : 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Text("重量/体积"),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    "请至少填写一项",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextField(
                                            enabled: s.data.id == null,
                                            controller: _weightController,
                                            focusNode: weightNode,
                                            textAlign: TextAlign.right,
                                            keyboardType: TextInputType.text,
                                            maxLength: 10,
                                            maxLines: 1,
                                            // keyboardType:
                                            //     TextInputType.numberWithOptions(
                                            //         decimal: true),
                                            decoration: InputDecoration(
                                              // hintText: "约0~999吨",
                                              hintText: "例: 30-50",
                                              fillColor: Colors.grey.shade200,
                                              filled: true,
                                              isDense: true,
                                              counterText: "",
                                              contentPadding: EdgeInsets.all(8),
                                              border: InputBorder.none,
                                            ),
                                            style: TextStyle(fontSize: 12),
                                            // inputFormatters: <
                                            //     TextInputFormatter>[
                                            //   FilteringTextInputFormatter.allow(
                                            //       RegExp("[0-9.]")),
                                            //   //只输入数字
                                            //   UsNumberTextInputFormatter(999),
                                            //   //只输入数字
                                            // ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text("吨"),
                                        SizedBox(
                                          width: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextField(
                                            enabled: s.data.id == null,
                                            controller: _volumeController,
                                            focusNode: volumeNode,
                                            textAlign: TextAlign.right,
                                            maxLines: 1,
                                            maxLength: 10,
                                            // keyboardType:
                                            //     TextInputType.numberWithOptions(
                                            //         decimal: true),
                                            keyboardType:
                                            TextInputType.text,
                                            decoration: InputDecoration(
                                              hintText: "例: 70-100",
                                              fillColor: Colors.grey.shade200,
                                              filled: true,
                                              isDense: true,
                                              counterText: "",
                                              contentPadding: EdgeInsets.all(8),
                                              border: InputBorder.none,
                                            ),
                                            style: TextStyle(fontSize: 12),
                                            // inputFormatters: <
                                            //     TextInputFormatter>[
                                            //   FilteringTextInputFormatter.allow(
                                            //       RegExp("[0-9.]")),
                                            //   //只输入数字
                                            //   UsNumberTextInputFormatter(999),
                                            //   //只输入数字
                                            // ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text("方"),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("承运车牌"),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      enabled: s.data.id == null,
                                      focusNode: carNoNode,
                                      controller: _carNoController,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      //输入文本的样式
                                      keyboardType: TextInputType.text,
                                      maxLength: 12,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                        counterText: "",
                                        hintStyle: TextStyle(fontSize: 14),
                                        contentPadding: EdgeInsets.all(0),
                                        hintText: "请输入承运车牌",
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Text(
                                "请确保车辆与实际承运车辆一致,否则保障无效",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("补充约定"),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                  child: TextField(
                                    enabled: s.data.id == null,
                                    focusNode: supplementNode,
                                    controller: _supplementController,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(fontSize: 14),
                                    //输入文本的样式
                                    keyboardType: TextInputType.text,
                                    maxLength: 200,
                                    maxLines: 3,
                                    minLines: 3,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintStyle: TextStyle(fontSize: 12),
                                      contentPadding: EdgeInsets.all(0),
                                      hintText: s.data.id == null
                                          ? "佣金，回单押金;如果选择不在线支付在此处可以补充线下付款方式:禁区;几装几卸等约定"
                                          : "",
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: protocolChecked,
                            onChanged: s.data.driverAgree
                                ? null
                                : (v) {
                                    setState(() {
                                      protocolChecked = v;
                                    });
                                  },
                          ),
                          RichText(
                            text: TextSpan(
                                text: "我已阅读并同意",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black38),
                                children: [
                                  TextSpan(
                                    text: "《货物运输协议》",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (c){
                                              return AnnouncementDetailsPage("5");
                                            }
                                        ));
                                      },
                                  ),
                                  TextSpan(
                                      text: "和",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black38)),
                                  TextSpan(
                                    text: "《货物运输交易规则》",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (c){
                                              return AnnouncementDetailsPage("6");
                                            }
                                        ));
                                      },
                                  ),
                                ]),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: MaterialButton(
                          child: Text(s.data.id == null
                              ? "提交"
                              : s.data.driverAgree && s.data.userAgree
                                  ? "已签署"
                                  : s.data.driverAgree ? "已提交" : "同意"),
                          color: Theme.of(context).primaryColor,
                          disabledColor: Colors.blueGrey,
                          disabledTextColor: Colors.white,
                          textColor: Colors.white,
                          minWidth: double.infinity,
                          onPressed: s.data.id == null || !s.data.driverAgree
                              ? () {
                                  if (_freightAmountController.text.isEmpty ||
                                      double.parse(
                                              _freightAmountController.text) <
                                          10 ||
                                      double.parse(
                                              _freightAmountController.text) >
                                          50000) {
                                    Toast.show("运费在 10-50000之间");
                                    return;
                                  }
                                  if (_daysController.text.isEmpty ||
                                      int.parse(_daysController.text) < 1 ||
                                      int.parse(_daysController.text) > 30) {
                                    Toast.show("最晚付运费时间为 1-30天之间");
                                    return;
                                  }
                                  if (s.data.loadStartAt == null) {
                                    Toast.show("请选择装货时间");
                                    return;
                                  }
                                  if (s.data.unloadStartAt == null) {
                                    Toast.show("请选择卸货时间");
                                    return;
                                  }
                                  if (s.data.unloadEndAt < s.data.loadStartAt) {
                                    Toast.show("卸货时间不得小于装货时间");
                                    return;
                                  }
                                  if (s.data.volume == null &&
                                      s.data.weight == null) {
                                    Toast.show("重量/体积最少填写一项");
                                    return;
                                  }
                                  RegExp reg = new RegExp(
                                      r"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$");

                                  if (!reg.hasMatch(
                                      _carNoController.text.toUpperCase())) {
                                    Toast.show("请输入正确的车牌号");
                                    return;
                                  }
                                  if (!protocolChecked) {
                                    Toast.show("请勾选协议");
                                    return;
                                  }
                                  showLoadingDialog();
                                  if (s.data.id == null) {
                                    HttpManager.getInstance()
                                        .post("/api/v1/protocols", data: {
                                      "orderId": widget.orderId,
                                      "amount": s.data.amount,
                                      "freightAmount":
                                          _freightAmountController.text,
                                      "payDays": _daysController.text,
                                      "loadStartAt": s.data.loadStartAt,
                                      "loadEndAt": s.data.loadEndAt,
                                      "unloadStartAt": s.data.unloadStartAt,
                                      "unloadEndAt": s.data.unloadEndAt,
                                      "loadProvinceCode":
                                          s.data.loadProvinceCode,
                                      "loadCityCode": s.data.loadCityCode,
                                      "loadDistrictCode":
                                          s.data.loadDistrictCode,
                                      "unloadProvinceCode":
                                          s.data.unloadProvinceCode,
                                      "unloadCityCode": s.data.unloadCityCode,
                                      "unloadDistrictCode":
                                          s.data.unloadDistrictCode,
                                      "loadAddress": s.data.loadAddress,
                                      "unloadAddress": s.data.unloadAddress,
                                      "categoryName": s.data.categoryName,
                                      "carType": s.data.carType,
                                      "carLongs": s.data.carLongs,
                                      "carModels": s.data.carModels,
                                      "weight": _weightController.text,
                                      "volume": _volumeController.text,
                                      "plateNumber": _carNoController.text,
                                      "supplement": _supplementController.text,
                                    }).then((value) {
                                      Toast.show("提交成功");
                                      _fetchDetails = _fetch();
                                    }).whenComplete(() {
                                      hideLoadingDialog();
                                    });
                                  } else {
                                    HttpManager.getInstance()
                                        .post(
                                            "/api/v1/protocols/agree/${s.data.id}")
                                        .then((value) {
                                          Toast.show("提交成功");
                                          _fetchDetails = _fetch();
                                        })
                                        .catchError((e) => {print(e)})
                                        .whenComplete(
                                            () => hideLoadingDialog());
                                  }
                                }
                              : null,
                        ),
                      )
                    ],
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _buildAddressText(
      String msg, AreaEntity province, AreaEntity city, AreaEntity district) {
    String message;
    if (province != null && city != null && district != null) {
      if (province.label == city.label) {
        message = "${province.label} ${district.label}";
      } else {
        message = "${province.label} ${city.label} ${district.label}";
      }
    } else {
      message = msg;
    }
    return Text(
      message,
      maxLines: 1,
    );
  }
}
