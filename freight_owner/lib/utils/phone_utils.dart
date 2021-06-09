import 'package:freightowner/http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneUtils{


  static call(mobile,toUserId,goodsId) async {
    bool isCall = await launch("tel://$mobile");
    if (isCall) {
      HttpManager.getInstance().post("/api/v1/calls", data: {
        "toUserId": toUserId,
        "goodsId": goodsId,
        "type": false
      });
    }
  }
}