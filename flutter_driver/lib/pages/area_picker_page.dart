import 'dart:convert';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdriver/global.dart';
import 'package:flutterdriver/model/area_entity.dart';
import 'package:flutterdriver/utils/Toast.dart';
import 'package:flutterdriver/utils/shared_preferences.dart';
import 'package:flutterdriver/widget/select_button.dart';
import 'package:permission_handler/permission_handler.dart';

class AreaPickerPage extends StatefulWidget {
  final String title;

  final List<AreaEntity> selectedAreas;
  AreaPickerPage(this.title, this.selectedAreas);

  @override
  _AreaPickerPageState createState() => _AreaPickerPageState();
}

class _AreaPickerPageState extends State<AreaPickerPage> {
  List<AreaEntity> _selectedAreas = [];

  List<AreaEntity> _historyAreas = [];

  AreaEntity _selectedProvince;

  AreaEntity _selectedCity;


  @override
  void initState() {
    super.initState();
    _historyAreas = _getHistoryAreas();
    this._selectedAreas = widget.selectedAreas;
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Stack(
            children: <Widget>[
              ListView(
                children: <Widget>[
                  Visibility(
                    visible: _selectedAreas.length != 0,
                    child: Container(
                      height: 48,
                      alignment: Alignment.centerLeft,
                      child: Text("已选区域"),
                    ),
                  ),
                  Visibility(
                      visible: _selectedAreas.length != 0,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _selectedAreas.length,
                        itemBuilder: (BuildContext context, int position) {
                          var item = _selectedAreas[position];
                          return SelectButton(
                            text: "${item.label}  ×",
                            isSelected: _isSelected(item.value),
                            onTap: () {
                              setState(() {
                                _selectedAreas.removeAt(position);
                              });
                            },
                          );
                        },
                      )),
                  Visibility(
                    visible: _historyAreas.length != 0,
                    child: Container(
                      height: 48,
                      alignment: Alignment.centerLeft,
                      child: Text("历史${widget.title}"),
                    ),
                  ),
                  Visibility(
                      visible: _historyAreas.length != 0,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _historyAreas.length <= 9
                            ? _historyAreas.length
                            : 9,
                        itemBuilder: (BuildContext context, int position) {
                          var item = _historyAreas[position];
                          return SelectButton(
                            text: "${item.label}",
                            isSelected: _isSelected(item.value),
                            onTap: () {
                              setState(() {
                                _onSelected(item);
                              });
                            },
                          );
                        },
                      )),
                  Container(
                    height: 48,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("选择${widget.title}"),
                        Visibility(
                          visible: _selectedProvince != null ||
                              _selectedCity != null,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (_selectedCity != null) {
                                  if (_selectedCity.value ==
                                      _selectedProvince.value) {
                                    _selectedProvince = null;
                                  }
                                  _selectedCity = null;
                                } else {
                                  _selectedProvince = null;
                                }
                              });
                            },
                            child: Text("返回上级",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14)),
                          ),
                        )
                      ],
                    ),
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
                    itemCount: _selectedCity != null
                        ? _selectedCity.children.length + 1
                        : _selectedProvince != null
                            ? _selectedProvince.children.length + 1
                            : Global.areas.length,
                    itemBuilder: (BuildContext context, int position) {
                      AreaEntity item;
                      if (_selectedProvince == null) {
                        item = Global.areas[position];
                      } else {
                        if (position == 0) {
                          item = AreaEntity();
                          if (_selectedCity != null) {
                            item.label = "全市";
                            item.value = _selectedCity.value;
                          } else {
                            item.label = "全省";
                            item.value = _selectedProvince.value;
                          }
                        } else {
                          if (_selectedCity != null) {
                            item = _selectedCity.children[position - 1];
                          } else {
                            item = _selectedProvince.children[position - 1];
                          }
                        }
                      }
                      return SelectButton(
                        text: "${item.label}",
                        isSelected: _isSelected(item.value),
                        onTap: () {
                          setState(() {
                            //省数据选择
                            if (_selectedProvince == null) {
                              _selectedProvince = item;
                              if (_selectedProvince.children[0].value ==
                                  _selectedProvince.value) {
                                _selectedCity = _selectedProvince.children[0];
                              }
                              return;
                            }
                            //区数据选择
                            if (_selectedCity != null) {
                              //选择全市
                              if (position == 0) {
                                // 删除包含的区数据 或 省数据
                                _selectedAreas.removeWhere((element) {
                                  return (element.value.substring(
                                                  0, element.value.length - 2) +
                                              "00" ==
                                          _selectedCity.value) ||
                                      (element.value ==
                                          _selectedCity.value.substring(
                                                  0, element.value.length - 4) +
                                              "0000");
                                });

                                _onSelected(_selectedCity);
                              } else {
                                //删除 包含的市数据 或 省数据
                                _selectedAreas.removeWhere((element) {
                                  return (element.value ==
                                          item.value.substring(
                                                  0, element.value.length - 2) +
                                              "00") ||
                                      (element.value ==
                                          item.value.substring(
                                                  0, element.value.length - 4) +
                                              "0000");
                                });
                                _onSelected(item);
                              }
                              return;
                            }
                            //市数据选择
                            if (_selectedProvince != null) {
                              if (position == 0) {
                                //选择全省 删除包含的市或区数据
                                _selectedAreas.removeWhere((element) {
                                  return element.value.substring(
                                              0, element.value.length - 4) +
                                          "0000" ==
                                      _selectedProvince.value;
                                });
                                _onSelected(_selectedProvince);
                              } else {
                                _selectedCity = item;
                              }
                            }
                          });
                        },
                      );
                    },
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                child: MaterialButton(
                  onPressed: () {
                    _onConfirm(_selectedAreas);
                  },
                  child: Text(
                    "确定",
                    style: TextStyle(color: Colors.white),
                  ),
                  minWidth: MediaQuery.of(context).size.width - 32,
                  height: 48,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  requestPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      var location = await AmapLocation.instance.fetchLocation();
      String code = location.adCode;
      code = code.substring(0, code.length - 2);
      code = code + "00";

      _recursiveHistory(Global.areas, code);
      setState(() {});
    } else {
      Toast.show("没有定位权限");
      return false;
    }

//    final permissions =
//    await PermissionHandler().requestPermissions([PermissionGroup.location]);
//
//    if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
//      return true;
//    } else {
//      toast('需要定位权限!');
//      return false;
//    }
  }

  void _onConfirm(List<AreaEntity> areaEntities) {
    if (areaEntities.length == 0) {
      Toast.show("请选择${widget.title}");
      return;
    }
    //保存到历史
    List<String> list = DefaultSharedPreferences.getInstance()
        .getList("HISTORY_${widget.title}");
    if (list == null) {
      list = [];
    }

    areaEntities.forEach((element) {
      var jsonStr = jsonEncode(element);
      list.removeWhere((element) {
        return element == jsonStr;
      });
      if (list.length == 9) {
        list.removeLast();
      }
      list.insert(0, jsonStr);
      DefaultSharedPreferences.getInstance()
          .setList("HISTORY_${widget.title}", list);
    });
    Navigator.of(context).pop(areaEntities);
  }

  List<AreaEntity> _getHistoryAreas() {
    List<String> list = DefaultSharedPreferences.getInstance()
        .getList("HISTORY_${widget.title}");
    if (list == null) {
      return [];
    }
    List<AreaEntity> temps = [];
    list.forEach((element) {
      var json = jsonDecode(element);
      var entity = AreaEntity().fromJson(json);
      temps.add(entity);
    });
    return temps;
  }

  void _recursiveHistory(List<AreaEntity> areas, String code) {
    if (_historyAreas.isNotEmpty && _historyAreas[0].value == code) {
      return;
    }
    areas.forEach((element) {
      if (element.value == code) {
        _historyAreas.removeWhere((item) => item.value == code);
        _historyAreas.insert(0, element);
        return;
      }
      if (element.children != null && element.children.isNotEmpty) {
        _recursiveHistory(element.children, code);
      }
    });
  }

  bool _isSelected(String value) {
    var isSelected = false;
    if (_selectedAreas.isEmpty) {
      return isSelected;
    }

    _selectedAreas.forEach((element) {
      if (element.value == value) {
        isSelected = true;
      }
    });
    return isSelected;
  }

  void _onSelected(AreaEntity item) {
    if (_isSelected(item.value)) {
      _selectedAreas.removeWhere((element) => element.value == item.value);
      return;
    }
    if (_selectedAreas.length < 3) {
      _selectedAreas.add(item);
    } else {
      Toast.show("最多选择3个");
    }
  }
}
