import 'package:freightowner/model/me_statistical_entity.dart';

meStatisticalEntityFromJson(MeStatisticalEntity data, Map<String, dynamic> json) {
	if (json['transactionAmount'] != null) {
		data.transactionAmount = json['transactionAmount']?.toDouble();
	}
	if (json['deliveryCount'] != null) {
		data.deliveryCount = json['deliveryCount']?.toInt();
	}
	if (json['orderCount'] != null) {
		data.orderCount = json['orderCount']?.toInt();
	}
	return data;
}

Map<String, dynamic> meStatisticalEntityToJson(MeStatisticalEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['transactionAmount'] = entity.transactionAmount;
	data['deliveryCount'] = entity.deliveryCount;
	data['orderCount'] = entity.orderCount;
	return data;
}