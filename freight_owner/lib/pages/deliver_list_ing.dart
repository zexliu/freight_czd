import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/event/events.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/deliver_goods_entity.dart';
import 'package:freightowner/pages/assign_driver.dart';
import 'package:freightowner/pages/authentication_page.dart';
import 'package:freightowner/pages/authentication_page2.dart';
import 'package:freightowner/pages/deliver_page.dart';
import 'package:freightowner/pages/empty_page.dart';
import 'package:freightowner/global.dart';
import 'package:freightowner/utils/area_utils.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:freightowner/utils/date_extension.dart';

import 'deliver_details.dart';

class DeliverListIng extends StatefulWidget {
  @override
  _DeliverListIngState createState() => _DeliverListIngState();
}

class _DeliverListIngState extends State<DeliverListIng>
    with AutomaticKeepAliveClientMixin {
  List<DeliverGoodsRecord> _items = [];

//  List<String> items = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  StreamSubscription<DeliveryPublishedEvent> _listen;
  StreamSubscription<DeliveryOrderedEvent> _orderedListen;

  bool _enablePullUp = false;

  @override
  void initState() {
    super.initState();
    this._onRefresh();
    _listen = eventBus.on<DeliveryPublishedEvent>().listen((event) {
      print("刷新数据");
      this._onRefresh();
    });
    _orderedListen = eventBus.on<DeliveryOrderedEvent>().listen((event) {
      print("刷新数据");
      this._onRefresh();
    });
  }

  int driverCount = 0;
  bool isFirstIn = true;

  int _current = 1;

  int _size = 10;

  void _onRefresh() {
    // monitor network fetch
    _refreshController.resetNoData();
    _current = 1;
    HttpManager.getInstance().get("/api/v1/deliver/goods/self", params: {
      "status": 1,
      "current": _current,
      "size": _size,
      "order":"time",
    }).then((value) {
      _refreshController.refreshCompleted();
      _items.clear();
      _items = DeliverGoodsEntity().fromJson(value).records;
      _enablePullUp = _items.length == _size;
      if (mounted) setState(() {});
    }).catchError((e) => {_refreshController.refreshFailed()});
    // if failed,use refreshFailed()
  }

  void _onLoading() {
    // monitor network fetch
    _current++;
    HttpManager.getInstance().get("/api/v1/deliver/goods/self", params: {
      "status": 1,
      "current": _current,
      "size": _size,
      "order":"time",
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
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _items.length == 0 ? _buildEmpty(context) : _buildList(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _items.length == 0
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return DeliverPage();
                }));
              },
              child: Text(
                "发货",
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    if (isFirstIn) {
      isFirstIn = false;
      HttpManager.getInstance()
          .get("/api/v1/users/count", params: {"roleCode":"DRIVER"}).then((value) {
        setState(() {
          this.driverCount = value;
        });
      });
    }

    return EmptyPage(
      image: "images/truck.png",
      children: <Widget>[
        SizedBox(
          height: 16,
        ),
        Text("您周围有"),
        SizedBox(
          height: 8,
        ),
        Text(
          driverCount.toString(),
          style: TextStyle(fontSize: 24, color: Theme.of(context).primaryColor),
        ),
        SizedBox(
          height: 8,
        ),
        Text("司机等您发货"),
        SizedBox(
          height: 32,
        ),
        MaterialButton(
          onPressed: () => {
            if (Global.isAuthenticated())
              {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return DeliverPage();
                }))
              }
            else
              {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AuthenticationPage2();
                }))
              }
          },
          child: Text(
            "前去发货",
            style: Theme.of(context).textTheme.button,
          ),
          color: Theme.of(context).primaryColor,
          minWidth: double.infinity,
        )
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
                  return DeliverDetailsPage(item.id, true);
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
                                  fontSize: 16, fontWeight: FontWeight.w700),
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
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
// todo 微信
//                      Positioned(
//                        right: 0,
//                        child: GestureDetector(
//                          child: Image.asset(
//                            "images/wechat.png",
//                            width: 22,
//                            height: 22,
//                            fit: BoxFit.fitWidth,
//                          ),
//                          onTap: () => {print("点击微信")},
//                        ),
//                      )
                      ],
                    ),
                    Text(
                      "发布时间: ${DateTime.fromMillisecondsSinceEpoch(item.createAt).toZhString()}",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
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
                        RichText(
                          text: TextSpan(
                              text: "${item.lookCount}",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).primaryColor),
                              children: [
                                TextSpan(
                                  text: "人已查看  ",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                                //todo 已联系
                                TextSpan(
                                    text: "${item.callCount}",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Theme.of(context).primaryColor)),
                                TextSpan(
                                  text: "人已联系",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ]),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              InkWell(
                                onTap: () => {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (c) {
                                    return AssignDriver({
                                      "deliveryId": item.id,
                                      "loadProvinceCode": item.loadProvinceCode,
                                      "loadCityCode": item.loadCityCode,
                                      "loadDistrictCode": item.loadDistrictCode,
                                      "unloadProvinceCode":
                                          item.unloadProvinceCode,
                                      "unloadCityCode": item.unloadCityCode,
                                      "unloadDistrictCode":
                                          item.unloadDistrictCode,
                                      "carLongs": item.carLongs.split(","),
                                      "carModels": item.carModels.split(","),
                                      "weight": item.weight,
                                      "volume": item.volume,
                                    }, 2);
                                  }))
                                },
                                child: Text(
                                  "指定司机",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 8),
                              InkWell(
                                onTap: () => {_onDeleteClick(item)},
                                child: Text(
                                  "删除货源",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
                              SizedBox(width: 8),
                              InkWell(
                                onTap: () => {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return DeliverPage(
                                      record: item,
                                      isEdit: true,
                                    );
                                  }))
                                },
                                child: Text(
                                  "编辑",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              SizedBox(width: 8),
//todo 微信

//                            GestureDetector(
//                              onTap: () => {print("发到微信点击")},
//                              child: Text(
//                                "发到微信",
//                                style: TextStyle(
//                                    fontSize: 12,
//                                    color: Theme.of(context).primaryColor),
//                              ),
//                            )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )),
          );
        },
        itemCount: _items.length,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _listen.cancel();
    _orderedListen.cancel();
  }

  @override
  bool get wantKeepAlive => true;

  _onDeleteClick(DeliverGoodsRecord record) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return new CupertinoAlertDialog(
            title: new Text("提示"),
            content: new Text("确定要删除该记录吗?"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  HttpManager.getInstance()
                      .delete("/api/v1/deliver/goods/${record.id}")
                      .then((value) => {
                            Toast.show("删除成功"),
                            this._onRefresh(),
                            eventBus.fire(DeliveryDeletedEvent(record)),
                            Navigator.of(context).pop()
                          });
                },
                child: new Text(
                  "确认",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("取消"),
              ),
            ],
          );
        });
  }
}
