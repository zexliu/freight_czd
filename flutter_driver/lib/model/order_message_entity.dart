import 'package:flutterdriver/generated/json/base/json_convert_content.dart';

class OrderMessageEntity with JsonConvert<OrderMessageEntity> {
	OrderMessageResult result;
	int action;
}

class OrderMessageResult with JsonConvert<OrderMessageResult> {
	String body;
	String category;
	String messageId;
	OrderMessageResultUserInfo userInfo;
	String launchImageName;
	int badge;
	String title;
	String summaryArgument;
	OrderMessageResultExtrasMap extrasMap;
	String threadIdentifier;
	int summaryArgumentCount;
	String content;
}

class OrderMessageResultUserInfo with JsonConvert<OrderMessageResultUserInfo> {
	String carModels;
	String pushData;
	String weight;
	String volume;
	String amount;
	String title;
	bool mobpushOfflineFlag;
	String nickname;
	String loadProvinceCode;
	String loadDistrictCode;
	String unloadDistrictCode;
	int mobpushServerTimestamp;
	String mobpushMessageId;
	String loadCityCode;
	String deliveryId;
	String mobile;
	String carLongs;
	String unloadProvinceCode;
	String unloadCityCode;
	String freightAmount;
	String orderId;
}

class OrderMessageResultExtrasMap with JsonConvert<OrderMessageResultExtrasMap> {
	String carModels;
	String pushData;
	String weight;
	String volume;
	String amount;
	String title;
	bool mobpushOfflineFlag;
	String nickname;
	String loadProvinceCode;
	String loadDistrictCode;
	String unloadDistrictCode;
	int mobpushServerTimestamp;
	String mobpushMessageId;
	String loadCityCode;
	String deliveryId;
	String mobile;
	String carLongs;
	String unloadProvinceCode;
	String unloadCityCode;
	String freightAmount;
	String orderId;
}
