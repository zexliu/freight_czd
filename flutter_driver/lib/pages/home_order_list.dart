import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/delivery_details_entity.dart';
import 'package:flutterdriver/model/order_entity.dart';
import 'package:flutterdriver/pages/protocal_page.dart';
import 'package:flutterdriver/utils/area_utils.dart';
import 'package:flutterdriver/utils/phone_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'PrePayPage.dart';
import 'empty_page.dart';
import 'evaluation_submit_page.dart';
import 'order_cancel_page.dart';
import 'order_details.dart';
import 'package:flutterdriver/utils/date_extension.dart';
class HomeOrderList extends StatefulWidget {
  final Map<String, dynamic> params;

  HomeOrderList(this.params);

  @override
  _HomeOrderListState createState() => _HomeOrderListState();
}

class _HomeOrderListState extends State<HomeOrderList>
    with AutomaticKeepAliveClientMixin {
  List<OrderRecord> _items = [];
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  bool _enablePullUp = false;

  int _current = 1;

  int _size = 10;

  @override
  void initState() {
    super.initState();
    this._onRefresh();
  }

  void _onRefresh() async {
    // monitor network fetch
    _refreshController.resetNoData();
    _current = 1;
    widget.params["current"] = _current;
    widget.params["size"] = _size;
    HttpManager.getInstance()
        .get("/api/v1/orders", params: widget.params)
        .then((value) {
      _refreshController.refreshCompleted();
      _items.clear();
      _items = OrderEntity().fromJson(value).records;
      _enablePullUp = _items.length == _size;
      if (mounted) setState(() {});
    }).catchError((e) => {_refreshController.refreshFailed()});
  }

  void _onLoading() async {
    // monitor network fetch
    _current++;
    widget.params["current"] = _current;
    widget.params["size"] = _size;
    HttpManager.getInstance()
        .get("/api/v1/orders", params: widget.params)
        .then((value) {
      var values = OrderEntity().fromJson(value).records;
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
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: _enablePullUp,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: _items.length == 0 ? _buildEmpty(context) : _buildList(context));
  }

  _buildList(BuildContext context) {
    return ListView.builder(
      itemBuilder: (c, i) {
        var item = _items[i];
        return Padding(
          padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Card(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    return OrderDetailsPage(id: item.orderId);
                  }));
                },
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: item.driverAvatar,
                              placeholder: (context, url) =>
                                  Image.asset("images/default_avatar.png",fit: BoxFit.cover,
                                    width: 48,
                                    height: 48,),
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            item.driverNickname,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            item.driverMobile,
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
//                                    GestureDetector(
//                                      child: Image.asset(
//                                        "images/wechat.png",
//                                        width: 22,
//                                        height: 22,
//                                        fit: BoxFit.fitWidth,
//                                      ),
//                                      onTap: () => {print("点击微信")},
//                                    ),
//                                    SizedBox(
//                                      width: 16,
//                                    ),
                                          InkWell(
                                            child: Image.asset(
                                              "images/tel_orange.png",
                                              width: 20,
                                              height: 20,
                                              fit: BoxFit.cover,
                                            ),
                                            onTap: () {
                                              PhoneUtils.call(context,item.driverMobile,
                                                  item.driverId, item.deliveryId);
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    item.cancelStatus
                                        ? "已取消"
                                        : item.confirmStatus
                                        ? "已完成"
                                        : item.protocolStatus == 1
                                        ? "已签协议"
                                        : "待签协议",
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.grey.shade100,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        color: Theme.of(context).primaryColor,
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Center(
                                            child: Text(
                                              "装",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "${AreaUtils.findCity(item.loadProvinceCode, item.loadCityCode).label} ${AreaUtils.findDistrict(item.loadProvinceCode, item.loadCityCode, item.loadDistrictCode).label}  ${DateTime.fromMillisecondsSinceEpoch(item.loadEndAt).toZhString()}前",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        color: Colors.blueAccent,
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Center(
                                            child: Text(
                                              "卸",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "${AreaUtils.findCity(item.unloadProvinceCode, item.unloadCityCode).label} ${AreaUtils.findDistrict(item.unloadProvinceCode, item.unloadCityCode, item.unloadDistrictCode).label}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  )
                                ],
                              ),
//                              GestureDetector(
//                                onTap: () => {print("点击查看轨迹")},
//                                child: Container(
//                                  color: Theme.of(context).primaryColor,
//                                  child: SizedBox(
//                                    height: 48,
//                                    width: 48,
//                                    child: Padding(
//                                      padding: EdgeInsets.all(8),
//                                      child: Text(
//                                        "查看轨迹",
//                                        textAlign: TextAlign.center,
//                                        style: TextStyle(
//                                            fontSize: 12, color: Colors.white),
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: !item.cancelStatus,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "订金:  ",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    "¥ ${item.amount}",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Text(
                                    "  ${item.refundStatus ? "(已退还)" : item.driverPayStatus ? "(已支付)" : "(待支付)"}",
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                              Row(
                                children: _buildActions(context, item),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              )),
        );
      },
      itemCount: _items.length,
    );
  }

//  Row(
//  crossAxisAlignment: CrossAxisAlignment.start,
//  children: [
//  CachedNetworkImage(
//  imageUrl: "http://via.placeholder.com/350x150",
//  placeholder: (context, url) =>
//  Image.asset("images/default_avatar.png"),
//  fit: BoxFit.cover,
//  width: 48,
//  height: 48,
//  ),
//  SizedBox(
//  width: 8,
//  ),
//  Column(
//  crossAxisAlignment: CrossAxisAlignment.start,
//  mainAxisSize: MainAxisSize.max,
//  children: <Widget>[
//  Row(
//  children: <Widget>[
//  Text(
//  "包万金",
//  style: TextStyle(fontSize: 12),
//  ),
//  SizedBox(
//  width: 16,
//  ),
//  Text(
//  "18630987110 (天津)",
//  style: TextStyle(
//  fontSize: 12, color: Colors.grey),
//  ),
//  ],
//  ),
//  SizedBox(
//  height: 4,
//  ),
//  Row(
//  children: <Widget>[
//  Text(
//  "廊坊 文安",
//  style: TextStyle(
//  fontSize: 16,
//  fontWeight: FontWeight.w700),
//  ),
//  Image.asset(
//  "images/arrow_right_alt.png",
//  width: 40,
//  height: 28,
//  ),
//  Text(
//  "咸阳 牵线",
//  style: TextStyle(
//  fontSize: 16,
//  fontWeight: FontWeight.w700),
//  ),
//  ],
//  ),
//  ],
//  )
//  ],
//  ),
//  SizedBox(
//  height: 8,
//  ),
//  Container(
//  margin: EdgeInsets.fromLTRB(56, 0, 0, 0),
//  child: Row(
//  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//  children: <Widget>[
//  Text(
//  "发货中",
//  style: TextStyle(
//  color: Theme.of(context).primaryColor,
//  fontSize: 12),
//  ),
//  Row(
//  children: <Widget>[
//  GestureDetector(
//  child: Container(
//  decoration: BoxDecoration(
//  border: Border.all(
//  color: Colors.white, width: 1),
//  color: true
//  ? Colors.grey.shade300
//      : Colors.transparent),
//  padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
//  child: Text(
//  "指定承运",
//  style: TextStyle(
//  fontSize: 12,
//  color: true
//  ? Colors.white
//      : Theme.of(context).primaryColor),
//  ),
//  ),
//  ),
//  SizedBox(
//  width: 8,
//  ),
////                                GestureDetector(
////                                  child: Container(
////                                    decoration: BoxDecoration(
////                                        border: Border.all(
////                                            color: Theme.of(context)
////                                                .primaryColor,
////                                            width: 1),
////                                        color: true
////                                            ? Colors.transparent
////                                            : Colors.grey.shade300),
////                                    padding:
////                                    EdgeInsets.fromLTRB(8, 4, 8, 4),
////                                    child: Text(
////                                      "  聊天  ",
////                                      style: TextStyle(
////                                          fontSize: 12,
////                                          color: true
////                                              ? Theme.of(context)
////                                              .primaryColor
////                                              : Theme.of(context)
////                                              .primaryColor),
////                                    ),
////                                  ),
////                                ),
//  SizedBox(
//  width: 8,
//  ),
//  GestureDetector(
//  child: Container(
//  decoration: BoxDecoration(
//  border: Border.all(
//  color:
//  Theme.of(context).primaryColor,
//  width: 1),
//  color: true
//  ? Theme.of(context).primaryColor
//      : Colors.grey.shade300),
//  padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
//  child: Text(
//  " 打电话 ",
//  style: TextStyle(
//  fontSize: 12,
//  color: true
//  ? Colors.white
//      : Theme.of(context).primaryColor),
//  ),
//  ),
//  ),
//  ],
//  )
//  ],
//  ),
//  )

  _buildEmpty(BuildContext context) {
    return EmptyPage(
      image: "images/empty_order.png",
      children: <Widget>[
        SizedBox(
          height: 16,
        ),
        Text("暂无数据"),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  _buildActions(BuildContext context, OrderRecord item) {
    List<Widget> widgets = [];
    if (item.cancelStatus) {
      return widgets;
    }

    if (!item.driverPayStatus && !item.confirmStatus) {
      widgets.add(InkWell(
        child: Text(
          "取消订单",
          style: TextStyle(fontSize: 12),
        ),
        onTap: () async {
          final result =
          await Navigator.of(context).push(MaterialPageRoute(builder: (c) {
            return OrderCancelPage(item.orderId);
          }));
          if (result == "success") {
            _refreshController.requestRefresh();
          }
        },
      ));
      widgets.add(SizedBox(
        width: 4,
      ));

      widgets.add(InkWell(
        child: Text(
          "支付定金",
          style: TextStyle(fontSize: 12,color: Theme.of(context).primaryColor),
        ),
        onTap: () async {
          final result =
          await Navigator.of(context).push(MaterialPageRoute(builder: (c) {
            DeliveryDetailsEntity entity = DeliveryDetailsEntity();
            entity.loadProvinceCode = item.loadProvinceCode;
            entity.loadCityCode = item.loadCityCode;
            entity.loadDistrictCode = item.loadDistrictCode;
            entity.unloadProvinceCode = item.unloadProvinceCode;
            entity.unloadCityCode = item.unloadCityCode;
            entity.unloadDistrictCode = item.unloadDistrictCode;
            entity.loadStartAt = item.loadStartAt;
            entity.loadEndAt = item.loadEndAt;
            entity.id = item.orderId;
            return PrePayPage(entity,item.freightAmount.toString(),item.amount.toString(),1);
          }));
          if (result == "success") {
            _refreshController.requestRefresh();
          }
        },
      ));
      widgets.add(SizedBox(
        width: 4,
      ));
    }


    if (!item.confirmStatus) {
      widgets.add(InkWell(
        child: Text(
          item.protocolStatus == 1 || item.protocolStatus == 3
              ? "查看协议"
              : "签订协议",
          style: TextStyle(fontSize: 12),
        ),
        onTap: () async {
          var result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return ProtocolPage(item.orderId);
          }));
          if (result == "success") {
            _refreshController.requestRefresh();
          }
        },
      ));
    }

    if (item.confirmStatus && item.protocolStatus == 1) {
      widgets.add(InkWell(
        child: Text(
          "查看协议",
          style: TextStyle(fontSize: 12),
        ),
        onTap: () => {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return ProtocolPage(item.orderId);
          }))
        },
      ));
    }

    if (item.confirmStatus && !item.evaluateStatus) {
      widgets.add(InkWell(
        child: Text(
          "评价订单",
          style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
        ),
        onTap: ()  async {
          final result = await Navigator.of(context)
              .push(MaterialPageRoute(builder: (c) {
            return EvaluationSubmitPage(item.orderId,item.userAvatar,"${AreaUtils.findCity(item.loadProvinceCode, item.loadCityCode).label} ${AreaUtils.findDistrict(item.loadProvinceCode, item.loadCityCode, item.loadDistrictCode).label} → ${AreaUtils.findCity(item.unloadProvinceCode, item.unloadCityCode).label} ${AreaUtils.findDistrict(item.unloadProvinceCode, item.unloadCityCode, item.unloadDistrictCode).label}",item.userNickname,item.categoryName);
          }));
          if (result == "success") {
            _refreshController.requestRefresh();
          }
        },
      ));
    }

    return widgets;
  }
}
