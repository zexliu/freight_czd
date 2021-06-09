import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterdriver/model/area_entity.dart';

import '../global.dart';

class CityPicker extends StatefulWidget {
  //省
  final AreaEntity province;

  //市
  final AreaEntity city;

  //区]
  final AreaEntity district;

  final String title;

  final Function onChanged;

  CityPicker(
      {Key key,
        @required this.onChanged,
        this.title,
        this.province,
        this.city,
        this.district})
      : super(key: key);

  @override
  _CityPickerState createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  List<AreaEntity> _provinces = Global.areas;
  List<AreaEntity> _cities;

  List<AreaEntity> _districts;

  AreaEntity _currentProvince;
  AreaEntity _currentCity;
  AreaEntity _currentDistrict;

//  TextEditingController _searchController;

  @override
  void initState() {
//    _searchController = TextEditingController();
    _initData();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MaterialButton(
              onPressed: () => {Navigator.pop(context)},
              child: Text("取消"),
              minWidth: 48,
            ),
            Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  widget.onChanged(this._currentProvince,this._currentCity,this._currentDistrict);
                });
              },
              child: Text(
                "确定",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              minWidth: 48,
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
//        Theme(
//          data: ThemeData(primaryColor: Colors.grey),
//          child: TextField(
//            controller: _searchController,
//            onSubmitted: (value) => {print("submitted" + value)},
//            textInputAction: TextInputAction.search,
//            style: TextStyle(fontSize: 12),
//            decoration: InputDecoration(
//              hintStyle: TextStyle(fontSize: 12),
//              contentPadding: EdgeInsets.all(0),
//              prefixIcon: Icon(Icons.search),
//              suffixIcon: InkWell(
//                onTap: () => {_searchController.clear()},
//                child: Icon(Icons.clear),
//              ),
//              hintText: "搜索城市名称",
//              border: OutlineInputBorder(borderSide: BorderSide.none),
//              fillColor: Colors.grey.shade200,
//              filled: true,
//            ),
//          ),
//        ),
//        SizedBox(
//          height: 10,
//        ),
        Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: Global.areas.length,
                      itemBuilder: (BuildContext context, int index) {
                        var  area = _provinces[index];
                        return InkWell(
                          onTap: () {
                            _onProvinceTap(area);
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: area.value == _currentProvince.value
                                  ? Colors.white
                                  : Colors.grey.shade200,
                            ),
                            child: Text(
                              area.label,
                              maxLines: 1,
                              style: TextStyle(
                                  color: area.value == _currentProvince.value
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey),
                            ),
                          ),
                        );
                      }),
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _cities.length,
                      itemBuilder: (BuildContext context, int index) {
                        var area = _cities[index];
                        return InkWell(
                          onTap: () {
                            _onCityTap(area);
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              area.label,
                              maxLines: 1,
                              style: TextStyle(
                                  color: area == _currentCity
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey),
                            ),
                          ),
                        );
                      }),
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _districts.length,
                      itemBuilder: (BuildContext context, int index) {
                        var area = _districts[index];
                        return InkWell(

                          onTap: () {
                            Navigator.pop(context);
                            this._currentDistrict = area;
                            widget.onChanged(this._currentProvince,this._currentCity,this._currentDistrict);

                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              area.label,
                              maxLines: 1,
                              style: TextStyle(
                                  color: area == _currentDistrict
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            )),

//        Container(
//          child: Row(
//            children: <Widget>[
//              Icon(Icons.search),
//
//            ],
//          ),
//        )
      ],
    );
  }

  void _initData() {
    if (widget.province == null) {
      _currentProvince = _provinces[0];
    } else {
      _provinces.forEach((element) {
        if (widget.province.value == element.value) {
          _currentProvince = element;
        }
      });
      if (_currentProvince == null) {
        _currentProvince = _provinces[0];
      }
    }
    _cities = _currentProvince.children;

    if (widget.city == null) {
      _currentCity = _cities[0];
    } else {
      _cities.forEach((element) {
        if (widget.city.value == element.value) {
          _currentCity = element;
        }
      });
      if (_currentCity == null) {
        _currentCity = _cities[0];
      }
    }
    _districts = _currentCity.children;

    if (widget.district == null) {
      _currentDistrict = _districts[0];
    } else {
      _districts.forEach((element) {
        if (widget.district.value == element.value) {
          _currentDistrict = element;
        }
      });
      if (_currentDistrict == null) {
        _currentDistrict = _districts[0];
      }
    }
  }

  void _onProvinceTap(AreaEntity area) {
    if(area == _currentProvince){
      return;
    }
    setState(() {
      _currentProvince = area;
      _cities = _currentProvince.children;
      _currentCity = _cities[0];
      _districts = _currentCity.children;
      _currentDistrict = _districts[0];
    });
  }

  void _onCityTap(AreaEntity area) {
    if(area == _currentCity){
      return;
    }
    setState(() {
      _currentCity = area;
      _districts = _currentCity.children;
      _currentDistrict = _districts[0];
    });
  }
}
