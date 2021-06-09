import 'package:flutterdriver/model/order_entity.dart';

orderEntityFromJson(OrderEntity data, Map<String, dynamic> json) {
	if (json['records'] != null) {
		data.records = new List<OrderRecord>();
		(json['records'] as List).forEach((v) {
			data.records.add(new OrderRecord().fromJson(v));
		});
	}
	if (json['total'] != null) {
		data.total = json['total']?.toInt();
	}
	if (json['size'] != null) {
		data.size = json['size']?.toInt();
	}
	if (json['current'] != null) {
		data.current = json['current']?.toInt();
	}
	if (json['orders'] != null) {
		data.orders = new List<dynamic>();
		data.orders.addAll(json['orders']);
	}
	if (json['hitCount'] != null) {
		data.hitCount = json['hitCount'];
	}
	if (json['searchCount'] != null) {
		data.searchCount = json['searchCount'];
	}
	if (json['pages'] != null) {
		data.pages = json['pages']?.toInt();
	}
	return data;
}

Map<String, dynamic> orderEntityToJson(OrderEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	if (entity.records != null) {
		data['records'] =  entity.records.map((v) => v.toJson()).toList();
	}
	data['total'] = entity.total;
	data['size'] = entity.size;
	data['current'] = entity.current;
	if (entity.orders != null) {
		data['orders'] =  [];
	}
	data['hitCount'] = entity.hitCount;
	data['searchCount'] = entity.searchCount;
	data['pages'] = entity.pages;
	return data;
}

orderRecordFromJson(OrderRecord data, Map<String, dynamic> json) {
	if (json['orderId'] != null) {
		data.orderId = json['orderId']?.toString();
	}
	if (json['userId'] != null) {
		data.userId = json['userId']?.toString();
	}
	if (json['driverId'] != null) {
		data.driverId = json['driverId']?.toString();
	}
	if (json['deliveryId'] != null) {
		data.deliveryId = json['deliveryId']?.toString();
	}
	if (json['driverNickname'] != null) {
		data.driverNickname = json['driverNickname']?.toString();
	}
	if (json['driverAvatar'] != null) {
		data.driverAvatar = json['driverAvatar']?.toString();
	}
	if (json['userNickname'] != null) {
		data.userNickname = json['userNickname']?.toString();
	}
	if (json['userAvatar'] != null) {
		data.userAvatar = json['userAvatar']?.toString();
	}
	if (json['driverMobile'] != null) {
		data.driverMobile = json['driverMobile']?.toString();
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
	if (json['loadStartAt'] != null) {
		data.loadStartAt = json['loadStartAt']?.toInt();
	}
	if (json['loadEndAt'] != null) {
		data.loadEndAt = json['loadEndAt']?.toInt();
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
	if (json['protocolStatus'] != null) {
		data.protocolStatus = json['protocolStatus']?.toInt();
	}
	if (json['driverPayStatus'] != null) {
		data.driverPayStatus = json['driverPayStatus'];
	}
	if (json['categoryName'] != null) {
		data.categoryName = json['categoryName']?.toString();
	}
	return data;
}

Map<String, dynamic> orderRecordToJson(OrderRecord entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['orderId'] = entity.orderId;
	data['userId'] = entity.userId;
	data['driverId'] = entity.driverId;
	data['deliveryId'] = entity.deliveryId;
	data['driverNickname'] = entity.driverNickname;
	data['driverAvatar'] = entity.driverAvatar;
	data['userNickname'] = entity.userNickname;
	data['userAvatar'] = entity.userAvatar;
	data['driverMobile'] = entity.driverMobile;
	data['loadProvinceCode'] = entity.loadProvinceCode;
	data['loadCityCode'] = entity.loadCityCode;
	data['loadDistrictCode'] = entity.loadDistrictCode;
	data['unloadProvinceCode'] = entity.unloadProvinceCode;
	data['unloadCityCode'] = entity.unloadCityCode;
	data['unloadDistrictCode'] = entity.unloadDistrictCode;
	data['loadStartAt'] = entity.loadStartAt;
	data['loadEndAt'] = entity.loadEndAt;
	data['amount'] = entity.amount;
	data['freightAmount'] = entity.freightAmount;
	data['confirmStatus'] = entity.confirmStatus;
	data['transportStatus'] = entity.transportStatus;
	data['payStatus'] = entity.payStatus;
	data['evaluateStatus'] = entity.evaluateStatus;
	data['driverEvaluateStatus'] = entity.driverEvaluateStatus;
	data['cancelStatus'] = entity.cancelStatus;
	data['refundStatus'] = entity.refundStatus;
	data['protocolStatus'] = entity.protocolStatus;
	data['driverPayStatus'] = entity.driverPayStatus;
	data['categoryName'] = entity.categoryName;
	return data;
}