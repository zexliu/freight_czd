import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/area_entity.dart';
import 'package:flutterdriver/model/often_line_entity.dart';
import 'package:flutterdriver/pages/area_picker_page.dart';
import 'package:flutterdriver/utils/Toast.dart';

import '../global.dart';
import 'car_picker.dart';

class OftenLinePicker extends StatefulWidget {
  final Function onSuccess;
  final bool isAdd;
  final OftenLineRecord record;

  OftenLinePicker(this.isAdd, this.record, this.onSuccess);

  @override
  _OpftenLinePickerState createState() => _OpftenLinePickerState();
}

class _OpftenLinePickerState extends State<OftenLinePicker> {
  List<AreaEntity> _loadPlaces = [];
  List<AreaEntity> _unloadPlaces = [];
  List<String> _carLongs = [];
  List<String> _carModels = [];

  @override
  void initState() {
    if (widget.record != null) {
      _loadPlaces = widget.record.loadAreas.split(",").map((e) => _findArea(e)).toList();
      _unloadPlaces =
          widget.record.unloadAreas.split(",").map((e) => _findArea(e)).toList();
      _carModels = widget.record.carModels.split(",");
      _carLongs = widget.record.carLongs.split(",");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "添加常用路线",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                "新货源第一时间通知",
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.all(0),
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "请选择装货地",
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "最多3个",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: _buildSelectedRow(_loadPlaces, true),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.all(0),
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "请选择卸货地",
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "最多3个",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: _buildSelectedRow(_unloadPlaces, false),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.all(0),
            child: InkWell(
              onTap: () {
                print("on tap");
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return SafeArea(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: CarPicker(
                            isShowPlaceCarLong: false,
                            isShowCarType: false,
                            carLongs: _carLongs,
                            carModels: _carModels,
                            onChanged: (carType, carLongs,
                                placeCarLong, carModels) {
                              setState(() {
                                this._carLongs = carLongs;
                                this._carModels = carModels;
                              });
                            },
                          ),
                        ),
                      );
                    });
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Stack(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                    ),
                    (_carLongs.length == 0 && _carModels.length == 0)
                        ? Text(
                            "需要的车长车型(选填)",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        : _buildLongTypeText(_carLongs, _carModels),
                    Positioned(
                      right: 0,
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 22,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            color: Theme.of(context).primaryColor,
            minWidth: double.infinity,
            onPressed: () {
              if(_loadPlaces.isEmpty){
                Toast.show("请选择装货地");
                return;
              }
              if(_unloadPlaces.isEmpty){
                Toast.show("请选择卸货地");
                return;
              }
              if (widget.isAdd) {
                HttpManager.getInstance().post("/api/v1/often/lines", data: {
                  "loadAreas": _loadPlaces.map((e) => e.value).join(","),
                  "unloadAreas": _unloadPlaces.map((e) => e.value).join(","),
                  "carLongs": _carLongs.join(","),
                  "carModels": _carModels.join(","),
                }).then((value) {
                  Toast.show("添加成功");
                  if(widget.onSuccess != null){
                    widget.onSuccess(OftenLineRecord().fromJson(value));
                  }
                }).catchError((e) {
                  Toast.show("添加失败");
                });
              } else {
                HttpManager.getInstance()
                    .put("/api/v1/often/lines/${widget.record.id}", data: {
                  "loadAreas": _loadPlaces.map((e) => e.value).join(","),
                  "unloadAreas": _unloadPlaces.map((e) => e.value).join(","),
                  "carLongs": _carLongs.join(","),
                  "carModels": _carModels.join(","),
                }).then((value) {
                  Toast.show("编辑成功");
                  if(widget.onSuccess != null){
                    widget.onSuccess(OftenLineRecord().fromJson(value));
                  }
                }).catchError(() {
                  Toast.show("添加失败");
                });
              }
            },
            child: Text(
              "确定",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 10,
          ),
//            Card(
//              margin: EdgeInsets.all(0),
//              child: Padding(
//                padding: EdgeInsets.all(16),
//                child: Column(
//                  children: <Widget>[
//                    Row(
//                      children: <Widget>[
//                        Image.asset("images/recommended.png"),
//                        SizedBox(
//                          width: 4,
//                        ),
//                        Text(
//                          "为您推荐",
//                          style: TextStyle(
//                              color: Theme.of(context).primaryColor,
//                              fontSize: 12,
//                              fontWeight: FontWeight.bold),
//                        )
//                      ],
//                    ),
//                    SizedBox(
//                      height: 8,
//                    ),
//                    ListView.builder(
//                      physics: NeverScrollableScrollPhysics(),
//                      itemBuilder: (context, index) {
//                        return _buildRecommendItem(context, index);
//                      },
//                      itemCount: recommends.length,
//                      shrinkWrap: true,
//                    )
//                  ],
//                ),
//              ),
//            )
        ],
      ),
    );
  }

  _buildSelectedRow(List<AreaEntity> places, bool isLoad) {
    List<Widget> widgets = [];
    for (var i = 0; i < places.length; i++) {
      widgets.add(
        InkWell(
            onTap: () => {
                  this.setState(() {
                    places.removeAt(i);
                  })
                },
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 1),
                    color: Theme.of(context).primaryColor.withAlpha(8)),
                padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Row(
                  children: <Widget>[
                    Text(
                      places[i].label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.remove,
                      size: 12,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ))),
      );

      widgets.add(SizedBox(
        width: 8,
      ));
    }

    if (places.length < 3) {
      widgets.add(
        InkWell(
            onTap: () async {
              var result = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return AreaPickerPage(isLoad ? "装货地" : "卸货地",
                    isLoad ? _loadPlaces : _unloadPlaces);
              }));
              if (result != null) {
                setState(() {
                  if (isLoad) {
                    _loadPlaces = result;
                  } else {
                    _unloadPlaces = result;
                  }
                });
              }
            },
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Colors.transparent),
                padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Row(
                  children: <Widget>[
                    Text(
                      "选择",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.add,
                      size: 12,
                      color: Colors.grey,
                    )
                  ],
                ))),
      );
    }
    return widgets;
  }

  _buildLongTypeText(List<String> carLong, List<String> carType) {
    String text = "";
    if (carLong.length > 0) {
      for (var i = 0; i < carLong.length; i++) {
        text = text + carLong[i];
        if (i != carLong.length - 1) {
          text = text + "/";
        }
      }
    }

    if (carType.length > 0) {
      if (carLong.length > 0) {
        text = text + " ";
      }
      for (var i = 0; i < carType.length; i++) {
        text = text + carType[i];
        if (i != carType.length - 1) {
          text = text + "/";
        }
      }
    }

    return Text(text,
        style: TextStyle(
          fontSize: 12,
        ));
  }
  //
  // Widget _buildRecommendItem(BuildContext context, int index) {
  //   return Column(
  //     children: <Widget>[
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Row(
  //             children: <Widget>[
  //               Text("绵阳"),
  //               Image.asset("images/arrow_right_alt.png"),
  //               Text("绵阳"),
  //             ],
  //           ),
  //           GestureDetector(
  //               onTap: () => {
  //                     this.setState(() {
  //                       print("订阅$index");
  //                     })
  //                   },
  //               child: Container(
  //                   decoration: BoxDecoration(
  //                       border: Border.all(
  //                           color: Theme.of(context).primaryColor, width: 1),
  //                       color: Theme.of(context).primaryColor.withAlpha(8)),
  //                   padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
  //                   child: Text(
  //                     "订阅",
  //                     style: TextStyle(
  //                       fontSize: 12,
  //                       color: Theme.of(context).primaryColor,
  //                     ),
  //                   ))),
  //         ],
  //       ),
  //       index == _recommends.length - 1 ? SizedBox() : Divider()
  //     ],
  //   );
  // }

  AreaEntity _findArea(String e) {
    return _recursiveAddress(Global.areas, e);
  }

  AreaEntity _recursiveAddress(List<AreaEntity> areas, String code) {
    print(code);
    print(areas.length);
    for (int i = 0; i < areas.length; i++) {
      var element = areas[i];
      if (element.value == code) {
        return element;
      }
      if (element.children != null && element.children.isNotEmpty) {
        AreaEntity result = _recursiveAddress(element.children, code);
        if (result != null) {
          return result;
        }
      }
    }
    return null;
  }


}
