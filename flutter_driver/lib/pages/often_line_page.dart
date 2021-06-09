import 'package:flutter/material.dart';
import 'package:flutterdriver/model/often_line_entity.dart';
import 'package:flutterdriver/widget/often_line_picker.dart';

class OftenLinePage extends StatefulWidget {
  final bool isAdd;
  final OftenLineRecord record;

  OftenLinePage(this.isAdd, this.record);

  @override
  _OftenLinePageState createState() => _OftenLinePageState();
}

class _OftenLinePageState extends State<OftenLinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "添加常用路线",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: OftenLinePicker(widget.isAdd, widget.record, (v) {
          Navigator.of(context).pop(v);
        }),
      ),
    );
  }
}
