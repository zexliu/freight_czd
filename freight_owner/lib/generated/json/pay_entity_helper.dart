import 'package:freightowner/model/pay_entity.dart';

payEntityFromJson(PayEntity data, Map<String, dynamic> json) {
	if (json['appId'] != null) {
		data.appId = json['appId']?.toString();
	}
	if (json['timeStamp'] != null) {
		data.timeStamp = json['timeStamp']?.toString();
	}
	if (json['nonceStr'] != null) {
		data.nonceStr = json['nonceStr']?.toString();
	}
	if (json['signType'] != null) {
		data.signType = json['signType']?.toString();
	}
	if (json['paySign'] != null) {
		data.paySign = json['paySign']?.toString();
	}
	if (json['prepayId'] != null) {
		data.prepayId = json['prepayId']?.toString();
	}
	if (json['package'] != null) {
		data.package = json['package']?.toString();
	}
	return data;
}

Map<String, dynamic> payEntityToJson(PayEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['appId'] = entity.appId;
	data['timeStamp'] = entity.timeStamp;
	data['nonceStr'] = entity.nonceStr;
	data['signType'] = entity.signType;
	data['paySign'] = entity.paySign;
	data['prepayId'] = entity.prepayId;
	data['package'] = entity.package;
	return data;
}