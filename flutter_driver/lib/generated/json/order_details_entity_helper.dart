import 'package:flutterdriver/model/order_details_entity.dart';

orderDetailsEntityFromJson(OrderDetailsEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['deliveryId'] != null) {
		data.deliveryId = json['deliveryId']?.toString();
	}
	if (json['userId'] != null) {
		data.userId = json['userId']?.toString();
	}
	if (json['driverId'] != null) {
		data.driverId = json['driverId']?.toString();
	}
	if (json['amount'] != null) {
		data.amount = json['amount']?.toDouble();
	}
	if (json['freightAmount'] != null) {
		data.freightAmount = json['freightAmount']?.toDouble();
	}
	if (json['confirmStatus'] != null) {
		data.confirmStatus = json['confirmStatus'];
	}
	if (json['transportStatus'] != null) {
		data.transportStatus = json['transportStatus'];
	}
	if (json['payStatus'] != null) {
		data.payStatus = json['payStatus'];
	}
	if (json['evaluateStatus'] != null) {
		data.evaluateStatus = json['evaluateStatus'];
	}
	if (json['driverEvaluateStatus'] != null) {
		data.driverEvaluateStatus = json['driverEvaluateStatus'];
	}
	if (json['cancelStatus'] != null) {
		data.cancelStatus = json['cancelStatus'];
	}
	if (json['refundStatus'] != null) {
		data.refundStatus = json['refundStatus'];
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
	if (json['loadAddress'] != null) {
		data.loadAddress = json['loadAddress']?.toString();
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
	if (json['unloadAddress'] != null) {
		data.unloadAddress = json['unloadAddress']?.toString();
	}
	if (json['categoryName'] != null) {
		data.categoryName = json['categoryName']?.toString();
	}
	if (json['weight'] != null) {
		data.weight = json['weight']?.toString();
	}
	if (json['volume'] != null) {
		data.volume = json['volume']?.toString();
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
	if (json['loadUnload'] != null) {
		data.loadUnload = json['loadUnload']?.toString();
	}
	if (json['loadStartAt'] != null) {
		data.loadStartAt = json['loadStartAt']?.toInt();
	}
	if (json['loadEndAt'] != null) {
		data.loadEndAt = json['loadEndAt']?.toInt();
	}
	if (json['remark'] != null) {
		data.remark = json['remark']?.toString();
	}
	if (json['requireList'] != null) {
		data.requireList = json['requireList']?.toString();
	}
	if (json['createAt'] != null) {
		data.createAt = json['createAt']?.toInt();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toInt();
	}
	if (json['deleteStatus'] != null) {
		data.deleteStatus = json['deleteStatus']?.toInt();
	}
	if (json['markStatus'] != null) {
		data.markStatus = json['markStatus']?.toInt();
	}
	if (json['packageMode'] != null) {
		data.packageMode = json['packageMode']?.toString();
	}
	if (json['driverAvatar'] != null) {
		data.driverAvatar = json['driverAvatar']?.toString();
	}
	if (json['driverName'] != null) {
		data.driverName = json['driverName']?.toString();
	}
	if (json['driverMobile'] != null) {
		data.driverMobile = json['driverMobile']?.toString();
	}
	if (json['userAvatar'] != null) {
		data.userAvatar = json['userAvatar']?.toString();
	}
	if (json['userName'] != null) {
		data.userName = json['userName']?.toString();
	}
	if (json['companyName'] != null) {
		data.companyName = json['companyName']?.toString();
	}
	if (json['userMobile'] != null) {
		data.userMobile = json['userMobile']?.toString();
	}
	if (json['protocolStatus'] != null) {
		data.protocolStatus = json['protocolStatus']?.toInt();
	}
	if (json['driverPayStatus'] != null) {
		data.driverPayStatus = json['driverPayStatus'];
	}
	return data;
}

Map<String, dynamic> orderDetailsEntityToJson(OrderDetailsEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['deliveryId'] = entity.deliveryId;
	data['userId'] = entity.userId;
	data['driverId'] = entity.driverId;
	data['amount'] = entity.amount;
	data['freightAmount'] = entity.freightAmount;
	data['confirmStatus'] = entity.confirmStatus;
	data['transportStatus'] = entity.transportStatus;
	data['payStatus'] = entity.payStatus;
	data['evaluateStatus'] = entity.evaluateStatus;
	data['driverEvaluateStatus'] = entity.driverEvaluateStatus;
	data['cancelStatus'] = entity.cancelStatus;
	data['refundStatus'] = entity.refundStatus;
	data['loadProvinceCode'] = entity.loadProvinceCode;
	data['loadCityCode'] = entity.loadCityCode;
	data['loadDistrictCode'] = entity.loadDistrictCode;
	data['loadAddress'] = entity.loadAddress;
	data['unloadProvinceCode'] = entity.unloadProvinceCode;
	data['unloadCityCode'] = entity.unloadCityCode;
	data['unloadDistrictCode'] = entity.unloadDistrictCode;
	data['unloadAddress'] = entity.unloadAddress;
	data['categoryName'] = entity.categoryName;
	data['weight'] = entity.weight;
	data['volume'] = entity.volume;
	data['carType'] = entity.carType;
	data['carLongs'] = entity.carLongs;
	data['carModels'] = entity.carModels;
	data['loadUnload'] = entity.loadUnload;
	data['loadStartAt'] = entity.loadStartAt;
	data['loadEndAt'] = entity.loadEndAt;
	data['remark'] = entity.remark;
	data['requireList'] = entity.requireList;
	data['createAt'] = entity.createAt;
	data['status'] = entity.status;
	data['deleteStatus'] = entity.deleteStatus;
	data['markStatus'] = entity.markStatus;
	data['packageMode'] = entity.packageMode;
	data['driverAvatar'] = entity.driverAvatar;
	data['driverName'] = entity.driverName;
	data['driverMobile'] = entity.driverMobile;
	data['userAvatar'] = entity.userAvatar;
	data['userName'] = entity.userName;
	data['companyName'] = entity.companyName;
	data['userMobile'] = entity.userMobile;
	data['protocolStatus'] = entity.protocolStatus;
	data['driverPayStatus'] = entity.driverPayStatus;
	return data;
}