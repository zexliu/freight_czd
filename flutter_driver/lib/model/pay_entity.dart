import 'package:flutterdriver/generated/json/base/json_convert_content.dart';

class PayEntity with JsonConvert<PayEntity> {
	String appId;
	String timeStamp;
	String nonceStr;
	String signType;
	String paySign;
	String prepayId;
	String package;
}
