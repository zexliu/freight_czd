import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/model/area_entity.dart';
import 'package:freightowner/utils/text_input_formatter.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:freightowner/widget/city_picker.dart';
import 'package:freightowner/widget/loading_dialog.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:permission_handler/permission_handler.dart';

class NavComputePage extends StatefulWidget {
  @override
  _NavComputePageState createState() => _NavComputePageState();
}

class _NavComputePageState extends State<NavComputePage> {
  AmapController _mapController;
  AreaEntity _loadProvince;
  AreaEntity _loadCity;
  AreaEntity _loadDistrict;

  AreaEntity _uploadProvince;
  AreaEntity _uploadCity;
  AreaEntity _uploadDistrict;

  double distance0 = 0;
  double distance1 = 1;
  double distance2 = 2;

  List<DriveStep> steps0;
  List<DriveStep> steps1;
  List<DriveStep> steps2;

  int selectedType = 0;

  TextEditingController _editingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _focusNode),
    ], nextFocus: false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text('里程计算'),
      backgroundColor: Colors.white,
    );
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: KeyboardActions(
          config: _buildConfig(context),
          autoScroll: false,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return SafeArea(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: CityPicker(
                              title: "选择装货地",
                              province: _loadProvince,
                              city: _loadCity,
                              district: _loadDistrict,
                              onChanged: (province, city, district) {
                                setState(() {
                                  this._loadProvince = province;
                                  this._loadCity = city;
                                  this._loadDistrict = district;
                                });
                                _handleSearchRoute();
                              },
                            ),
                          ),
                        );
                      });
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: <Widget>[
                      ClipOval(
                        child: Container(
                          width: 10,
                          height: 10,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text("从"),
                      Expanded(
                        child: _buildAddressText(
                            "请选择装货地", _loadProvince, _loadCity, _loadDistrict),
                      ),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return SafeArea(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: CityPicker(
                              title: "选择卸货地",
                              province: _uploadProvince,
                              city: _uploadCity,
                              district: _uploadDistrict,
                              onChanged: (province, city, district) {
                                setState(() {
                                  this._uploadProvince = province;
                                  this._uploadCity = city;
                                  this._uploadDistrict = district;
                                });
                                _handleSearchRoute();
                              },
                            ),
                          ),
                        );
                      });
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: <Widget>[
                      ClipOval(
                        child: Container(
                          width: 10,
                          height: 10,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text("到"),
                      Expanded(
                        child: _buildAddressText("请选择卸货地", _uploadProvince,
                            _uploadCity, _uploadDistrict),
                      ),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
//          Divider(),
              Expanded(
                child: AmapView(
                  onMapCreated: (controller) async {
                    _mapController = controller;
                    if (await requestPermission()) {
                      await controller
                          .showMyLocation(MyLocationOption(show: true));
                    }
                  },
                  zoomLevel: 10,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedType = 0;
                          });
                          updateLines(steps0);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("速度优先",
                                style: selectedType == 0
                                    ? TextStyle(
                                        color: Theme.of(context).primaryColor)
                                    : TextStyle(color: Colors.grey)),
                            Text("${(distance0 / 1000).toStringAsFixed(2)} KM",
                                style: selectedType == 0
                                    ? TextStyle(
                                        color: Theme.of(context).primaryColor)
                                    : TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedType = 1;
                          });
                          updateLines(steps1);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("费用优先",
                                style: selectedType == 1
                                    ? TextStyle(
                                        color: Theme.of(context).primaryColor)
                                    : TextStyle(color: Colors.grey)),
                            Text("${(distance1 / 1000).toStringAsFixed(2)} KM",
                                style: selectedType == 1
                                    ? TextStyle(
                                        color: Theme.of(context).primaryColor)
                                    : TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedType = 2;
                          });
                          updateLines(steps2);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("距离优先",
                                style: selectedType == 2
                                    ? TextStyle(
                                        color: Theme.of(context).primaryColor)
                                    : TextStyle(color: Colors.grey)),
                            Text("${(distance2 / 1000).toStringAsFixed(2)} KM",
                                style: selectedType == 2
                                    ? TextStyle(
                                        color: Theme.of(context).primaryColor)
                                    : TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 16,
                  ),
                  Text("请输入成本"),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _editingController,
                      focusNode: _focusNode,
                      textAlign: TextAlign.left,
                      minLines: 1,
                      maxLines: 1,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                        //只输入数字
                        UsNumberTextInputFormatter(),
                        //只输入数字
                      ],
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintText: "元/公里",
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          isDense: true,
                          border: InputBorder.none,
                          counterText: ""),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      if(_editingController.text.isEmpty){
                        Toast.show("请输入成本金额");
                        return;
                      }
                      double distance;
                      if (selectedType == 0) {
                        distance = distance0;
                      } else if (selectedType == 1) {
                        distance = distance1;
                      } else if (selectedType == 2) {
                        distance = distance2;
                      }
                      var amount = double.parse(_editingController.text);
                      var total = (distance / 1000  * amount).toStringAsFixed(2);
                      showCupertinoDialog(context: context, builder: (c){
                        return new CupertinoAlertDialog(
                          content: new Text("总费用大约$total元"),
                          actions: [
                             FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: new Text("确认"),
                            ),
                          ],
                        );
                      });
                    },
                    child: Text("成本计算"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> requestPermission() async {
    final status = await Permission.location.request();

    if (status == PermissionStatus.granted) {
      return true;
    } else {
      Toast.show('需要定位权限!');
      return false;
    }
  }

  _buildAddressText(
      String msg, AreaEntity province, AreaEntity city, AreaEntity district) {
    String message;
    if (province != null && city != null && district != null) {
      if (province.label == city.label) {
        message = "${province.label} ${district.label}";
      } else {
        message = "${province.label} ${city.label} ${district.label}";
      }
    } else {
      message = msg;
    }
    return Text(
      message,
      maxLines: 1,
      textAlign: TextAlign.end,
    );
  }

  Future<void> _handleSearchRoute() async {
    if (_loadDistrict == null || _uploadDistrict == null) {
      return;
    }

    showLoadingDialog();
    final fromLatLng = LatLng(_loadDistrict.latitude, _loadDistrict.longitude);
    final toLatLng =
        LatLng(_uploadDistrict.latitude, _uploadDistrict.longitude);

    final route0 = await AmapSearch.instance.searchDriveRoute(
        from: fromLatLng, to: toLatLng, strategy: 0);
    final route1 = await AmapSearch.instance.searchDriveRoute(
        from: fromLatLng, to: toLatLng, strategy: 1);
    final route2 = await AmapSearch.instance.searchDriveRoute(
        from: fromLatLng, to: toLatLng, strategy: 2);

    final pathList0 = await route0.drivePathList;
    final pathList1 = await route1.drivePathList;
    final pathList2 = await route2.drivePathList;
    if (pathList0.isNotEmpty) {
      distance0 = await pathList0[0].distance;
      steps0 = await pathList0[0].driveStepList;
    }

    if (pathList1.isNotEmpty) {
      distance1 = await pathList1[0].distance;
      steps1 = await pathList1[0].driveStepList;
    }

    if (pathList2.isNotEmpty) {
      distance2 = await pathList2[0].distance;
      steps2 = await pathList2[0].driveStepList;
    }

    //add lines
    List<DriveStep> steps;
    if (selectedType == 0) {
      steps = steps0;
    } else if (selectedType == 1) {
      steps = steps1;
    } else if (selectedType == 2) {
      steps = steps2;
    }
    await updateLines(steps);
    hideLoadingDialog();
    setState(() {});
  }

  Future updateLines(List<DriveStep> steps) async {
    if (steps == null || steps.isEmpty) {
      return;
    }
    _mapController.clear(keepMyLocation: true);
    List<LatLng> bounds = [];

    for (final step in steps) {
      var latLngList = await step.polyline;
      bounds.addAll(latLngList);
      _mapController.addPolyline(PolylineOption(
        latLngList: latLngList,
        width: 10,
      ));
      //      for (final tmc in await step.tmsList) {
      //        final status = await tmc.status;
      //        Color statusColor = Colors.green;
      //        switch (status) {
      //          case '缓行':
      //            statusColor = Colors.yellow;
      //            break;
      //          case '拥堵':
      //            statusColor = Colors.red;
      //            break;
      //          case '未知':
      //            statusColor = Colors.blue;
      //            break;
      //          default:
      //            break;
      //        }
      //
      //        var latLngList = await tmc.polyline;
      //
      //        bounds.addAll(latLngList);
      //        await _mapController.addPolyline(PolylineOption(
      //          latLngList:latLngList,
      //          strokeColor: statusColor,
      //          width: 10,
      //        ));
      //      }
    }
    _mapController.zoomToSpan(bounds);
  }
//    final fromLat = double.tryParse(_fromLatitudeController.text);
//    final fromLng = double.tryParse(_fromLongitudeController.text);
//    final toLat = double.tryParse(_toLatitudeController.text);
//    final toLng = double.tryParse(_toLongitudeController.text);
//
//    try {
//      _mapController.addDriveRoute(
//        from: LatLng(fromLat, fromLng),
//        to: LatLng(toLat, toLng),
//        trafficOption: TrafficOption(show: true),
//      );
//    } catch (e) {
//      L.d(e);
//    }
//  }
}
