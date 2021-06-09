import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdriver/global.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/model/delivery_details_entity.dart';
import 'package:flutterdriver/utils/area_utils.dart';
import 'package:flutterdriver/utils/date_utils.dart';
import 'package:flutterdriver/utils/phone_utils.dart';
import 'PrePayPage.dart';
import 'authentication_page2.dart';

class DeliverDetailsPage extends StatefulWidget {
  final String id;
  final bool editable;

  DeliverDetailsPage(this.id, this.editable);

  @override
  _DeliverDetailsPageState createState() => _DeliverDetailsPageState();
}

class _DeliverDetailsPageState extends State<DeliverDetailsPage> {
  Future<DeliveryDetailsEntity> _fetchDetails;

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
        title: Text("详情"),
      ),
      body: FutureBuilder(
        future: _fetchDetails,
        builder: (BuildContext c, AsyncSnapshot<DeliveryDetailsEntity> s) {
          if (s.connectionState == ConnectionState.done) {
            if (s.hasError) {
              return Text("服务错误 ${s.error}");
            } else {
              return ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            "${AreaUtils.findCity(s.data.loadProvinceCode, s.data.loadCityCode).label} ${AreaUtils.findDistrict(s.data.loadProvinceCode, s.data.loadCityCode, s.data.loadDistrictCode).label} → ${AreaUtils.findCity(s.data.loadProvinceCode, s.data.loadCityCode).label} ${AreaUtils.findDistrict(s.data.unloadProvinceCode, s.data.unloadCityCode, s.data.unloadDistrictCode).label}"),
                        Visibility(
                          visible: widget.editable,
                          child: MaterialButton(
                            minWidth: 44,
                            shape: Border.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 1),
                            child: Text("编辑"),
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
//                                return DeliverPage(record:record,isEdit:true);
                                return null;
                              }));
                            },
                          ),
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
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
                        Visibility(
                          visible: s.data.expectMoney != null,
                          child: Row(
                            children: <Widget>[
                              Text(
                                "期望运费",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text("${s.data.expectMoney}/${s.data.expectUnit}",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 14))
                            ],
                          ),
                        ),
                        Visibility(
                          visible: s.data.expectMoney != null,
                          child: SizedBox(
                            height: 8,
                          ),
                        ),
                        Visibility(
                            visible: s.data.requireList != null,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "特殊要求",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text("${s.data.requireList}".replaceAll(",", "/"),
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 14))
                              ],
                            ))
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("装卸信息",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            SizedBox(
                              width: 10,
                            ),
                            Text("${s.data.loadUnload}",
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 14))
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    "${DateUtils.getTimeString(s.data.loadStartAt, s.data.loadEndAt)}装货"),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "${AreaUtils.findCity(s.data.loadProvinceCode, s.data.loadCityCode).label} ${AreaUtils.findDistrict(s.data.loadProvinceCode, s.data.loadCityCode, s.data.loadDistrictCode).label}",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            )
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
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
                    padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
//                        Text("已来电司机(${s.data.calls.length}人)",
//                            style: TextStyle(
//                                color: Colors.black,
//                                fontWeight: FontWeight.bold,
//                                fontSize: 16)),
                        Text("货主信息",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: s.data.avatar,
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
                    title: Text("${s.data.nickname} (${s.data.companyName})"),
                    subtitle: Text(Global.isAuthenticated()
                        ? s.data.mobile
                        : s.data.mobile.replaceRange(4, 8, "****")),
                    trailing: IconButton(
                      onPressed: () {
                        PhoneUtils.call(
                            context, s.data.mobile, s.data.userId, widget.id);
                      },
                      icon: Icon(
                        Icons.phone,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
                    child: MaterialButton(
                      onPressed: () {
                        if (Global.isAuthenticated()) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (c) {
                            return PrePayPage(s.data, null, null, 0);
                          }));
                        } else {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (c) {
                            return AuthenticationPage2();
                          }));
                        }
                      },
                      child: Text("支付定金"),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
//                  s.data.calls.length == 0 ? _buildEmpty(c):_buildList(s)
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
    );
  }

  Future<DeliveryDetailsEntity> _fetch() async {
    var v = await HttpManager.getInstance()
        .get("/api/v1/deliver/goods/${widget.id}");
    return DeliveryDetailsEntity().fromJson(v);
  }
//
// _buildList(AsyncSnapshot<DeliveryDetailsEntity> s) {
//   return ListView.builder(
//       itemCount: s.data.calls.length,
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemBuilder: (c, i) {
//         var call = s.data.calls[i];
//         return ListTile(
//           leading: CachedNetworkImage(
//             imageUrl: call.fromAvatar,
//             placeholder: (context, url) =>
//                 Image.asset("images/default_avatar.png",fit: BoxFit.cover,
//                   width: 48,
//                   height: 48,),
//             fit: BoxFit.cover,
//             width: 48,
//             height: 48,
//           ),
//           title: Text(call.fromNickname),
//           subtitle: Text(call.fromMobile),
//           trailing: IconButton(
//             onPressed: () {
//               PhoneUtils.call(call.fromMobile, call.fromUserId, widget.id);
//             },
//             icon: Icon(
//               Icons.phone,
//               color: Theme.of(context).primaryColor,
//             ),
//           ),
//         );
//       });
// }
//
// _buildEmpty(BuildContext context) {
//   return EmptyPage(
//     children: <Widget>[
//       Text("暂无数据"),
//     ],
//   );
// }
}
