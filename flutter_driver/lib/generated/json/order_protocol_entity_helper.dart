import 'package:flutterdriver/model/order_protocol_entity.dart';

orderProtocolEntityFromJson(OrderProtocolEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['orderId'] != null) {
		data.orderId = json['orderId']?.toString();
	}
	if (json['amount'] != null) {
		data.amount = json['amount']?.toDouble();
	}
	if (json['freightAmount'] != null) {
		data.freightAmount = json['freightAmount']?.toDouble();
	}
	if (json['loadStartAt'] != null) {
		data.loadStartAt = json['loadStartAt']?.toInt();
	}
	if (json['loadEndAt'] != null) {
		data.loadEndAt = json['loadEndAt']?.toInt();
	}
	if (json['unloadStartAt'] != null) {
		data.unloadStartAt = json['unloadStartAt']?.toInt();
	}
	if (json['unloadEndAt'] != null) {
		data.unloadEndAt = json['unloadEndAt']?.toInt();
	}
	if (json['loadProvinceCode'] != null) {
		data.loadProvinceCode = json['loadProvinceCode']?.toString();
	}
	if (json['loadCityCode'] != null) {
		data.loadCityCode = json['loadCityCode']?.toString();
	}
	if (json['loadDistrictCode'] != null) {
		data.loadDistrictCode = json['loadDistrictCode']?.toString();
	}
	if (json['unloadProvinceCode'] != null) {
		data.unloadProvinceCode = json['unloadProvinceCode']?.toString();
	}
	if (json['unloadCityCode'] != null) {
		data.unloadCityCode = json['unloadCityCode']?.toString();
	}
	if (json['unloadDistrictCode'] != null) {
		data.unloadDistrictCode = json['unloadDistrictCode']?.toString();
	}
	if (json['loadAddress'] != null) {
		data.loadAddress = json['loadAddress']?.toString();
	}
	if (json['unloadAddress'] != null) {
		data.unloadAddress = json['unloadAddress']?.toString();
	}
	if (json['categoryName'] != null) {
		data.categoryName = json['categoryName']?.toString();
	}
	if (json['carType'] != null) {
		data.carType = json['carType']?.toString();
	}
	if (json['carLongs'] != null) {
		data.carLongs = json['carLongs']?.toString();
	}
	if (json['carModels'] != null) {
		data.carModels = json['carModels']?.toString();
	}
	if (json['weight'] != null) {
		data.weight = json['weight']?.toString();
	}
	if (json['volume'] != null) {
		data.volume = json['volume']?.toString();
	}
	if (json['payDays'] != null) {
		data.payDays = json['payDays']?.toInt();
	}
	if (json['plateNumber'] != null) {
		data.plateNumber = json['plateNumber']?.toString();
	}
	if (json['driverAgree'] != null) {
		data.driverAgree = json['driverAgree'];
	}
	if (json['userAgree'] != null) {
		data.userAgree = json['userAgree'];
	}
	return data;
}

Map<String, dynamic> orderProtocolEntityToJson(OrderProtocolEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['orderId'] = entity.orderId;
	data['amount'] = entity.amount;
	data['freightAmount'] = entity.freightAmount;
	data['loadStartAt'] = entity.loadStartAt;
	data['loadEndAt'] = entity.loadEndAt;
	data['unloadStartAt'] = entity.unloadStartAt;
	data['unloadEndAt'] = entity.unloadEndAt;
	data['loadProvinceCode'] = entity.loadProvinceCode;
	data['loadCityCode'] = entity.loadCityCode;
	data['loadDistrictCode'] = entity.loadDistrictCode;
	data['unloadProvinceCode'] = entity.unloadProvinceCode;
	data['unloadCityCode'] = entity.unloadCityCode;
	data['unloadDistrictCode'] = entity.unloadDistrictCode;
	data['loadAddress'] = entity.loadAddress;
	data['unloadAddress'] = entity.unloadAddress;
	data['categoryName'] = entity.categoryName;
	data['carType'] = entity.carType;
	data['carLongs'] = entity.carLongs;
	data['carModels'] = entity.carModels;
	data['weight'] = entity.weight;
	data['volume'] = entity.volume;
	data['payDays'] = entity.payDays;
	data['plateNumber'] = entity.plateNumber;
	data['driverAgree'] = entity.driverAgree;
	data['userAgree'] = entity.userAgree;
	return data;
}