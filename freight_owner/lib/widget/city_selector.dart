import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/global.dart';
import 'package:freightowner/model/area_entity.dart';
import 'package:freightowner/widget/select_button.dart';

class CitySelector extends StatefulWidget {
  final AreaEntity province;
  final AreaEntity city;
  final AreaEntity district;

  final Function onChanged;

  CitySelector(
      {Key key, this.province, this.city, this.district, this.onChanged})
      : super(key: key);

  @override
  _CitySelectorState createState() => _CitySelectorState();
}

class _CitySelectorState extends State<CitySelector> {
  AreaEntity _province;
  AreaEntity _city;
  AreaEntity _district;

  int _level = 0;

  @override
  void initState() {
    if (widget.district != null) {
      _district = widget.district;
      _city = widget.city;
      _province = widget.province;
      _level = 2;
    } else if (widget.city != null) {
      _city = widget.city;
      _province = widget.province;
      if (_province.label.endsWith("市")) {
        _city = null;
        _level = 0;
      }else{
        _level =1;
      }
    }else if(widget.province != null){
      _level = 0;
      _province = widget.province;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> topWidgets = [];
    topWidgets.add(Text(
      "选择: ${_level == 0 ? "全国" : _level == 1 ? _province.label : _level == 2 ? _city.label : ""}",
      style: TextStyle(fontSize: 14),
    ));
    if (_level != 0) {
      topWidgets.add(InkWell(
        onTap: () {
          if (_level == 2) {
            if (_province.label.endsWith("市")) {
              _level = 0;
              _city = null;
              _district = null;
            } else {
              _level = 1;
              _district = null;
            }
          } else if (_level == 1) {
            _level = 0;
            _city = null;
          }
          setState(() {});
        },
        child: Text(
          "返回上级",
          style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
        ),
      ));
    }
    return Column(
      children: <Widget>[
        InkWell(
            onTap: () => {},
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: topWidgets,
                ),
              ),
            )),
        InkWell(
          onTap: () => {},
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (c, i) {
                  AreaEntity item;
                  if (_level == 0) {
                    if (i == 0) {
                      item = AreaEntity();
                      item.label = "全国";
                    } else {
                      item = Global.areas[i - 1];
                    }
                  } else if (_level == 1) {
                    if (i == 0) {
                      item = AreaEntity();
                      item.label = "全省";
                    } else {
                      item = _province.children[i - 1];
                    }
                  } else {
                    if (i == 0) {
                      item = AreaEntity();
                      item.label = "全市";
                    } else {
                      item = _city.children[i - 1];
                    }
                  }
                  return SelectButton(
                    text: "${item.label}",
                    onTap: () {
                      if (_level == 0) {
                        _province = item;
                        if (i == 0) {
                          widget.onChanged(null, null, null);
                        } else {
                          if (_province.label.endsWith("市")) {
                            //直辖市处理
                            _level = 2;
                            _city = _province.children[0];
                          } else {
                            _level = 1;
                          }
                        }
                      } else if (_level == 1) {
                        _city = item;
                        if (i == 0) {
                          widget.onChanged(_province, null, null);
                        } else {
                          _level = 2;
                        }
                      } else {
                        _district = item;
                        if (i == 0) {
                          widget.onChanged(_province, _city, null);
                        } else {
                          widget.onChanged(_province, _city, _district);
                        }
                      }
                      setState(() {});
                    },
                    isSelected: (_level == 0 &&
                            _province != null &&
                            _province.value == item.value
                        ? true
                        : _level == 1 &&
                                _city != null &&
                                _city.value == item.value
                            ? true
                            : _level == 2 &&
                                    _district != null &&
                                    _district.value == item.value
                                ? true
                                : false),
                  );
                },
                itemCount: (_level == 0
                        ? Global.areas.length
                        : _level == 1
                            ? _province.children.length
                            : _level == 2 ? _city.children.length : 0) +
                    1,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8),
              ),
            ),
          ),
        )
      ],
    );
  }
}
