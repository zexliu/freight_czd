import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//import 'package:flutter_badge/flutter_badge.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/area_entity.dart';
import 'package:flutterdriver/model/often_line_entity.dart';
import 'package:flutterdriver/pages/home_hall_list_page.dart';
import 'package:flutterdriver/widget/often_line_picker.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';
import 'package:web_socket_channel/io.dart';

import '../global.dart';
import 'often_line_page.dart';

class HomeHallPage extends StatefulWidget {
  @override
  _HomeHallPageState createState() => _HomeHallPageState();
}

class _HomeHallPageState extends State<HomeHallPage> {
  bool _isIng = false;
  Future<OftenLineEntity> _fetchLinesFuture;
  IOWebSocketChannel channel;
  Map<int,int> _countMap = Map();

  @override
  void initState() {
    _fetchLinesFuture = _fetchLines();
    super.initState();
  }

  Future<OftenLineEntity> _fetchLines() async {
    var result = await HttpManager.getInstance().get("/api/v1/often/lines");
    return OftenLineEntity().fromJson(result);
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
              "配货大厅",
              style: TextStyle(color: Colors.white),
            ),
            Positioned(
              left: 0,
              child: GestureDetector(
                onTap: () => {print("点击了找活记录")},
                child: Row(
                  children: <Widget>[
//                    Text(
//                      "消息",
//                      style: TextStyle(color: Colors.white, fontSize: 14),
//                    ),
//                    SizedBox(
//                      width: 2,
//                    ),
//                    Badge(
//                      badgeColor: Colors.white,
//                      padding: EdgeInsets.all(1),
//                      toAnimate: false,
//                      elevation: 0,
//                      badgeContent: Text(' 1 ',
//                          style: TextStyle(
//                              color: Theme.of(context).primaryColor,
//                              fontSize: 12)),
//                    ),
                  ],
                ),
              ),
            ),
//            Positioned(
//              right: 0,
//              child: Text(
//                "找货记录",
//                style: TextStyle(color: Colors.white, fontSize: 14),
//              ),
//            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: _fetchLinesFuture,
        builder:
            (BuildContext context, AsyncSnapshot<OftenLineEntity> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // 请求失败，显示错误
              return Text("Error: ${snapshot.error}");
            } else {
              if (snapshot.data.records.length == 0) {
                return OftenLinePicker(true, null, (v) {
                  setState(() {
                    _fetchLinesFuture = _fetchLines();
                  });
                });
              } else {
                return _buildBroadcast(snapshot.data);
              }
            }
          } else {
            // 请求未结束，显示loading
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildBroadcast(OftenLineEntity data) {
    return Column(
      children: <Widget>[
        _isIng ? _buildIng() : _buildNormal(),
        Container(
          height: 8,
          color: Colors.grey.shade200,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text("我的线路 ${data.records.length}/10"),
          alignment: Alignment.centerLeft,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: data.records.length < 10
                  ? data.records.length + 1
                  : data.records.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (index == data.records.length) {
                  return Padding(
                    child: MaterialButton(
                      height: 48,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor,
                              style: BorderStyle.solid,
                              width: 1)),
                      onPressed: () async {
                        var result = await Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return OftenLinePage(true, null);
                        }));
                        if (result != null) {
                          setState(() {
                            data.records.add(result);
                          });
                          print(result);
                        }
                      },
                      child: Text(
                        "添加常用路线",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                  );
                } else {
                  var item = data.records[index];
                  return InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (c){
                        return HomeHallListPage(item: item,);
                      }));
                    },
                    child:  Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.2,
                      child: Container(
                        color: Colors.white,
                        child: ListTile(
//                leading: Icon(Icons.surround_sound),
                          title: Text(
                            "${_getAddress(item.loadAreas)} → ${_getAddress(item.unloadAreas)}",
                            style: TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            "${item.carLongs.replaceAll(",", "/")} ${item.carModels.replaceAll(",", "/")}",
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: Badge(
                            badgeColor: Colors.red,
                            shape: BadgeShape.square,
                            elevation: 2,
                            borderRadius: BorderRadius.circular(20),
                            toAnimate: false,
                            showBadge: _countMap.containsKey(item.id),
                            padding: EdgeInsets.all(6),
                            badgeContent: Text(' ${_countMap[item.id]} ',
                                style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: '编辑',
                          color: Colors.grey.shade200,
                          icon: Icons.edit,
                          onTap: () async {
                            var result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return OftenLinePage(false, item);
                                    }));
                            if (result != null) {
                              setState(() {
                                data.records[index] = result;
                              });
                            }
                          },
                        ),
                        IconSlideAction(
                          caption: '删除',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => {
                            HttpManager.getInstance()
                                .delete("/api/v1/often/lines/${item.id}")
                                .then((value) {
                              setState(() {
                                data.records.removeAt(index);
                              });
                            })
                          },
                        ),
                      ],
                    ),
                  );
                }
              }),
        )
      ],
    );
  }

  _buildIng() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 48,
                width: 48,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                      style: BorderStyle.solid),
                ),
                child: Loading(
                    indicator: LineScalePulseOutIndicator(),
                    color: Theme.of(context).primaryColor),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "播报中",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "持续为您推送新货源,抢手货源不错过",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          MaterialButton(
            onPressed: () {
              setState(() {
                if (channel != null) {
                  channel.sink.close();
                  channel = null;
                }
                _isIng = false;
              });
            },
            child: Text(
              "关闭播报",
              style: TextStyle(color: Colors.black87),
            ),
            color: Colors.grey.shade300,
            minWidth: double.infinity,
          ),
        ],
      ),
    );
  }

  _buildNormal() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                'images/logo.png',
                width: 48,
                height: 48,
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "新闻播报",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "打开播报,新货急速抢单,抢手货源不错过",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          MaterialButton(
            onPressed: () {
              channel = IOWebSocketChannel.connect(
                  "${HttpManagerConfig.wsBaseUrl}/ws/v1/lines/${Global.userEntity.id}");
              channel.sink.add("connect");
              channel.stream.listen((event) {
                setState(() {
                  if (event == "connected") {
                    _isIng = true;
                    return;
                  }
                  var json = jsonDecode(event);
                  if(json['type'] == 1){
                    if(_countMap.containsKey(json['onlineId'] as int)){
                      _countMap[json['onlineId']as int] =  _countMap[json['onlineId']] + 1;
                    }else{
                      _countMap[json['onlineId']as int] = 1;
                    }
                  }
                  print(event);
                });
              });
            },
            child: Text(
              "开始播报",
              style: TextStyle(color: Colors.white),
            ),
            color: Theme.of(context).primaryColor,
            minWidth: double.infinity,
          ),
        ],
      ),
    );
  }

  String _getAddress(String areas) {
    return areas
        .split(",")
        .map((e) => _recursiveAddress(Global.areas, e))
        .join("/");
  }

  String _recursiveAddress(List<AreaEntity> areas, String code) {
    for (int i = 0; i < areas.length; i++) {
      var element = areas[i];
      if (element.value == code) {
        return element.label;
      }
      if (element.children != null && element.children.isNotEmpty) {
        String result = _recursiveAddress(element.children, code);
        if (result.isNotEmpty) {
          return result;
        }
      }
    }
    return "";
  }

  @override
  void dispose() {
    super.dispose();
    if (channel != null) {
      channel.sink.close();
    }
  }

//OftenLinePicker()
}

//
