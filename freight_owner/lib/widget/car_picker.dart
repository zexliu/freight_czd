import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/http/common.dart';
import 'package:freightowner/model/dict_entry_entity.dart';
import 'package:freightowner/utils/text_input_formatter.dart';
import 'package:freightowner/utils/toast.dart';
import 'package:freightowner/widget/select_button.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class CarPicker extends StatefulWidget {
  final String carType;
  final List<String> carLongs;
  final double placeCarLong;
  final List<String> carModels;
  final Function onChanged;

  final bool isShowPlaceCarLong;

  CarPicker(
      {Key key,
      this.carType,
      this.carLongs,
      this.placeCarLong,
      this.carModels,
      this.isShowPlaceCarLong = true,
      @required this.onChanged})
      : super(key: key);

  @override
  _CarPickerState createState() => _CarPickerState();
}

class _CarPickerState extends State<CarPicker> {
  TextEditingController _textController;
  FocusNode _textNode = FocusNode();
  List<String> _currentCarLongs;
  String _currentCarType;
  List<String> _currentCarModels;

  List<DictEntryRecord> _carLongs;
  List<DictEntryRecord> _carTypes;
  List<DictEntryRecord> _carModels;

  bool _isLoading = true;

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _textNode),
    ], nextFocus: false);
  }

  @override
  void initState() {
    _textController = TextEditingController();
    if (widget.placeCarLong != null) {
      _textController.text = widget.placeCarLong.toString();
    }
    _currentCarModels = widget.carModels;
    _currentCarLongs = widget.carLongs;
    _currentCarType = widget.carType;

    Future.wait([
      fetchDict("car_type"),
      fetchDict("car_long"),
      fetchDict("car_model")
    ]).then((list) {
      setState(() {
        _carTypes = list[0].records;
        if (_currentCarType == null && _carTypes.isNotEmpty) {
          _currentCarType = _carTypes[0].dictEntryName;
        }
        _carLongs = list[1].records;
        _carModels = list[2].records;
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildContent(),
    );
  }

  _buildContent() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                onPressed: () => {Navigator.pop(context)},
                child: Text("关闭"),
                minWidth: 48,
              ),
              Text(
                "车型车长",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (_currentCarLongs == null || _currentCarLongs.isEmpty) {
                    Toast.show("请选择车长");
                    return;
                  }
                  if (_currentCarModels == null || _currentCarModels.isEmpty) {
                    Toast.show("请选择车型");
                    return;
                  }
                  double long;
                  if (_textController.text != "") {
                    long = double.parse(_textController.text);
                  }
                  widget.onChanged(_currentCarType, _currentCarLongs, long,
                      _currentCarModels);
                  Navigator.pop(context);
                },
                child: Text(
                  "确定",
                  style: TextStyle(color: Colors.white),
                ),
                minWidth: 48,
              ),
            ],
          ),
          Expanded(
            child: KeyboardActions(
              config: _buildConfig(context),
              autoScroll: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 44,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "用车类型",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _carTypes.length,
                    itemBuilder: (BuildContext context, int position) {
                      var item = _carTypes[position];
                      return SelectButton(
                        text: item.dictEntryName,
                        isSelected: (this._currentCarType != null &&
                            this._currentCarType == item.dictEntryName),
                        onTap: () {
                          setState(() {
                            this._currentCarType = item.dictEntryName;
                          });
                        },
                      );
                    },
                  ),
                  Container(
                    height: 44,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Text(
                          "车长",
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "(必填,最多3项)",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _carLongs.length,
                    itemBuilder: (BuildContext context, int position) {
                      var item = _carLongs[position];
                      String find = _currentCarLongs.firstWhere((element) {
                        return element == item.dictEntryName;
                      }, orElse: () {
                        return null;
                      });
                      return SelectButton(
                        text: item.dictEntryName,
                        isSelected: find != null,
                        onTap: () {
                          setState(() {
                            if (find != null) {
                              _currentCarLongs.remove(find);
                            } else {
                              if (_currentCarLongs.length < 3) {
                                _currentCarLongs.add(item.dictEntryName);
                              }
                            }
                          });
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: widget.isShowPlaceCarLong,
                    child: Row(
                      children: <Widget>[
                        Text("占用车长 (米)"),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            focusNode: _textNode,
                            textAlign: TextAlign.right,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              hintText: "0~20",
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              isDense: true,
                              contentPadding: EdgeInsets.all(8),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(fontSize: 12),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9.]")), //只输入数字
                              UsNumberTextInputFormatter(), //只输入数字
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 44,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Text(
                          "车型",
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "(必填,最多3项)",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _carModels.length,
                    itemBuilder: (BuildContext context, int position) {
                      var item = _carModels[position];
                      String find = _currentCarModels.firstWhere((element) {
                        return element == item.dictEntryName;
                      }, orElse: () {
                        return null;
                      });
                      return SelectButton(
                        text: item.dictEntryName,
                        isSelected: find != null,
                        onTap: () {
                          setState(() {
                            if (find != null) {
                              _currentCarModels.remove(find);
                            } else {
                              if (_currentCarModels.length < 3) {
                                _currentCarModels.add(item.dictEntryName);
                              }
                            }
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
