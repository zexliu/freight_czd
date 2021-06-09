import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/event/events.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/deliver_goods_entity.dart';
import 'package:freightowner/pages/empty_page.dart';
import 'package:freightowner/utils/area_utils.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'deliver_page.dart';

class DeliverListMark extends StatefulWidget {
  @override
  _DeliverListMarkState createState() => _DeliverListMarkState();
}

class _DeliverListMarkState extends State<DeliverListMark> with  AutomaticKeepAliveClientMixin{
  StreamSubscription<DeliveryMarkedEvent> _listen;
  List<DeliverGoodsRecord> _items = [];

  int _current = 1;

  int _size = 10;

  bool _enablePullUp = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _listen = eventBus.on<DeliveryMarkedEvent>().listen((event) {
      setState(() {
        _items.insert(0, event.record);
      });
    }); 
    super.initState();
    this._onRefresh();
  }
  void _onRefresh() async {
    _refreshController.resetNoData();
    _current = 1;
    HttpManager.getInstance().get("/api/v1/deliver/goods/self", params: {
      "markStatus": 1,
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
  }

  void _onLoading() async {
    _current++;
    HttpManager.getInstance().get("/api/v1/deliver/goods/self", params: {
      "markStatus": 1,
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
    return _items.length == 0 ? _buildEmpty(context) : _buildList(context);
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
        itemBuilder: (c, i){
          var item = _items[i];
          return Padding(
            padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
            child: Card(
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
                        ],
                      ),
                      SizedBox(height: 6,),
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                InkWell(
                                  onTap: () => {
                                    _onDeleteClick(item)
                                  },
                                  child: Text(
                                    "删除",
                                    style: TextStyle(fontSize: 12,),
                                  ),
                                ),
                                SizedBox(width: 32),
                                InkWell(
                                  onTap: () => {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(builder: (context) {
                                      return DeliverPage(record: item,);
                                    }))
                                  },
                                  child: Text(
                                    "再发一单",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).primaryColor),
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
          );
        },
        itemCount: _items.length,
      ),
    );
  }
  
  @override
  void dispose() {
    _listen.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  _onDeleteClick(DeliverGoodsRecord item) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return new CupertinoAlertDialog(
            title: new Text("提示"),
            content: new Text("确定要删除该记录吗?"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  HttpManager.getInstance().put("/api/v1/deliver/goods/${item.id}/markStatus",
                      params: {"markStatus": 0}).then((value) {
                    Toast.show("删除成功");
                    _onRefresh();
                    Navigator.of(context).pop();
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
                  Navigator.of(context).pop();
                },
                child: new Text("取消"),
              ),
            ],
          );
        });
    
  }
}
