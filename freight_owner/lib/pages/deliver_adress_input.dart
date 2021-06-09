import 'package:amap_search_fluttify/amap_search_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:freightowner/model/area_entity.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

class DeliverAddressInput extends StatefulWidget {
  final AreaEntity province;
  final AreaEntity city;
  final AreaEntity district;
  final String title;
  final String address;
  final Poi point;

  DeliverAddressInput(this.province, this.city, this.district, this.title,
      this.address, this.point);

  @override
  _DeliverAddressInputState createState() => _DeliverAddressInputState();
}

class _DeliverAddressInputState extends State<DeliverAddressInput>
    with AmapSearchDisposeMixin {
  TextEditingController _textController;

  List<Poi> _results = [];
  Poi _currentPoi;
  FocusNode _addressNode = FocusNode();
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(actions: [
      KeyboardActionsItem(focusNode: _addressNode),
    ], nextFocus: false);
  }

  @override
  void initState() {
    _textController = TextEditingController();
    _textController.text  = widget.address;
    _currentPoi = widget.point;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: SafeArea(
          child: KeyboardActions(
        config: _buildConfig(context),
        autoScroll: false,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("详细地址"),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: _addressNode,
                      controller: _textController,
                      minLines: 3,
                      maxLines: 3,
                      onChanged: (value) => {fetchAddress(value)},
                      textInputAction: TextInputAction.search,
                      style: TextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 16),
                        contentPadding: EdgeInsets.all(0),
                        hintText: "请输入详细地址",
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  MaterialButton(
                    minWidth: 48,
                    onPressed: () {
                      _currentPoi = null;
                      _textController.text = "";
                      _results = [];
                    },
                    child: Text("清空"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  MaterialButton(
                    minWidth: 48,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context)
                          .pop([_textController.text, this._currentPoi]);
                    },
                    child: Text(
                      "确定",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              Divider(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (BuildContext context, int index) {
                    var element = _results[index];
                    return Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () {
                            _currentPoi = element;
                            _addressNode.unfocus();
                            this._textController.text =
                                "${element.cityName}${element.address}${element.title}";
                          },
                          leading: Icon(Icons.location_on),
                          title: Text(element.title),
                          subtitle: Text(
                              "${element.cityName}${element.address}"),
                        ),
                        Divider(
                          height: 1,
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  fetchAddress(String text) {
    _currentPoi = null;
    if (text == "" || text.trim() == "") {
      setState(() {
        _results = [];
      });
      return;
    }
    String msg = text;
    Future.delayed(Duration(milliseconds: 500), () {
      if (msg == _textController.text) {
        print("搜索");
        AmapSearch.instance.searchKeyword(text, city: widget.city.label).then((value) {
          print(value);
          setState(() {
            _results = value;
          });
        });
      } else {
        print("不搜索");
      }
    });
  }
}
