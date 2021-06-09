import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  static void show(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        gravity: ToastGravity.CENTER,
        fontSize: 12);
  }
}
