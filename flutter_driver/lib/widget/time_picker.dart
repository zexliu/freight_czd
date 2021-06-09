import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutterdriver/utils/list_extension.dart';

class TimePicker extends StatefulWidget {
  final CustomDate dayTime;
  final CustomDate rangTime;
  final CustomDate itemTime;
  final Function onChanged;
  final bool isMore;

  TimePicker(
      {Key key,
      this.dayTime,
      this.rangTime,
      this.itemTime,
      this.onChanged,
      this.isMore = false})
      : super(key: key);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  FixedExtentScrollController _controller1 = new FixedExtentScrollController();
  FixedExtentScrollController _controller2 = new FixedExtentScrollController();
  FixedExtentScrollController _controller3 = new FixedExtentScrollController();

  var _dateFormat = DateFormat('yyyy-MM-dd');
  var _zhDateFormat = DateFormat('MM月dd日');

  bool _firstIn = true;
  int _index1 = 0;
  int _index2 = 0;
  int _index3 = 0;

  List<CustomDate> _customDates1 = [];
  List<CustomDate> _customDates2 = [];
  List<CustomDate> _customDates3 = [];

  @override
  void initState() {
    DateTime now = DateTime.now();

    _customDates1.add(CustomDate(title: "今天", date: _dateFormat.format(now)));
    _customDates1
        .add(CustomDate(title: "今天或明天", date: _dateFormat.format(now)));
    _customDates1.add(CustomDate(
        title: "明天", date: _dateFormat.format(now.add(Duration(days: 1)))));
    _customDates1.add(CustomDate(
        title: _zhDateFormat.format(now.add(Duration(days: 2))),
        date: _dateFormat.format(now.add(Duration(days: 2)))));
    _customDates1.add(CustomDate(
        title: _zhDateFormat.format(now.add(Duration(days: 3))),
        date: _dateFormat.format(now.add(Duration(days: 3)))));
    _customDates1.add(CustomDate(
        title: _zhDateFormat.format(now.add(Duration(days: 4))),
        date: _dateFormat.format(now.add(Duration(days: 4)))));
    _customDates1.add(CustomDate(
        title: _zhDateFormat.format(now.add(Duration(days: 5))),
        date: _dateFormat.format(now.add(Duration(days: 5)))));
    _customDates1.add(CustomDate(
        title: _zhDateFormat.format(now.add(Duration(days: 6))),
        date: _dateFormat.format(now.add(Duration(days: 6)))));

    if (widget.isMore) {
      _customDates1.add(CustomDate(
          title: _zhDateFormat.format(now.add(Duration(days: 7))),
          date: _dateFormat.format(now.add(Duration(days: 7)))));
      _customDates1.add(CustomDate(
          title: _zhDateFormat.format(now.add(Duration(days: 8))),
          date: _dateFormat.format(now.add(Duration(days: 8)))));
      _customDates1.add(CustomDate(
          title: _zhDateFormat.format(now.add(Duration(days: 9))),
          date: _dateFormat.format(now.add(Duration(days: 9)))));
      _customDates1.add(CustomDate(
          title: _zhDateFormat.format(now.add(Duration(days: 10))),
          date: _dateFormat.format(now.add(Duration(days: 10)))));
      _customDates1.add(CustomDate(
          title: _zhDateFormat.format(now.add(Duration(days: 11))),
          date: _dateFormat.format(now.add(Duration(days: 11)))));
      _customDates1.add(CustomDate(
          title: _zhDateFormat.format(now.add(Duration(days: 12))),
          date: _dateFormat.format(now.add(Duration(days: 12)))));
      _customDates1.add(CustomDate(
          title: _zhDateFormat.format(now.add(Duration(days: 13))),
          date: _dateFormat.format(now.add(Duration(days: 13)))));
    }
    _customDates1.forEach((element) {
      element.children = [];
      element.children.add(CustomDate(title: "全天"));
      if (!(element.title == "今天" &&
              now.isAfter(DateTime(
                now.year,
                now.month,
                now.day,
                6,
              ))) &&
          element.title != "今天或明天") {
        element.children.add(CustomDate(title: "凌晨"));
      }
      if (!(element.title == "今天" &&
              now.isAfter(DateTime(
                now.year,
                now.month,
                now.day,
                12,
              ))) &&
          element.title != "今天或明天") {
        element.children.add(CustomDate(title: "上午"));
      }
      if (!(element.title == "今天" &&
              now.isAfter(DateTime(
                now.year,
                now.month,
                now.day,
                18,
              ))) &&
          element.title != "今天或明天") {
        element.children.add(CustomDate(title: "下午"));
      }
      if (!(element.title == "今天" &&
              now.isAfter(DateTime(
                now.year,
                now.month,
                now.day,
                24,
              ))) &&
          element.title != "今天或明天") {
        element.children.add(CustomDate(title: "晚上"));
      }

      element.children.forEach((item) {
        item.children = [];
        if (item.title == "全天") {
          item.children.add(
              CustomDate(title: "都可以", startAt: "00:00:00", endAt: "23:59:59"));
        } else if (item.title == "凌晨") {
          item.children.add(
              CustomDate(title: "都可以", startAt: "00:00:00", endAt: "05:59:59"));
          var end = 6;
          int startIndex = 0;
          if (element.title == "今天") {
            Duration duration = now.difference(DateTime(
              now.year,
              now.month,
              now.day,
              6,
            ));
            startIndex = -duration.inHours + 1;
            if (startIndex >= 6) {
              startIndex = 0;
            }
          }
          for (int i = startIndex + 0; i < end; i++) {
            item.children.add(CustomDate(
                title: "$i:00", startAt: "0$i:00:00", endAt: "0$i:00:59"));
          }
        }

        if (item.title == "上午") {
          item.children.add(
              CustomDate(title: "都可以", startAt: "06:00:00", endAt: "11:59:59"));
          var end = 12;
          int startIndex = 0;

          if (element.title == "今天") {
            Duration duration = now.difference(DateTime(
              now.year,
              now.month,
              now.day,
              12,
            ));
            startIndex = -duration.inHours + 1;
            if (startIndex >= 6) {
              startIndex = 0;
            }
          }
          for (int i = 6 + startIndex; i < end; i++) {
            var time = i < 10 ? "0$i" : "$i";
            item.children.add(CustomDate(
                title: "$i:00", startAt: "$time:00:00", endAt: "$time:59:59"));
          }
        }

        if (item.title == "下午") {
          int startIndex = 0;
          item.children.add(
              CustomDate(title: "都可以", startAt: "12:00:00", endAt: "17:59:59"));
          var end = 18;
          if (element.title == "今天") {
            Duration duration = now.difference(DateTime(
              now.year,
              now.month,
              now.day,
              18,
            ));
            startIndex = -duration.inHours + 1;
            if (startIndex >= 6) {
              startIndex = 0;
            }
          }
          for (int i = 12 + startIndex; i < end; i++) {
            item.children.add(CustomDate(
                title: "$i:00", startAt: "$i:00:00", endAt: "$i:59:59"));
          }
        }
        if (item.title == "晚上") {
          item.children.add(
              CustomDate(title: "都可以", startAt: "18:00:00", endAt: "23:59:59"));
          var end = 24;
          int startIndex = 0;
          if (element.title == "今天") {
            Duration duration = now.difference(DateTime(
              now.year,
              now.month,
              now.day + 1,
              0,
            ));
            startIndex = -duration.inHours + 1;
            if (startIndex >= 6) {
              startIndex = 0;
            }
          }
          for (int i = 18 + startIndex; i < end; i++) {
            item.children.add(CustomDate(
                title: "$i:00", startAt: "$i:00:00", endAt: "$i:59:59"));
          }
        }
      });
    });

    if (widget.dayTime != null &&
        widget.rangTime != null &&
        widget.itemTime != null) {
      _index1 = _customDates1.indexOfFunc(widget.dayTime, (e) {
        return e.title == widget.dayTime.title;
      });
      _index2 =
          _customDates1[_index1].children.indexOfFunc(widget.rangTime, (e) {
        return e.title == widget.rangTime.title;
      });

      _index3 = _customDates1[_index1]
          .children[_index2]
          .children
          .indexOfFunc(widget.itemTime, (e) {
        return e.title == widget.itemTime.title;
      });
    }
    _customDates2 = _customDates1[_index1].children;
    _customDates3 = _customDates2[_index2].children;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller1.jumpToItem(_index1);
      _controller2.jumpToItem(_index2);
      _controller3.jumpToItem(_index3);
      _firstIn = false;
      print("$_index1 $_index2 $_index3");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              "货物信息",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            MaterialButton(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                widget.onChanged(
                    _customDates1[_index1],
                    _customDates1[_index1].children[_index2],
                    _customDates1[_index1].children[_index2].children[_index3]);
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
          child: Row(
            children: <Widget>[
              Expanded(
                child: _MyPicker(
                  key: Key("_MyPicker1"),
                  widgets: _customDates1.map((v) {
                    return Text(
                      v.title,
                      key: Key(Uuid().v1()),
                    );
                  }).toList(),
                  controller: _controller1,
                  changed: (index) {
                    setState(() {
                      if (!_firstIn) {
                        _controller2.jumpTo(0);
                        _controller3.jumpTo(0);
                        _index1 = index;
                        _index2 = 0;
                        _index3 = 0;
                        _customDates2 = _customDates1[index].children;
                        _customDates3 = _customDates2[0].children;
                      }
                    });
                  },
                ),
              ),
              Expanded(
                child: _MyPicker(
                  key: Key("_MyPicker2"),
                  widgets: _customDates2.map((v) {
                    return Text(
                      v.title,
                      key: Key(Uuid().v1()),
                    );
                  }).toList(),
                  controller: _controller2,
                  changed: (index) {
                    setState(() {
                      if (!_firstIn) {
                        _controller3.jumpTo(0);
                        _index2 = index;
                        _index3 = 0;
                        _customDates3 = _customDates2[_index2].children;
                      }
                    });
                  },
                ),
              ),
              Expanded(
                child: _MyPicker(
                  key: Key("_MyPicker3"),
                  widgets: _customDates3.map((v) {
                    return Text(
                      v.title,
                      key: Key(Uuid().v1()),
                    );
                  }).toList(),
                  controller: _controller3,
                  changed: (index) {
                    _index3 = index;
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _MyPicker extends StatefulWidget {
  final List<Widget> widgets;
  final ValueChanged<int> changed;
  final Key key;
  final FixedExtentScrollController controller;

  _MyPicker({this.widgets, this.changed, this.key, this.controller});

  @override
  State createState() {
    return new _MyPickerState();
  }
}

class _MyPickerState extends State<_MyPicker> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new CupertinoPicker(
        key: widget.key,
        scrollController: widget.controller,
        itemExtent: 40.0,
        onSelectedItemChanged: (index) {
          if (widget.changed != null) {
            widget.changed(index);
          }
        },
        children:
            widget.widgets.length > 0 ? widget.widgets : [new Text('请选择')],
      ),
    );
  }
}

class CustomDate {
  String title;
  String date;
  String startAt;
  String endAt;
  List<CustomDate> children;

  CustomDate({this.title, this.date, this.startAt, this.endAt, this.children});
}
