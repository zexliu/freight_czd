import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/model/area_entity.dart';
import 'package:freightowner/model/deliver_goods_entity.dart';
import 'package:freightowner/pages/confirm_deliver_page.dart';
import 'package:freightowner/utils/area_utils.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:freightowner/widget/load_unload_picker.dart';
import 'package:freightowner/widget/car_picker.dart';
import 'package:freightowner/widget/city_picker.dart';
import 'package:freightowner/widget/goods_picker.dart';

import 'deliver_adress_input.dart';

class DeliverPage extends StatefulWidget {
  final DeliverGoodsRecord record;

  final bool isEdit;
  DeliverPage({this.record,this.isEdit});

  @override
  _DeliverPageState createState() => _DeliverPageState();
}

class _DeliverPageState extends State<DeliverPage> {
  _onConfirm() {
    if (_loadProvince == null || _loadCity == null || _loadDistrict == null) {
      Toast.show("请选择装货地");
      return;
    }
    if (_uploadProvince == null ||
        _uploadCity == null ||
        _uploadDistrict == null) {
      Toast.show("请选择装卸地");
      return;
    }
    if (_categoryName == null || !(_weight != null || _volume != null)) {
      Toast.show("请输入货物信息");
      return;
    }
    if (_carType == null || _carLongs.isEmpty || _carModels.isEmpty) {
      Toast.show("请选择车型车长");
      return;
    }

    var map = {
      "loadProvinceCode": _loadProvince.value,
      "loadCityCode": _loadCity.value,
      "loadDistrictCode": _loadDistrict.value,
      "loadAddress": _loadAddress,
      "loadWayProvinceCode": _isWayLoadShow ? _loadWayProvince?.value : null,
      "loadWayCityCode": _isWayLoadShow ? _loadWayCity?.value : null,
      "loadWayDistrictCode": _isWayLoadShow ? _loadWayDistrict?.value : null,
      "loadWayAddress": _isWayLoadShow ? _loadWayAddress : null,
      "unloadProvinceCode": _uploadProvince.value,
      "unloadCityCode": _uploadCity.value,
      "unloadDistrictCode": _uploadDistrict.value,
      "unloadAddress": _uploadAddress,
      "unloadWayProvinceCode":
          _isSubUploadShow ? _uploadWayProvince?.value : null,
      "unloadWayCityCode": _isSubUploadShow ? _uploadWayCity?.value : null,
      "unloadWayDistrictCode":
          _isSubUploadShow ? _uploadWayDistrict?.value : null,
      "unloadWayAddress": _isSubUploadShow ? _uploadWayAddress : null,
      "categoryName": _categoryName,
      "weight": _weight,
      "volume": _volume,
      "carType": _carType,
      "carLongs": _carLongs,
      "carPlaceLong": _placeCarLong,
      "carModels": _carModels,
      "loadUnload": _loadUnload,
      "packageMode": _packageMode,
      "loadLat": _loadPoint?.latLng?.latitude,
      "loadLon": _loadPoint?.latLng?.longitude,
      "loadWayLat": _loadWayPoint?.latLng?.latitude,
      "loadWayLon": _loadWayPoint?.latLng?.longitude,
      "unloadLat": _uploadPoint?.latLng?.latitude,
      "unloadLon": _uploadPoint?.latLng?.longitude,
      "unloadWayLat": _uploadWayPoint?.latLng?.latitude,
      "unloadWayLon": _uploadWayPoint?.latLng?.longitude,
    };
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return ConfirmDeliverPage(formData: map,record: widget.record,isEdit: widget.isEdit,);
    }));
  }

  bool _isWayLoadShow = false;
  bool _isSubUploadShow = false;
  AreaEntity _loadProvince;
  AreaEntity _loadCity;
  AreaEntity _loadDistrict;
  String _loadAddress = "";
  Poi _loadPoint;

  AreaEntity _loadWayProvince;
  AreaEntity _loadWayCity;
  AreaEntity _loadWayDistrict;
  String _loadWayAddress = "";
  Poi _loadWayPoint;

  AreaEntity _uploadWayProvince;
  AreaEntity _uploadWayCity;
  AreaEntity _uploadWayDistrict;
  String _uploadWayAddress = "";
  Poi _uploadWayPoint;

  AreaEntity _uploadProvince;
  AreaEntity _uploadCity;
  AreaEntity _uploadDistrict;
  String _uploadAddress = "";
  Poi _uploadPoint;

  String _packageMode;
  String _categoryName;
  //发货改的傻逼需求
  String _weight;
  //发货改的傻逼需求
  String _volume;

  String _carType;

  List<String> _carLongs = [];

  double _placeCarLong;

  List<String> _carModels = [];

  String _loadUnload = "一装一卸";

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      if (widget.record.loadProvinceCode != null &&
          widget.record.loadCityCode != null &&
          widget.record.loadDistrictCode != null) {
        _loadProvince = AreaUtils.findProvince(widget.record.loadProvinceCode);
        _loadCity = AreaUtils.findCity(
            widget.record.loadProvinceCode, widget.record.loadCityCode);
        _loadDistrict = AreaUtils.findDistrict(widget.record.loadProvinceCode,
            widget.record.loadCityCode, widget.record.loadDistrictCode);
      }
      if (widget.record.loadWayProvinceCode != null &&
          widget.record.loadWayCityCode != null &&
          widget.record.loadWayDistrictCode != null) {
        _loadWayProvince =
            AreaUtils.findProvince(widget.record.loadWayProvinceCode);
        _loadWayCity = AreaUtils.findCity(
            widget.record.loadWayProvinceCode, widget.record.loadWayCityCode);
        _loadWayDistrict = AreaUtils.findDistrict(
            widget.record.loadWayProvinceCode,
            widget.record.loadWayCityCode,
            widget.record.loadWayDistrictCode);
        _isWayLoadShow = true;
      }
      if (widget.record.unloadProvinceCode != null &&
          widget.record.unloadCityCode != null &&
          widget.record.unloadDistrictCode != null) {
        _uploadProvince =
            AreaUtils.findProvince(widget.record.unloadProvinceCode);
        _uploadCity = AreaUtils.findCity(
            widget.record.unloadProvinceCode, widget.record.unloadCityCode);
        _uploadDistrict = AreaUtils.findDistrict(
            widget.record.unloadProvinceCode,
            widget.record.unloadCityCode,
            widget.record.unloadDistrictCode);
      }

      if (widget.record.unloadWayProvinceCode != null &&
          widget.record.unloadWayCityCode != null &&
          widget.record.unloadWayDistrictCode != null) {
        _uploadWayProvince =
            AreaUtils.findProvince(widget.record.unloadWayProvinceCode);
        _uploadWayCity = AreaUtils.findCity(widget.record.unloadWayProvinceCode,
            widget.record.unloadWayCityCode);
        _uploadWayDistrict = AreaUtils.findDistrict(
            widget.record.unloadWayProvinceCode,
            widget.record.unloadWayCityCode,
            widget.record.unloadWayDistrictCode);
        _isSubUploadShow = true;
      }
      if (widget.record.loadAddress != null) {
        _loadAddress = widget.record.loadAddress;
      }

      if (widget.record.loadWayAddress != null) {
        _loadWayAddress = widget.record.loadWayAddress;
      }

      if (widget.record.unloadWayAddress != null) {
        _uploadWayAddress = widget.record.unloadWayAddress;
      }

      if (widget.record.unloadAddress != null) {
        _uploadAddress = widget.record.unloadAddress;
      }

      if (widget.record.categoryName != null) {
        _categoryName = widget.record.categoryName;
      }

      if (widget.record.weight != null) {
        _weight = widget.record.weight;
      }
      if (widget.record.volume != null) {
        _volume = widget.record.volume;
      }

      if (widget.record.carType != null) {
        _carType = widget.record.carType;
      }
      if (widget.record.carLongs != null) {
        _carLongs = widget.record.carLongs.split(",");
      }

      if (widget.record.carPlaceLong != null) {
        _placeCarLong = widget.record.carPlaceLong;
      }

      if (widget.record.carModels != null) {
        _carModels = widget.record.carModels.split(",");
      }

      if (widget.record.loadUnload != null) {
        _loadUnload = widget.record.loadUnload;
      }

      if(widget.record.loadLat != null && widget.record.loadLon != null){
        _loadPoint = Poi(latLng: LatLng(widget.record.loadLat,widget.record.loadLon));
      }

      if(widget.record.loadWayLat != null && widget.record.loadWayLon != null){
        _loadWayPoint = Poi(latLng: LatLng(widget.record.loadWayLat,widget.record.loadWayLon));
      }

      if(widget.record.unloadLat != null && widget.record.unloadLon != null){
        _uploadPoint = Poi(latLng: LatLng(widget.record.unloadLat,widget.record.unloadLon));
      }
      if(widget.record.unloadWayLat != null && widget.record.unloadWayLon != null){
        _uploadWayPoint = Poi(latLng: LatLng(widget.record.unloadLat,widget.record.unloadLon));
      }

      if(widget.record.packageMode != null ){
        _packageMode = widget.record.packageMode;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String goodsMsg = "";
    if (_categoryName != null) {
      goodsMsg = "$_categoryName,$_packageMode";
    }
    if (_weight != null) {
      goodsMsg += ",约$_weight吨";
    }
    if (_volume != null) {
      goodsMsg += ",约$_volume方";
    }

    String carMsg = "";
    if (_carType != null) {
      carMsg = _carType;
    }
    if (_carLongs.isNotEmpty) {
      carMsg += ",${_carLongs.join("米,")}米";
    }
    if (_placeCarLong != null) {
      carMsg += "占$_placeCarLong米";
    }
    if (_carModels.isNotEmpty) {
      carMsg += ",${_carModels.join(",")}";
    }
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text("发布货源"),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16),
                child: ListView(
                  children: <Widget>[
                    Card(
                      child: Column(children: _buildAddress()),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                        child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Text("货物信息"),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return SafeArea(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                            child: GoodsPicker(
                                              packageMode: _packageMode,
                                              categoryName: _categoryName,
                                              weight: _weight,
                                              volume: _volume,
                                              onChanged: (packageMode,
                                                  categoryName,
                                                  weight,
                                                  volume) {
                                                setState(() {
                                                  this._packageMode =
                                                      packageMode;
                                                  this._categoryName =
                                                      categoryName;
                                                  this._weight = weight;
                                                  this._volume = volume;
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        height: 48,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          goodsMsg.isEmpty
                                              ? "必填 请输入货物信息"
                                              : goodsMsg,
                                          style: TextStyle(
                                              color: goodsMsg.isEmpty
                                                  ? Colors.grey
                                                  : Colors.black,
                                              fontWeight: goodsMsg.isEmpty
                                                  ? FontWeight.normal
                                                  : FontWeight.bold,
                                              fontSize:
                                                  goodsMsg.isEmpty ? 12 : 14),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Text("车型车长"),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return SafeArea(
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.8,
                                            child: CarPicker(
                                              carType: _carType,
                                              carLongs: _carLongs,
                                              placeCarLong: _placeCarLong,
                                              carModels: _carModels,
                                              onChanged: (carType, carLongs,
                                                  placeCarLong, carModels) {
                                                setState(() {
                                                  this._carType = carType;
                                                  this._carLongs = carLongs;
                                                  this._placeCarLong =
                                                      placeCarLong;
                                                  this._carModels = carModels;
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        height: 48,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          carMsg.isEmpty
                                              ? "必填 请选择车型车长"
                                              : carMsg,
                                          style: TextStyle(
                                              color: carMsg.isEmpty
                                                  ? Colors.grey
                                                  : Colors.black,
                                              fontWeight: carMsg.isEmpty
                                                  ? FontWeight.normal
                                                  : FontWeight.bold,
                                              fontSize:
                                                  carMsg.isEmpty ? 12 : 14),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Text("几装几卸"),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return SafeArea(
                                          child: Container(
                                            height: 200,
                                            child: LoadUnloadPicker(
                                              loadUnload: _loadUnload,
                                              onChanged: (loadUnload) {
                                                setState(() {
                                                  this._loadUnload = loadUnload;
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        height: 48,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _loadUnload,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ))
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: MaterialButton(
                    color: Theme.of(context).primaryColor,
                    minWidth: MediaQuery.of(context).size.width - 32,
                    onPressed: () => {_onConfirm()},
                    child: Text(
                      "发货",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  _buildAddress() {
    List<Widget> widgets = [];
    widgets.add(Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            height: 20,
            width: 20,
            alignment: Alignment.center,
            child: Text(
              "装",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                },
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 44,
                    child: _buildAddressText(
                        "请输入装货地", _loadProvince, _loadCity, _loadDistrict),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                InkWell(
                  onTap: () {
                    if (_loadProvince == null ||
                        _loadCity == null ||
                        _loadDistrict == null) {
                      Toast.show("请选择装货地");
                      return;
                    }
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return DeliverAddressInput(_loadProvince, _loadCity,
                          _loadDistrict, "装货地", _loadAddress, _loadPoint);
                    })).then((value) {
                      if (value != null && value is List) {
                        setState(() {
                          this._loadAddress = value[0];
                          this._loadPoint = value[1];
                        });
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 44,
                    child: Text(
                      (this._loadAddress == "") ? "请输入详细地址" : this._loadAddress,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          )),
          AnimatedOpacity(
              duration: Duration(milliseconds: 0),
              opacity: _isWayLoadShow ? 0 : 1,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _isWayLoadShow = true;
                  });
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey,
                ),
              )),
        ],
      ),
    ));
    widgets.add(Divider(
      height: 1,
    ));
    if (this._isWayLoadShow) {
      widgets.add(Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              child: ClipOval(
                child: Container(
                  color: Theme.of(context).primaryColor,
                  height: 8,
                  width: 8,
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return SafeArea(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                child: CityPicker(
                                  title: "选择途经装货地",
                                  province: _loadWayProvince,
                                  city: _loadWayCity,
                                  district: _loadWayDistrict,
                                  onChanged: (province, city, district) {
                                    setState(() {
                                      this._loadWayProvince = province;
                                      this._loadWayCity = city;
                                      this._loadWayDistrict = district;
                                    });
                                  },
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 44,
                      child: _buildAddressText("请输入途经装货地", _loadWayProvince,
                          _loadWayCity, _loadWayDistrict),
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      if (_loadWayProvince == null ||
                          _loadWayCity == null ||
                          _loadWayDistrict == null) {
                        Toast.show("请选择途经装货地");
                        return;
                      }
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return DeliverAddressInput(
                            _loadWayProvince,
                            _loadWayCity,
                            _loadWayDistrict,
                            "装货地",
                            _loadWayAddress,
                            _loadWayPoint);
                      })).then((value) {
                        if (value != null && value is List) {
                          setState(() {
                            this._loadWayAddress = value[0];
                            this._loadWayPoint = value[1];
                          });
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 44,
                      child: Text(
                        (this._loadWayAddress == "")
                            ? "请输入详细地址"
                            : this._loadWayAddress,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            )),
            IconButton(
              onPressed: () {
                setState(() {
                  this._isWayLoadShow = false;
                });
              },
              icon: Icon(
                Icons.remove_circle_outline,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ));
      widgets.add(Divider(
        height: 1,
      ));
    }
    if (this._isSubUploadShow) {
      widgets.add(Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              child: ClipOval(
                child: Container(
                  color: Colors.blueAccent,
                  height: 8,
                  width: 8,
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return SafeArea(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                child: CityPicker(
                                  title: "选择途经卸货地",
                                  province: _uploadWayProvince,
                                  city: _uploadWayCity,
                                  district: _uploadWayDistrict,
                                  onChanged: (province, city, district) {
                                    setState(() {
                                      this._uploadWayProvince = province;
                                      this._uploadWayCity = city;
                                      this._uploadWayDistrict = district;
                                    });
                                  },
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 44,
                      child: _buildAddressText("请输入途经卸货地", _uploadWayProvince,
                          _uploadWayCity, _uploadWayDistrict),
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  InkWell(
                    onTap: () {
                      if (_uploadWayProvince == null ||
                          _uploadWayCity == null ||
                          _uploadWayDistrict == null) {
                        Toast.show("请选择途经卸货地");
                        return;
                      }
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return DeliverAddressInput(
                            _uploadWayProvince,
                            _uploadWayCity,
                            _uploadWayDistrict,
                            "装货地",
                            _uploadWayAddress,
                            _uploadWayPoint);
                      })).then((value) {
                        if (value != null && value is List) {
                          setState(() {
                            this._uploadWayAddress = value[0];
                            this._uploadWayPoint = value[1];
                          });
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 44,
                      child: Text(
                        (this._uploadWayAddress == "")
                            ? "请输入详细地址"
                            : this._uploadWayAddress,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            )),
            IconButton(
              onPressed: () {
                setState(() {
                  this._isSubUploadShow = false;
                });
              },
              icon: Icon(
                Icons.remove_circle_outline,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ));
      widgets.add(Divider(
        height: 1,
      ));
    }
    widgets.add(Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            color: Colors.blueAccent,
            height: 20,
            width: 20,
            alignment: Alignment.center,
            child: Text(
              "卸",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                },
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 44,
                    child: _buildAddressText("请输入卸货地", _uploadProvince,
                        _uploadCity, _uploadDistrict),
                  ),
                ),
                Divider(
                  height: 1,
                ),
                InkWell(
                  onTap: () {
                    if (_uploadProvince == null ||
                        _uploadCity == null ||
                        _uploadDistrict == null) {
                      Toast.show("请选择装卸地");
                      return;
                    }
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return DeliverAddressInput(_uploadProvince, _uploadCity,
                          _uploadDistrict, "卸货地", _uploadAddress, _uploadPoint);
                    })).then((value) {
                      if (value != null && value is List) {
                        setState(() {
                          this._uploadAddress = value[0];
                          this._uploadPoint = value[1];
                        });
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 44,
                    child: Text(
                      (this._uploadAddress == "")
                          ? "请输入详细地址"
                          : this._uploadAddress,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          )),
          AnimatedOpacity(
              duration: Duration(milliseconds: 0),
              opacity: _isSubUploadShow ? 0 : 1,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _isSubUploadShow = true;
                  });
                },
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey,
                ),
              )),
        ],
      ),
    ));
    return widgets;
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
    );
  }
}
