import 'package:flutterdriver/model/me_statistical_entity.dart';

meStatisticalEntityFromJson(MeStatisticalEntity data, Map<String, dynamic> json) {
	if (json['transactionAmount'] != null) {
		data.transactionAmount = json['transactionAmount']?.toDouble();
	}
	if (json['carLong'] != null) {
		data.carLong = json['carLong']?.toString();
	}
	if (json['carModel'] != null) {
		data.carModel = json['carModel']?.toString();
	}
	return data;
}

Map<String, dynamic> meStatisticalEntityToJson(MeStatisticalEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['transactionAmount'] = entity.transactionAmount;
	data['carLong'] = entity.carLong;
	data['carModel'] = entity.carModel;
	return data;
}