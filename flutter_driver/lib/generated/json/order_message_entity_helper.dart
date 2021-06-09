import 'package:flutterdriver/model/order_message_entity.dart';

orderMessageEntityFromJson(OrderMessageEntity data, Map<String, dynamic> json) {
	if (json['result'] != null) {
		data.result = new OrderMessageResult().fromJson(json['result']);
	}
	if (json['action'] != null) {
		data.action = json['action']?.toInt();
	}
	return data;
}

Map<String, dynamic> orderMessageEntityToJson(OrderMessageEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.result != null) {
		data['result'] = entity.result.toJson();
	}
	data['action'] = entity.action;
	return data;
}

orderMessageResultFromJson(OrderMessageResult data, Map<String, dynamic> json) {
	if (json['body'] != null) {
		data.body = json['body']?.toString();
	}
	if (json['category'] != null) {
		data.category = json['category']?.toString();
	}
	if (json['messageId'] != null) {
		data.messageId = json['messageId']?.toString();
	}
	if (json['userInfo'] != null) {
		data.userInfo = new OrderMessageResultUserInfo().fromJson(json['userInfo']);
	}
	if (json['launchImageName'] != null) {
		data.launchImageName = json['launchImageName']?.toString();
	}
	if (json['badge'] != null) {
		data.badge = json['badge']?.toInt();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['summaryArgument'] != null) {
		data.summaryArgument = json['summaryArgument']?.toString();
	}
	if (json['extrasMap'] != null) {
		data.extrasMap = new OrderMessageResultExtrasMap().fromJson(json['extrasMap']);
	}
	if (json['threadIdentifier'] != null) {
		data.threadIdentifier = json['threadIdentifier']?.toString();
	}
	if (json['summaryArgumentCount'] != null) {
		data.summaryArgumentCount = json['summaryArgumentCount']?.toInt();
	}
	if (json['content'] != null) {
		data.content = json['content']?.toString();
	}
	return data;
}

Map<String, dynamic> orderMessageResultToJson(OrderMessageResult entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['body'] = entity.body;
	data['category'] = entity.category;
	data['messageId'] = entity.messageId;
	if (entity.userInfo != null) {
		data['userInfo'] = entity.userInfo.toJson();
	}
	data['launchImageName'] = entity.launchImageName;
	data['badge'] = entity.badge;
	data['title'] = entity.title;
	data['summaryArgument'] = entity.summaryArgument;
	if (entity.extrasMap != null) {
		data['extrasMap'] = entity.extrasMap.toJson();
	}
	data['threadIdentifier'] = entity.threadIdentifier;
	data['summaryArgumentCount'] = entity.summaryArgumentCount;
	data['content'] = entity.content;
	return data;
}

orderMessageResultUserInfoFromJson(OrderMessageResultUserInfo data, Map<String, dynamic> json) {
	if (json['carModels'] != null) {
		data.carModels = json['carModels']?.toString();
	}
	if (json['pushData'] != null) {
		data.pushData = json['pushData']?.toString();
	}
	if (json['weight'] != null) {
		data.weight = json['weight']?.toString();
	}
	if (json['volume'] != null) {
		data.volume = json['volume']?.toString();
	}
	if (json['amount'] != null) {
		data.amount = json['amount']?.toString();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['mobpushOfflineFlag'] != null) {
		data.mobpushOfflineFlag = json['mobpushOfflineFlag'];
	}
	if (json['nickname'] != null) {
		data.nickname = json['nickname']?.toString();
	}
	if (json['loadProvinceCode'] != null) {
		data.loadProvinceCode = json['loadProvinceCode']?.toString();
	}
	if (json['loadDistrictCode'] != null) {
		data.loadDistrictCode = json['loadDistrictCode']?.toString();
	}
	if (json['unloadDistrictCode'] != null) {
		data.unloadDistrictCode = json['unloadDistrictCode']?.toString();
	}
	if (json['mobpushServerTimestamp'] != null) {
		data.mobpushServerTimestamp = json['mobpushServerTimestamp']?.toInt();
	}
	if (json['mobpushMessageId'] != null) {
		data.mobpushMessageId = json['mobpushMessageId']?.toString();
	}
	if (json['loadCityCode'] != null) {
		data.loadCityCode = json['loadCityCode']?.toString();
	}
	if (json['deliveryId'] != null) {
		data.deliveryId = json['deliveryId']?.toString();
	}
	if (json['mobile'] != null) {
		data.mobile = json['mobile']?.toString();
	}
	if (json['carLongs'] != null) {
		data.carLongs = json['carLongs']?.toString();
	}
	if (json['unloadProvinceCode'] != null) {
		data.unloadProvinceCode = json['unloadProvinceCode']?.toString();
	}
	if (json['unloadCityCode'] != null) {
		data.unloadCityCode = json['unloadCityCode']?.toString();
	}
	if (json['freightAmount'] != null) {
		data.freightAmount = json['freightAmount']?.toString();
	}
	if (json['orderId'] != null) {
		data.orderId = json['orderId']?.toString();
	}
	return data;
}

Map<String, dynamic> orderMessageResultUserInfoToJson(OrderMessageResultUserInfo entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['carModels'] = entity.carModels;
	data['pushData'] = entity.pushData;
	data['weight'] = entity.weight;
	data['volume'] = entity.volume;
	data['amount'] = entity.amount;
	data['title'] = entity.title;
	data['mobpushOfflineFlag'] = entity.mobpushOfflineFlag;
	data['nickname'] = entity.nickname;
	data['loadProvinceCode'] = entity.loadProvinceCode;
	data['loadDistrictCode'] = entity.loadDistrictCode;
	data['unloadDistrictCode'] = entity.unloadDistrictCode;
	data['mobpushServerTimestamp'] = entity.mobpushServerTimestamp;
	data['mobpushMessageId'] = entity.mobpushMessageId;
	data['loadCityCode'] = entity.loadCityCode;
	data['deliveryId'] = entity.deliveryId;
	data['mobile'] = entity.mobile;
	data['carLongs'] = entity.carLongs;
	data['unloadProvinceCode'] = entity.unloadProvinceCode;
	data['unloadCityCode'] = entity.unloadCityCode;
	data['freightAmount'] = entity.freightAmount;
	data['orderId'] = entity.orderId;
	return data;
}

orderMessageResultExtrasMapFromJson(OrderMessageResultExtrasMap data, Map<String, dynamic> json) {
	if (json['carModels'] != null) {
		data.carModels = json['carModels']?.toString();
	}
	if (json['pushData'] != null) {
		data.pushData = json['pushData']?.toString();
	}
	if (json['weight'] != null) {
		data.weight = json['weight']?.toString();
	}
	if (json['volume'] != null) {
		data.volume = json['volume']?.toString();
	}
	if (json['amount'] != null) {
		data.amount = json['amount']?.toString();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['mobpushOfflineFlag'] != null) {
		data.mobpushOfflineFlag = json['mobpushOfflineFlag'];
	}
	if (json['nickname'] != null) {
		data.nickname = json['nickname']?.toString();
	}
	if (json['loadProvinceCode'] != null) {
		data.loadProvinceCode = json['loadProvinceCode']?.toString();
	}
	if (json['loadDistrictCode'] != null) {
		data.loadDistrictCode = json['loadDistrictCode']?.toString();
	}
	if (json['unloadDistrictCode'] != null) {
		data.unloadDistrictCode = json['unloadDistrictCode']?.toString();
	}
	if (json['mobpushServerTimestamp'] != null) {
		data.mobpushServerTimestamp = json['mobpushServerTimestamp']?.toInt();
	}
	if (json['mobpushMessageId'] != null) {
		data.mobpushMessageId = json['mobpushMessageId']?.toString();
	}
	if (json['loadCityCode'] != null) {
		data.loadCityCode = json['loadCityCode']?.toString();
	}
	if (json['deliveryId'] != null) {
		data.deliveryId = json['deliveryId']?.toString();
	}
	if (json['mobile'] != null) {
		data.mobile = json['mobile']?.toString();
	}
	if (json['carLongs'] != null) {
		data.carLongs = json['carLongs']?.toString();
	}
	if (json['unloadProvinceCode'] != null) {
		data.unloadProvinceCode = json['unloadProvinceCode']?.toString();
	}
	if (json['unloadCityCode'] != null) {
		data.unloadCityCode = json['unloadCityCode']?.toString();
	}
	if (json['freightAmount'] != null) {
		data.freightAmount = json['freightAmount']?.toString();
	}
	if (json['orderId'] != null) {
		data.orderId = json['orderId']?.toString();
	}
	return data;
}

Map<String, dynamic> orderMessageResultExtrasMapToJson(OrderMessageResultExtrasMap entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['carModels'] = entity.carModels;
	data['pushData'] = entity.pushData;
	data['weight'] = entity.weight;
	data['volume'] = entity.volume;
	data['amount'] = entity.amount;
	data['title'] = entity.title;
	data['mobpushOfflineFlag'] = entity.mobpushOfflineFlag;
	data['nickname'] = entity.nickname;
	data['loadProvinceCode'] = entity.loadProvinceCode;
	data['loadDistrictCode'] = entity.loadDistrictCode;
	data['unloadDistrictCode'] = entity.unloadDistrictCode;
	data['mobpushServerTimestamp'] = entity.mobpushServerTimestamp;
	data['mobpushMessageId'] = entity.mobpushMessageId;
	data['loadCityCode'] = entity.loadCityCode;
	data['deliveryId'] = entity.deliveryId;
	data['mobile'] = entity.mobile;
	data['carLongs'] = entity.carLongs;
	data['unloadProvinceCode'] = entity.unloadProvinceCode;
	data['unloadCityCode'] = entity.unloadCityCode;
	data['freightAmount'] = entity.freightAmount;
	data['orderId'] = entity.orderId;
	return data;
}