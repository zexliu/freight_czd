import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterdriver/global.dart';
import 'package:flutterdriver/http/http.dart';
import 'package:flutterdriver/pages/authentication_page2.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneUtils{


  static call(context,mobile,toUserId,goodsId) async {

    if(Global.isAuthenticated()){
      bool isCall = await launch("tel://$mobile");
      if (isCall) {
        HttpManager.getInstance().post("/api/v1/calls", data: {
          "toUserId": toUserId,
          "goodsId": goodsId,
          "type": true
        });
      }
    }else{
      Navigator.of(context).push(MaterialPageRoute(builder: (c){
        return AuthenticationPage2();
      }));
    }
  }
}