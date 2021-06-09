
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freightowner/http/http.dart';
import 'package:freightowner/model/delivery_details_entity.dart';
import 'package:freightowner/model/order_details_entity.dart';
import 'package:freightowner/pages/order_cancel_page.dart';
import 'package:freightowner/pages/order_refund_page.dart';
import 'package:freightowner/pages/protocal_page.dart';
import 'package:freightowner/utils/date_utils.dart';
import 'package:freightowner/utils/area_utils.dart';
import 'package:freightowner/utils/phone_utils.dart';
import 'package:freightowner/widget/loading_dialog.dart';

import 'PrePayPage.dart';
import 'evaluation_submit_page.dart';

class OrderDetailsPage extends StatefulWidget {
  final String id;

  const OrderDetailsPage({Key key, this.id}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Future<OrderDetailsEntity> _fetchDetails;

  @override
  void initState() {
    _fetchDetails = _fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("订单详情"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _fetchDetails,
          builder: (BuildContext c, AsyncSnapshot<OrderDetailsEntity> s) {
            if (s.connectionState == ConnectionState.done) {
              if (s.hasError) {
                return Text("服务错误 ${s.error}");
              } else {
                return Stack(
                  children: <Widget>[
                    ListView(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "订单号:${s.data.id}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                child: Text(
                                  s.data.confirmStatus
                                      ? "已完成"
                                      : s.data.protocolStatus != 1
                                          ? "待签协议"
                                          : "已签协议",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "装",
                                    style: TextStyle(
                                        color: Colors.lightGreen, fontSize: 14),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "${AreaUtils.findCity(s.data.loadProvinceCode, s.data.loadCityCode).label} ${AreaUtils.findDistrict(s.data.loadProvinceCode, s.data.loadCityCode, s.data.loadDistrictCode).label}",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                      "${DateUtils.getTimeString(s.data.loadStartAt, s.data.loadEndAt)}装货"),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "卸",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "${AreaUtils.findCity(s.data.unloadProvinceCode, s.data.unloadCityCode).label} ${AreaUtils.findDistrict(s.data.unloadProvinceCode, s.data.unloadCityCode, s.data.unloadDistrictCode).label} ",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 10,
                          color: Colors.grey.shade200,
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("车货信息",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "车辆　　",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                      "${s.data.carLongs.replaceAll(",", "/")}米　${s.data.carModels.replaceAll(",", "/")} ",
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 14))
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "货物　　",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                      "${s.data.categoryName}, ${s.data.weight}吨, ${s.data.packageMode}",
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 14))
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "装卸　　",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text("${s.data.loadUnload}",
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 14))
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 10,
                          color: Colors.grey.shade200,
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("司机信息",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              SizedBox(
                                height: 8,
                              ),
                              ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl: s.data.driverAvatar,
                                  placeholder: (context, url) => Image.asset(
                                    "images/default_avatar.png",
                                    fit: BoxFit.cover,
                                    width: 48,
                                    height: 48,
                                  ),
                                  fit: BoxFit.cover,
                                  width: 48,
                                  height: 48,
                                ),
                                title: Text(s.data.driverName),
                                subtitle: Text(s.data.driverMobile),
                                trailing: IconButton(
                                  icon: Icon(Icons.phone),
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    PhoneUtils.call(s.data.driverMobile,
                                        s.data.driverId, s.data.deliveryId);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 10,
                          color: Colors.grey.shade200,
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: <Widget>[
                              Text("订金"),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "¥ ${s.data.amount}",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(s.data.refundStatus? "已退还":s.data.driverPayStatus ? "已支付" : "未支付"),
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 32,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _buildButtons(s.data),
                        ),
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
    );
  }

  _buildButtons(OrderDetailsEntity data) {
    List<Widget> list = [];

    if (data.cancelStatus) {
      return list;
    }

    if (!data.driverPayStatus && !data.confirmStatus) {
      list.add(Expanded(
          child: Padding(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: OutlineButton(
          onPressed: () async {
            final result = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (c) {
              return OrderCancelPage(data.id);
            }));
            if (result == "success") {
              setState(() {
                _fetchDetails = _fetch();
              });
            }
          },
          child: Text("取消订单"),
          textColor: Theme.of(context).primaryColor,
          borderSide: new BorderSide(color: Theme.of(context).primaryColor),
        ),
      )));
    }
    if (data.driverPayStatus && !data.refundStatus) {
      list.add(Expanded(
          child: Padding(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: OutlineButton(
          onPressed: () async {
            final result = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (c) {
              return OrderRefundPage(data.id,data.amount);
            }));
            if (result == "success") {
              setState(() {
                _fetchDetails = _fetch();
              });
            }
          },
          child: Text("退还订金"),
          textColor: Theme.of(context).primaryColor,
          borderSide: new BorderSide(color: Theme.of(context).primaryColor),
        ),
      )));
    }

    if (!data.confirmStatus) {
      list.add(Expanded(
        child: Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: MaterialButton(
            onPressed: () {
              showLoadingDialog();
              HttpManager.getInstance()
                  .post("/api/v1/orders/confirm/${data.id}")
                  .then((value) {
                setState(() {
                  _fetchDetails = _fetch();
                });
              }).whenComplete(() => hideLoadingDialog());
            },
            color: Theme.of(context).primaryColor,
            child: Text("确认收货"),
            textColor: Colors.white,
          ),
        ),
      ));

      list.add(Expanded(
          child: Padding(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: OutlineButton(
          onPressed: () async {
            var result = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return ProtocolPage(data.id);
            }));
            if (result == "success") {
              setState(() {
                _fetchDetails = _fetch();
              });
            }
          },
          child: Text(data.protocolStatus == 1 || data.protocolStatus == 2
              ? "查看协议"
              : "签订协议"),
          textColor: Theme.of(context).primaryColor,
          borderSide: new BorderSide(color: Theme.of(context).primaryColor),
        ),
      )));


      if(data.protocolStatus == 1){
        list.add(Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: OutlineButton(
                onPressed: () async {
                  final result =
                  await Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    DeliveryDetailsEntity entity = DeliveryDetailsEntity();
                    entity.loadProvinceCode = data.loadProvinceCode;
                    entity.loadCityCode = data.loadCityCode;
                    entity.loadDistrictCode = data.loadDistrictCode;
                    entity.unloadProvinceCode = data.unloadProvinceCode;
                    entity.unloadCityCode = data.unloadCityCode;
                    entity.unloadDistrictCode = data.unloadDistrictCode;
                    entity.loadStartAt = data.loadStartAt;
                    entity.loadEndAt = data.loadEndAt;
                    entity.id = data.id;
                    return PrePayPage(entity);
                  }));

                  if (result == "success") {
                    setState(() {
                      _fetchDetails = _fetch();
                    });
                  }
                },
                child: Text("支付运费"),
                textColor: Theme.of(context).primaryColor,
                borderSide: new BorderSide(color: Theme.of(context).primaryColor),
              ),
            )));
      }
    }

    if (data.confirmStatus && data.protocolStatus == 1) {
      list.add(Expanded(
          child: Padding(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: OutlineButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return ProtocolPage(data.id);
            }));
          },
          child: Text("查看协议"),
          textColor: Theme.of(context).primaryColor,
          borderSide: new BorderSide(color: Theme.of(context).primaryColor),
        ),
      )));
    }

    if (data.confirmStatus && !data.evaluateStatus) {
      list.add(Expanded(
          child: Padding(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: OutlineButton(
          onPressed: () async {
            final result = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (c) {
              return EvaluationSubmitPage(
                  data.id,
                  data.driverAvatar,
                  "${AreaUtils.findCity(data.loadProvinceCode, data.loadCityCode).label} ${AreaUtils.findDistrict(data.loadProvinceCode, data.loadCityCode, data.loadDistrictCode).label} → ${AreaUtils.findCity(data.unloadProvinceCode, data.unloadCityCode).label} ${AreaUtils.findDistrict(data.unloadProvinceCode, data.unloadCityCode, data.unloadDistrictCode).label}",
                  data.driverName,
                  data.categoryName);
            }));
            if (result == "success") {
              setState(() {
                _fetchDetails = _fetch();
              });
            }
          },
          child: Text("评价订单"),
          textColor: Theme.of(context).primaryColor,
          borderSide: new BorderSide(color: Theme.of(context).primaryColor),
        ),
      )));
    }

    return list;
  }

  Future<OrderDetailsEntity> _fetch() async {
    var v = await HttpManager.getInstance().get("/api/v1/orders/${widget.id}");
    return OrderDetailsEntity().fromJson(v);
  }
}
