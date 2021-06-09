import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/event/events.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/area_entity.dart';
import 'package:freightowner/model/deliver_goods_entity.dart';
import 'package:freightowner/pages/deliver_details.dart';
import 'package:freightowner/pages/empty_page.dart';
import 'package:freightowner/utils/area_utils.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:freightowner/widget/city_selector.dart';
import 'package:freightowner/widget/dropdown_header.dart';
import 'package:freightowner/widget/dropdown_menu.dart';
import 'package:freightowner/widget/dropdown_menu_controller.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:freightowner/utils/date_extension.dart';

import 'deliver_page.dart';

class DeliverListHistory extends StatefulWidget {
  @override
  _DeliverListHistoryState createState() => _DeliverListHistoryState();
}

class _DeliverListHistoryState extends State<DeliverListHistory>
    with AutomaticKeepAliveClientMixin {
  StreamSubscription<DeliveryDeletedEvent> _deleteListen;
  List<DeliverGoodsRecord> _items = [];
  List<String> _dropDownHeaderItemStrings = ['出发地', '目的地', '全部'];

  DropdownMenuController _dropdownMenuController = DropdownMenuController();
  GlobalKey _stackKey = GlobalKey();

  List<_CustomDate> _customDates = [];

  var _dateSelectedIndex = 0;

  int _current = 1;

  int _size = 10;

  bool _enablePullUp = false;

  AreaEntity _loadProvince;
  AreaEntity _loadCity;
  AreaEntity _loadDistrict;

  AreaEntity _unloadProvince;
  AreaEntity _unloadCity;
  AreaEntity _unloadDistrict;

  var _selectedIndex;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _deleteListen = eventBus.on<DeliveryDeletedEvent>().listen((event) {
      setState(() {
        _items.insert(0, event.record);
      });
    });


    var zhDateFormat = DateFormat('MM月dd日');
    DateTime now = DateTime.now();
    _customDates.add(_CustomDate("全部", null, null));
    _customDates.add(_CustomDate(
        "今天",
        DateTime(now.year, now.month, now.day).millisecondsSinceEpoch,
        DateTime(now.year, now.month, now.day + 1).millisecondsSinceEpoch));
    _customDates.add(_CustomDate(
        "昨天",
        DateTime(now.year, now.month, now.day - 1).millisecondsSinceEpoch,
        DateTime(now.year, now.month, now.day).millisecondsSinceEpoch));
    _customDates.add(_CustomDate(
        "前天",
        DateTime(now.year, now.month, now.day - 2).millisecondsSinceEpoch,
        DateTime(now.year, now.month, now.day - 1).millisecondsSinceEpoch));
    _customDates.add(_CustomDate(
        zhDateFormat.format(now.subtract(Duration(days: 3))),
        DateTime(now.year, now.month, now.day - 3).millisecondsSinceEpoch,
        DateTime(now.year, now.month, now.day - 2).millisecondsSinceEpoch));
    _customDates.add(_CustomDate(
        zhDateFormat.format(now.subtract(Duration(days: 4))),
        DateTime(now.year, now.month, now.day - 4).millisecondsSinceEpoch,
        DateTime(now.year, now.month, now.day - 3).millisecondsSinceEpoch));
    _customDates.add(_CustomDate(
        zhDateFormat.format(now.subtract(Duration(days: 5))),
        DateTime(now.year, now.month, now.day - 5).millisecondsSinceEpoch,
        DateTime(now.year, now.month, now.day - 4).millisecondsSinceEpoch));
    _customDates.add(_CustomDate(
        zhDateFormat.format(now.subtract(Duration(days: 6))),
        DateTime(now.year, now.month, now.day - 6).millisecondsSinceEpoch,
        DateTime(now.year, now.month, now.day - 5).millisecondsSinceEpoch));

    super.initState();
    this._onRefresh();
  }

  void _onRefresh() async {
    // monitor network fetch
    _refreshController.resetNoData();
    _current = 1;

    HttpManager.getInstance().get("/api/v1/deliver/goods/self", params: {
      "status": 0,
      "current": _current,
      "size": _size,
      "startAt": this._customDates[_dateSelectedIndex].startAt,
      "endAt": this._customDates[_dateSelectedIndex].endAt,
      "loadProvinceCode": _loadProvince != null ? _loadProvince.value : null,
      "loadCityCode": _loadCity != null ? _loadCity.value : null,
      "loadDistrictCode": _loadDistrict != null ? _loadDistrict.value : null,
      "unloadProvinceCode":
          _unloadProvince != null ? _unloadProvince.value : null,
      "unloadCityCode": _unloadCity != null ? _unloadCity.value : null,
      "unloadDistrictCode":
          _unloadDistrict != null ? _unloadDistrict.value : null,
      "order":"time",

    }).then((value) {
      _refreshController.refreshCompleted();
      _items.clear();
      _items = DeliverGoodsEntity().fromJson(value).records;
      _enablePullUp = _items.length == _size;
      if (mounted) setState(() {});
    }).catchError((e) => {_refreshController.refreshFailed()});
  }

  void _onLoading() async {
    print("onLoading");
    _current++;
    HttpManager.getInstance().get("/api/v1/deliver/goods/self", params: {
      "status": 0,
      "current": _current,
      "size": _size,
      "startAt": this._customDates[_dateSelectedIndex].startAt,
      "endAt": this._customDates[_dateSelectedIndex].endAt,
      "loadProvinceCode": _loadProvince != null ? _loadProvince.value : null,
      "loadCityCode": _loadCity != null ? _loadCity.value : null,
      "loadDistrictCode": _loadDistrict != null ? _loadDistrict.value : null,
      "unloadProvinceCode":
      _unloadProvince != null ? _unloadProvince.value : null,
      "unloadCityCode": _unloadCity != null ? _unloadCity.value : null,
      "unloadDistrictCode":
      _unloadDistrict != null ? _unloadDistrict.value : null,
      "order":"time",
    }).then((value) {
      print("load success");
      var values = DeliverGoodsEntity().fromJson(value).records;
      _items.addAll(values);
      if (values.length < 10) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
      if (mounted) setState(() {});
      print("refresh");
    }).catchError((e) => {_refreshController.loadFailed()});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      key: _stackKey,
      children: <Widget>[
        Column(
          children: <Widget>[
            DropDownHeader(
              // GZXDropDownHeader对应第一父级Stack的key
              stackKey: _stackKey,
              // controller用于控制menu的显示或隐藏
              controller: _dropdownMenuController,
              items: [
                DropDownHeaderItem(_loadDistrict != null
                    ? _loadDistrict.label
                    : _loadCity != null
                        ? _loadCity.label
                        : _loadProvince != null
                            ? _loadProvince.label
                            : _dropDownHeaderItemStrings[0]),
                DropDownHeaderItem(_unloadDistrict != null
                    ? _unloadDistrict.label
                    : _unloadCity != null
                        ? _unloadCity.label
                        : _unloadProvince != null
                            ? _unloadProvince.label
                            : _dropDownHeaderItemStrings[1]),
                DropDownHeaderItem(_dateSelectedIndex == null
                    ? _dropDownHeaderItemStrings[0]
                    : _customDates[_dateSelectedIndex].title),
              ],
              onItemTap: (index) {
                setState(() {
                  this._selectedIndex = index;
                });
              },
            ),
            Expanded(
              child: _buildBody(),
            )
          ],
        ),
        _buildMenu(context),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return EmptyPage(
      image: "images/truck.png",
      children: <Widget>[
        SizedBox(
          height: 16,
        ),
        Text("暂无数据"),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: _enablePullUp,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.builder(
        itemBuilder: (c, i) {
          var item = _items[i];
          return Padding(
            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
            child: Card(
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                      return DeliverDetailsPage(item.id, false);
                    }));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
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
                            Positioned(
                              right: 0,
                              child: Text(
                                item.deleteStatus == 1 ? "已删除" : "已下架",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "${item.carType} ${item.carModels} ${item.carLongs}(米) ${item.categoryName}"
                                  "${item.weight == null ? "" : ' ${item.weight}吨'}"
                                  "${item.volume == null ? "" : ' ${item.volume}方'}"
                                  "${item.expectMoney == null ? "" : ' ${item.expectMoney}/${item.expectUnit}'}"
                              .replaceAll(",", "/"),
                          style: TextStyle(color: Colors.black87, fontSize: 12),
                        ),
                        Divider(),
                        Stack(
                          children: <Widget>[
                            Text(
                              "${DateTime.fromMillisecondsSinceEpoch(item.createAt).toZhString()}",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  InkWell(
                                    onTap: item.markStatus == 0
                                        ? () => {_onMarkClick(item)}
                                        : null,
                                    child: Text(
                                      item.markStatus == 0
                                          ? "存为常发货源"
                                          : "已存为常发货源",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: item.markStatus == 0
                                              ? Colors.black87
                                              : Colors.grey),
                                    ),
                                  ),
                                  SizedBox(width: 32),
                                  InkWell(
                                    onTap: () => {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return DeliverPage(
                                          record: item,
                                        );
                                      }))
                                    },
                                    child: Text(
                                      "再发一单",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
          );
        },
        itemCount: _items.length,
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return DropDownMenu(
      // controller用于控制menu的显示或隐藏
      controller: _dropdownMenuController,
      // 下拉菜单显示或隐藏动画时长
      animationMilliseconds: 300,
      menus: <DropdownMenuBuilder>[
        DropdownMenuBuilder(
            dropDownHeight: 1, dropDownWidget: Container(), isAnimation: false),
        DropdownMenuBuilder(
            dropDownHeight: 1, dropDownWidget: Container(), isAnimation: false),
        DropdownMenuBuilder(
            dropDownHeight: _customDates.length * 48.0,
            dropDownWidget: ListView(
              children: _buildTiles(),
              itemExtent: 48,
            )),
      ],
    );
  }

  Widget _buildBody() {
    if (_dropdownMenuController.isShow &&
        _selectedIndex != null &&
        _selectedIndex != 2) {
      if (_selectedIndex == 0) {
        return InkWell(
          key: Key("load"),
          onTap: () => {_hideMenu()},
          child: Container(
            color: Colors.grey,
            child: CitySelector(
              province: _loadProvince,
              city: _loadCity,
              district: _loadDistrict,
              onChanged: (province, city, district) {
                setState(() {
                  _loadProvince = province;
                  _loadCity = city;
                  _loadDistrict = district;
                  _onRefresh();
                });
                _hideMenu();
              },
            ),
          ),
        );
      } else {
        return InkWell(
          key: Key("unload"),
          onTap: () => {_hideMenu()},
          child: Container(
            color: Colors.grey,
            child: CitySelector(
              province: _unloadProvince,
              city: _unloadCity,
              district: _unloadDistrict,
              onChanged: (province, city, district) {
                setState(() {
                  _unloadProvince = province;
                  _unloadCity = city;
                  _unloadDistrict = district;
                  _onRefresh();
                });
                _hideMenu();
              },
            ),
          ),
        );
      }
    } else {
      if (_items.length == 0) {
        return _buildEmpty(context);
      } else {
        return _buildList(context);
      }
    }
  }

  _hideMenu() {
    this.setState(() {
      this._selectedIndex = null;
      this._dropdownMenuController.hide();
    });
  }

  @override
  bool get wantKeepAlive => true;

  List<Widget> _buildTiles() {
    List<ListTile> tiles = [];
    for (var i = 0; i < _customDates.length; i++) {
      var element = _customDates[i];
      tiles.add(ListTile(
        title: Text(element.title),
        selected: _dateSelectedIndex == i,
        onTap: () => {_dateSelectedIndex = i, _hideMenu(), _onRefresh()},
      ));
    }
    return ListTile.divideTiles(context: context, tiles: tiles).toList();
  }

  _onMarkClick(DeliverGoodsRecord item) {
    HttpManager.getInstance().put("/api/v1/deliver/goods/${item.id}/markStatus",
        params: {"markStatus": 1}).then((value) {
      item.markStatus = 1;
      Toast.show("保存成功");
      eventBus.fire(DeliveryMarkedEvent(item));
      setState(() {});
    });
  }

  @override
  void dispose() {
    _deleteListen.cancel();
    super.dispose();
  }
}

class _CustomDate {
  String title;
  int startAt;
  int endAt;

  _CustomDate(this.title, this.startAt, this.endAt);
}
