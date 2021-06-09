import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterdriver/http/common.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/area_entity.dart';
import 'package:flutterdriver/model/category_entity.dart';
import 'package:flutterdriver/model/deliver_goods_entity.dart';
import 'package:flutterdriver/model/dict_entry_entity.dart';
import 'package:flutterdriver/pages/deliver_details.dart';
import 'package:flutterdriver/utils/area_utils.dart';
import 'package:flutterdriver/utils/phone_utils.dart';
import 'package:flutterdriver/widget/city_selector.dart';
import 'package:flutterdriver/widget/dropdown_header.dart';
import 'package:flutterdriver/widget/dropdown_menu.dart';
import 'package:flutterdriver/widget/dropdown_menu_controller.dart';
import 'package:flutterdriver/widget/select_button.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'empty_page.dart';
import 'package:flutterdriver/utils/date_extension.dart';

class HomeTodayPage extends StatefulWidget {
  @override
  _HomeTodayPageState createState() => _HomeTodayPageState();
}

class _HomeTodayPageState extends State<HomeTodayPage> {
  GlobalKey _stackKey = GlobalKey();
  DropdownMenuController _dropdownMenuController = DropdownMenuController();
  List<String> _dropDownHeaderItemStrings = ['出发地', '目的地', '智能排序', "筛选"];
  var _sortSelectedIndex = 0;
  List<CustomDate> _customDates = [];
  var _selectedIndex;
  List<DeliverGoodsRecord> _items = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  AreaEntity _loadProvince;
  AreaEntity _loadCity;
  AreaEntity _loadDistrict;

  AreaEntity _unloadProvince;
  AreaEntity _unloadCity;
  AreaEntity _unloadDistrict;

  List<DictEntryRecord> _carTypes = [];
  String _currentCarType;
  CustomDate _currentTime;
  List<CustomDate> _filterTimes = [];

  List<CustomDate> _currentWeight = [];
  List<CustomDate> _filterWeights = [];

  List<String> _currentCarLongs = [];
  List<DictEntryRecord> _carLongs = [];
  List<String> _currentCategories = [];
  List<CategoryRecord> _categories = [];

  List<String> _currentCarModels = [];
  List<DictEntryRecord> _carModels = [];

  int _current = 1;
  int _size = 10;
  bool _enablePullUp = false;

  void _onRefresh() async {
    var now = DateTime.now();
    var startAt = DateTime(now.year,now.month,now.day,);
    var endAt = DateTime(now.year,now.month,now.day + 1);
    _refreshController.resetNoData();
    _current = 1;
    HttpManager.getInstance().get("/api/v1/deliver/goods", params: {
      "status": 1,
      "current": _current,
      "size": _size,
      "loadProvinceCode": _loadProvince == null ? null : _loadProvince.value,
      "loadCityCode": _loadCity == null ? null : _loadCity.value,
      "loadDistrictCode": _loadDistrict == null ? null : _loadDistrict.value,
      "unloadProvinceCode":
          _unloadProvince == null ? null : _unloadProvince.value,
      "unloadCityCode": _unloadCity == null ? null : _unloadCity.value,
      "unloadDistrictCode":
          _unloadDistrict == null ? null : _unloadDistrict.value,
      "order": _customDates[_sortSelectedIndex].value,
      "carType": _currentCarType,
      "loadStartAt": _currentTime != null ? _currentTime.startAt : null,
      "loadEndAt": _currentTime != null ? _currentTime.endAt : null,
      "startAt":startAt.millisecondsSinceEpoch ,
      "endAt":endAt.millisecondsSinceEpoch,
      "weights": _currentWeight.isEmpty
          ? null
          : _currentWeight.map((e) => "${e.startAt}-${e.endAt}").join(","),
      "carLongs": _currentCarLongs.isEmpty ? null : _currentCarLongs.join(","),
      "carModels":
          _currentCarModels.isEmpty ? null : _currentCarModels.join(","),
      "categoryName":
          _currentCategories.isEmpty ? null : _currentCategories.join(",")
    }).then((value) {
      _refreshController.refreshCompleted();
      _items.clear();
      _items = DeliverGoodsEntity().fromJson(value).records;
      _enablePullUp = _items.length == _size;
      if (mounted) setState(() {});
    }).catchError((e) => {_refreshController.refreshFailed()});
  }

  void _onLoading() async {
    var now = DateTime.now();
    var startAt = DateTime(now.year,now.month,now.day,);
    var endAt = DateTime(now.year,now.month,now.day + 1);
    // monitor network fetch
    _current++;
    HttpManager.getInstance().get("/api/v1/deliver/goods", params: {
      "status": 1,
      "current": _current,
      "size": _size,
      "loadProvinceCode": _loadProvince == null ? null : _loadProvince.value,
      "loadCityCode": _loadCity == null ? null : _loadCity.value,
      "loadDistrictCode": _loadDistrict == null ? null : _loadDistrict.value,
      "unloadProvinceCode":
          _unloadProvince == null ? null : _unloadProvince.value,
      "unloadCityCode": _unloadCity == null ? null : _unloadCity.value,
      "unloadDistrictCode":
          _unloadDistrict == null ? null : _unloadDistrict.value,
      "order": _customDates[_sortSelectedIndex].value,
      "carType": _currentCarType,
      "loadStartAt": _currentTime != null ? _currentTime.startAt : null,
      "loadEndAt": _currentTime != null ? _currentTime.endAt : null,
      "startAt":startAt.millisecondsSinceEpoch ,
      "endAt":endAt.millisecondsSinceEpoch,
      "weights": _currentWeight.isEmpty
          ? null
          : _currentWeight.map((e) => "${e.startAt}-${e.endAt}").join(","),
      "carLongs": _currentCarLongs.isEmpty ? null : _currentCarLongs.join(","),
      "carModels":
          _currentCarModels.isEmpty ? null : _currentCarModels.join(","),
      "categoryName":
          _currentCategories.isEmpty ? null : _currentCategories.join(",")
    }).then((value) {
      var values = DeliverGoodsEntity().fromJson(value).records;
      _items.addAll(values);
      if (values.length < 10) {
        _refreshController.loadNoData();
      } else {
        _refreshController.loadComplete();
      }
      if (mounted) setState(() {});
    }).catchError((e) => {_refreshController.loadFailed()});
  }

  @override
  void initState() {
    super.initState();
    _customDates.add(CustomDate(title: "时间排序", value: "time"));
    _customDates.add(CustomDate(title: "智能排序", value: "auto"));
    _filterTimes.add(CustomDate(
      title: "不限",
    ));
    var today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _filterTimes.add(CustomDate(
        title: "今天",
        startAt: today.millisecondsSinceEpoch.toString(),
        endAt: today.add(Duration(days: 1)).millisecondsSinceEpoch.toString()));
    _filterTimes.add(CustomDate(
        title: "明天",
        startAt: today.add(Duration(days: 1)).millisecondsSinceEpoch.toString(),
        endAt: today.add(Duration(days: 2)).millisecondsSinceEpoch.toString()));
    _filterTimes.add(CustomDate(
        title: "明天以后",
        startAt:
            today.add(Duration(days: 2)).millisecondsSinceEpoch.toString()));
//    _customDates.add(CustomDate("距离排序", "distance"));
    _currentTime = _filterTimes[0];

    _filterWeights.add(CustomDate(title: "0-5", startAt: "0", endAt: "5"));
    _filterWeights.add(CustomDate(title: "5-10", startAt: "5", endAt: "10"));
    _filterWeights.add(CustomDate(title: "10-20", startAt: "10", endAt: "20"));
    _filterWeights.add(CustomDate(title: "20-30", startAt: "20", endAt: "30"));
    _filterWeights.add(CustomDate(title: "30-40", startAt: "30", endAt: "40"));
    _filterWeights
        .add(CustomDate(title: "40以上", startAt: "40", endAt: "999999"));

    _onRefresh();
    Future.wait([
      fetchDict("car_type"),
      fetchDict("car_long"),
      fetchDict("car_model"),
      HttpManager.getInstance()
          .get("/api/v1/categories", params: {"isParent": false})
    ]).then((list) {
      _carTypes = list[0].records;
      _carLongs = list[1].records;
      _carModels = list[2].records;
      _categories = CategoryEntity().fromJson(list[3]).records;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 0,
              ),
              Text(
                "当天货源",
                style: TextStyle(color: Colors.white),
              ),
//              Positioned(
//                left: 0,
//                child: GestureDetector(
//                  onTap: () => {print("点击了找活记录")},
//                  child: Row(
//                    children: <Widget>[
//                      Text(
//                        "消息",
//                        style: TextStyle(color: Colors.white, fontSize: 14),
//                      ),
//                      SizedBox(
//                        width: 2,
//                      ),
//                      Badge(
//                        badgeColor: Colors.white,
//                        padding: EdgeInsets.all(1),
//                        toAnimate: false,
//                        elevation: 0,
//                        badgeContent: Text(' 1 ',
//                            style: TextStyle(
//                                color: Theme.of(context).primaryColor,
//                                fontSize: 12)),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//              Positioned(
//                right: 0,
//                child: Text(
//                  "找货记录",
//                  style: TextStyle(color: Colors.white, fontSize: 14),
//                ),
//              )
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: Stack(key: _stackKey, children: <Widget>[
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
                  DropDownHeaderItem(_sortSelectedIndex == null
                      ? _dropDownHeaderItemStrings[2]
                      : _customDates[_sortSelectedIndex].title),
                  DropDownHeaderItem(_dropDownHeaderItemStrings[3]),
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
        ]));
  }

  _buildBody() {
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
      } else if (_selectedIndex == 1) {
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
      } else {
        return buildFilter(context);
      }
    } else {
      return SmartRefresher(
          enablePullDown: true,
          enablePullUp: _enablePullUp,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child:
              _items.length == 0 ? _buildEmpty(context) : _buildList(context));
    }
  }

  _buildMenu(BuildContext context) {
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
        DropdownMenuBuilder(
            dropDownHeight: 1, dropDownWidget: Container(), isAnimation: false),
      ],
    );
  }

  List<Widget> _buildTiles() {
    List<ListTile> tiles = [];

    for (var i = 0; i < _customDates.length; i++) {
      var element = _customDates[i];
      tiles.add(ListTile(
        title: Text(element.title),
        selected: _sortSelectedIndex == i,
        onTap: () {
          _sortSelectedIndex = i;
          _hideMenu();
          _onRefresh();
        },
      ));
    }

    return ListTile.divideTiles(context: context, tiles: tiles).toList();
  }

  _hideMenu() {
    this.setState(() {
      this._selectedIndex = null;
      this._dropdownMenuController.hide();
    });
  }

  _buildEmpty(BuildContext context) {
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

  _buildList(BuildContext context) {
    return ListView.builder(
      itemBuilder: (c, i) {
        var item = _items[i];
        return Padding(
          padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                return DeliverDetailsPage(item.id, false);
              }));
            },
            child: Card(
                child: Row(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width - 80,
                  height: 138,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "${item.carLongs.replaceAll(",", "/")}(米) | ${item.carModels.replaceAll(",", "/")}${item.weight == null ? "" : ' | ${item.weight}(吨)${item.volume == null ? "" : ' | ${item.volume}(方)'}'}",
//                                  "${item.carType} ${item.carModels} ${item.carLongs}(米) ${item.categoryName}"
//                                      "${item.weight == null ? "" : ' ${item.weight}吨'}"
//                                      "${item.volume == null ? "" : ' ${item.volume}方'}"
//                                      .replaceAll(",", "/"),
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "${item.carType} ${item.categoryName}${item.expectMoney == null ? "" : ' ${item.expectMoney}/${item.expectUnit}'} ${_getTimeString(item.loadStartAt, item.loadEndAt)}",
                              maxLines: 1,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Divider(),
                            Row(
                              children: <Widget>[
                               Expanded(child:
                               Row(
                                 children: [
                                   CachedNetworkImage(
                                     imageUrl: item.avatar,
                                     placeholder: (context, url) =>
                                         Image.asset("images/default_avatar.png",fit: BoxFit.cover,
                                           width: 28,
                                           height: 28,),
                                     fit: BoxFit.cover,
                                     width: 28,
                                     height: 28,
                                   ),
                                   SizedBox(
                                     width: 8,
                                   ),
                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: <Widget>[
                                       Row(
                                         children: <Widget>[
                                           Text(
                                             item.nickname,
                                             style: TextStyle(fontSize: 12),
                                           ),
                                           SizedBox(
                                             width: 4,
                                           ),
//                                        Container(
//                                          color: Colors.amber.withAlpha(70),
//                                          child: Text(
//                                            "会员",
//                                            style: TextStyle(
//                                                fontSize: 10,
//                                                color: Colors.amber),
//                                          ),
//                                        )
                                         ],
                                       ),
                                       Text(
                                         item.commentCount == null ||
                                             item.commentCount < 3
                                             ? "评价少于3条"
                                             : "${item.commentCount}条评论",
                                         style: TextStyle(
                                             color: Colors.grey, fontSize: 10),
                                       ),

                                     ],
                                   )
                                 ],
                               )),
                                Column(
                                  children: <Widget>[
                                    SizedBox(height: 18,),
                                    Text("发布时间:  "+ DateTime.fromMillisecondsSinceEpoch(item.createAt).toZhHourString(), style: TextStyle(
                                        color: Colors.grey, fontSize: 10)),

                                  ],
                                )

                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    PhoneUtils.call(context,item.mobile, item.userId, item.id);
                  },
                  child: SizedBox(
                    width: 56,
                    height: 138,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 26, 0, 26),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Image.asset("images/phone_circle.png"),
                            Text(
                              "${item.callCount}人",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            Text(
                              "已联系",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
          ),
        );
      },
      itemCount: _items.length,
    );
  }

  buildFilter(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 44,
          top: 0,
          left: 0,
          right: 0,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: <Widget>[
              Container(
                height: 44,
                alignment: Alignment.centerLeft,
                child: Text("用车类型"),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemCount: _carTypes.length + 1,
                itemBuilder: (BuildContext context, int position) {
                  DictEntryRecord item;
                  if (position == 0) {
                    item = DictEntryRecord();
                    item.dictEntryName = "不限类型";
                  } else {
                    item = _carTypes[position - 1];
                  }

                  return SelectButton(
                    text: item.dictEntryName,
                    isSelected: position == 0
                        ? _currentCarType == null
                        : _currentCarType == item.dictEntryName,
                    onTap: () {
                      setState(() {
                        if (position == 0) {
                          _currentCarType = null;
                          return;
                        }
                        _currentCarType = item.dictEntryName;
                      });
                    },
                  );
                },
              ),
              Container(
                height: 44,
                alignment: Alignment.centerLeft,
                child: Text("装货时间"),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemCount: _filterTimes.length,
                itemBuilder: (BuildContext context, int position) {
                  CustomDate item = _filterTimes[position];
                  return SelectButton(
                    text: item.title,
                    isSelected: _currentTime == item,
                    onTap: () {
                      setState(() {
                        _currentTime = item;
                      });
                    },
                  );
                },
              ),
              Container(
                height: 44,
                alignment: Alignment.centerLeft,
                child: Text("重量范围(吨 , 可多选)"),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemCount: _filterWeights.length + 1,
                itemBuilder: (BuildContext context, int position) {
                  CustomDate item;
                  if (position == 0) {
                    item = CustomDate();
                    item.title = "不限";
                  } else {
                    item = _filterWeights[position - 1];
                  }

                  CustomDate find = _currentWeight.firstWhere((element) {
                    return element == item;
                  }, orElse: () {
                    return null;
                  });
                  return SelectButton(
                    text: item.title,
                    isSelected:
                        position == 0 ? _currentWeight.isEmpty : find != null,
                    onTap: () {
                      setState(() {
                        if (position == 0) {
                          _currentWeight.clear();
                          return;
                        }
                        if (find != null) {
                          _currentWeight.remove(find);
                        } else {
                          _currentWeight.add(item);
                        }
                      });
                    },
                  );
                },
              ),
              Container(
                height: 44,
                alignment: Alignment.centerLeft,
                child: Text("车长(可多选)"),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemCount: _carLongs.length + 1,
                itemBuilder: (BuildContext context, int position) {
                  DictEntryRecord item;
                  if (position == 0) {
                    item = DictEntryRecord();
                    item.dictEntryName = "不限";
                  } else {
                    item = _carLongs[position - 1];
                  }

                  String find = _currentCarLongs.firstWhere((element) {
                    return element == item.dictEntryName;
                  }, orElse: () {
                    return null;
                  });
                  return SelectButton(
                    text: item.dictEntryName,
                    isSelected:
                        position == 0 ? _currentCarLongs.isEmpty : find != null,
                    onTap: () {
                      setState(() {
                        if (position == 0) {
                          _currentCarLongs.clear();
                          return;
                        }
                        if (find != null) {
                          _currentCarLongs.remove(find);
                        } else {
                          _currentCarLongs.add(item.dictEntryName);
                        }
                      });
                    },
                  );
                },
              ),
              Container(
                height: 44,
                alignment: Alignment.centerLeft,
                child: Text("车型(可多选)"),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemCount: _carModels.length + 1,
                itemBuilder: (BuildContext context, int position) {
                  DictEntryRecord item;
                  if (position == 0) {
                    item = DictEntryRecord();
                    item.dictEntryName = "不限";
                  } else {
                    item = _carModels[position - 1];
                  }

                  String find = _currentCarModels.firstWhere((element) {
                    return element == item.dictEntryName;
                  }, orElse: () {
                    return null;
                  });
                  return SelectButton(
                    text: item.dictEntryName,
                    isSelected: position == 0
                        ? _currentCarModels.isEmpty
                        : find != null,
                    onTap: () {
                      setState(() {
                        if (position == 0) {
                          _currentCarModels.clear();
                          return;
                        }
                        if (find != null) {
                          _currentCarModels.remove(find);
                        } else {
                          _currentCarModels.add(item.dictEntryName);
                        }
                      });
                    },
                  );
                },
              ),
              Container(
                height: 44,
                alignment: Alignment.centerLeft,
                child: Text("货物类型(可多选)"),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemCount: _categories.length + 1,
                itemBuilder: (BuildContext context, int position) {
                  CategoryRecord item;
                  if (position == 0) {
                    item = CategoryRecord();
                    item.categoryName = "不限";
                  } else {
                    item = _categories[position - 1];
                  }

                  String find = _currentCategories.firstWhere((element) {
                    return element == item.categoryName;
                  }, orElse: () {
                    return null;
                  });
                  return SelectButton(
                    text: item.categoryName,
                    isSelected: position == 0
                        ? _currentCategories.isEmpty
                        : find != null,
                    onTap: () {
                      setState(() {
                        if (position == 0) {
                          _currentCategories.clear();
                          return;
                        }
                        if (find != null) {
                          _currentCategories.remove(find);
                        } else {
                          _currentCategories.add(item.categoryName);
                        }
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Row(
            children: <Widget>[
              MaterialButton(
                height: 44,
                minWidth: MediaQuery.of(context).size.width / 2,
                elevation: 0,
                onPressed: () {
                  _currentCategories = [];
                  _currentCarModels = [];
                  _currentCarLongs = [];
                  _currentWeight = [];
                  _currentTime = _filterTimes[0];
                  _currentCarType = null;
                  setState(() {});
                },
                child: Text("清空条件"),
              ),
              MaterialButton(
                height: 44,
                minWidth: MediaQuery.of(context).size.width / 2,
                onPressed: () {
                  _hideMenu();
                  _onRefresh();
                },
                elevation: 0,
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                child: Text("确定"),
              )
            ],
          ),
        )
      ],
    );
  }

  _getTimeString(int loadStartAt, int loadEndAt) {
    String day = "";
    String time = "";
    var format = DateFormat("yyyy-MM-dd");
    var loadAt = DateTime.fromMillisecondsSinceEpoch(loadStartAt);
    var endAt = DateTime.fromMillisecondsSinceEpoch(loadEndAt);
    DateTime now = DateTime.now();
    if (loadAt.year == now.year &&
        loadAt.month == now.month &&
        loadAt.day == now.day) {
      day = "今天";
      if (endAt.year == now.year &&
          endAt.month == now.month &&
          endAt.day == now.day + 1) {
        day = "今天或明天";
      }
    } else if (endAt.year == now.year &&
        endAt.month == now.month &&
        endAt.day == now.day + 1) {
      day = "明天";
    } else {
      day = format.format(loadAt);
    }
    if (loadAt.hour != 18 && endAt.hour == 23) {
      time = "全天";
    } else if (loadAt.hour == 0 && endAt.hour == 5) {
      time = "凌晨";
    } else if (loadAt.hour == 6 && endAt.hour == 11) {
      time = "上午";
    } else if (loadAt.hour == 12 && endAt.hour == 17) {
      time = "下午";
    } else {
      time = "晚上";
    }
    return "$day $time 装货";
  }
}

//
//Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//Stack(
//children: <Widget>[
//Row(
//children: <Widget>[
//Text(
//"廊坊 文安",
//style: TextStyle(
//fontSize: 16, fontWeight: FontWeight.w700),
//),
//Image.asset(
//"images/arrow_right_alt.png",
//width: 40,
//height: 28,
//),
//Text(
//"咸阳 牵线",
//style: TextStyle(
//fontSize: 16, fontWeight: FontWeight.w700),
//),
//],
//),
//Positioned(
//right: 0,
//child: Text(
//"已完成",
//style: TextStyle(color: Colors.grey),
//),
//)
//],
//),
//SizedBox(
//height: 6,
//),
//Text(
//"整车 13米 高栏/平板 33~100吨/袋装化工/￥95每吨",
//style: TextStyle(color: Colors.black87, fontSize: 12),
//),
//Divider(),
//Stack(
//children: <Widget>[
//Text("6-7 07:34",style:
//TextStyle(fontSize: 10, color: Colors.grey),),
//Align(
//alignment: Alignment.centerRight,
//child: Row(
//mainAxisSize: MainAxisSize.min,
//children: <Widget>[
//GestureDetector(
//onTap: () => {print("存为常发货源点击")},
//child: Text(
//"存为常发货源",
//style: TextStyle(
//fontSize: 12,),
//),
//),
//SizedBox(width: 32),
//GestureDetector(
//onTap: () => {print("再发一单点击")},
//child: Text(
//"再发一单",
//style: TextStyle(
//fontSize: 12,
//color: Theme.of(context).primaryColor),
//),
//)
//],
//),
//)
//],
//)
//],
//)
class CustomDate {
  String title;
  String value;
  String startAt;
  String endAt;

  CustomDate({this.title, this.value, this.startAt, this.endAt});
}
