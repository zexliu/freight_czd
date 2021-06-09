
import 'package:flutter/material.dart';
import 'package:loading/indicator/line_scale_pulse_out_indicator.dart';
import 'package:loading/loading.dart';

import '../global.dart';

showLoadingDialog() async {
  showDialog(context: Global.navigatorKey.currentState.overlay.context,builder: (c){
    return Center(
      child:  Container(
        width: 120.0,
        height: 120.0,
        color: Colors.black26,
        child: Stack(
          children: <Widget>[
            Center(
              child: Loading(indicator: LineScalePulseOutIndicator(), size: 60.0,color: Colors.white),
            ),
           Positioned(
             bottom: 12,
             left: 0,
             right: 0,
             child:  Center(
               child: Text("加载中...",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.normal,decoration: TextDecoration.none),),
             ),
           )
          ],
        ),
      ),
    );
  });
}

hideLoadingDialog(){
  Navigator.of(Global.navigatorKey.currentState.overlay.context).pop();
}