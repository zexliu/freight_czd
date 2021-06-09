import 'package:freightowner/model/evaluation_list_entity.dart';

evaluationListEntityFromJson(EvaluationListEntity data, Map<String, dynamic> json) {
	if (json['records'] != null) {
		data.records = new List<EvaluationListRecord>();
		(json['records'] as List).forEach((v) {
			data.records.add(new EvaluationListRecord().fromJson(v));
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

Map<String, dynamic> evaluationListEntityToJson(EvaluationListEntity entity) {
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

evaluationListRecordFromJson(EvaluationListRecord data, Map<String, dynamic> json) {
	if (json['userAvatar'] != null) {
		data.userAvatar = json['userAvatar']?.toString();
	}
	if (json['userName'] != null) {
		data.userName = json['userName']?.toString();
	}
	if (json['driverAvatar'] != null) {
		data.driverAvatar = json['driverAvatar']?.toString();
	}
	if (json['driverName'] != null) {
		data.driverName = json['driverName']?.toString();
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
	if (json['categoryName'] != null) {
		data.categoryName = json['categoryName']?.toString();
	}
	if (json['orderId'] != null) {
		data.orderId = json['orderId']?.toString();
	}
	if (json['userEvaluationId'] != null) {
		data.userEvaluationId = json['userEvaluationId']?.toString();
	}
	if (json['userTags'] != null) {
		data.userTags = json['userTags']?.toString();
	}
	if (json['userDescription'] != null) {
		data.userDescription = json['userDescription']?.toString();
	}
	if (json['userCreateAt'] != null) {
		data.userCreateAt = json['userCreateAt']?.toInt();
	}
	if (json['userLevel'] != null) {
		data.userLevel = json['userLevel']?.toInt();
	}
	if (json['driverEvaluationId'] != null) {
		data.driverEvaluationId = json['driverEvaluationId']?.toString();
	}
	if (json['driverTags'] != null) {
		data.driverTags = json['driverTags']?.toString();
	}
	if (json['driverDescription'] != null) {
		data.driverDescription = json['driverDescription']?.toString();
	}
	if (json['driverCreateAt'] != null) {
		data.driverCreateAt = json['driverCreateAt']?.toInt();
	}
	if (json['driverLevel'] != null) {
		data.driverLevel = json['driverLevel']?.toInt();
	}
	return data;
}

Map<String, dynamic> evaluationListRecordToJson(EvaluationListRecord entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['userAvatar'] = entity.userAvatar;
	data['userName'] = entity.userName;
	data['driverAvatar'] = entity.driverAvatar;
	data['driverName'] = entity.driverName;
	data['loadProvinceCode'] = entity.loadProvinceCode;
	data['loadCityCode'] = entity.loadCityCode;
	data['loadDistrictCode'] = entity.loadDistrictCode;
	data['unloadProvinceCode'] = entity.unloadProvinceCode;
	data['unloadCityCode'] = entity.unloadCityCode;
	data['unloadDistrictCode'] = entity.unloadDistrictCode;
	data['categoryName'] = entity.categoryName;
	data['orderId'] = entity.orderId;
	data['userEvaluationId'] = entity.userEvaluationId;
	data['userTags'] = entity.userTags;
	data['userDescription'] = entity.userDescription;
	data['userCreateAt'] = entity.userCreateAt;
	data['userLevel'] = entity.userLevel;
	data['driverEvaluationId'] = entity.driverEvaluationId;
	data['driverTags'] = entity.driverTags;
	data['driverDescription'] = entity.driverDescription;
	data['driverCreateAt'] = entity.driverCreateAt;
	data['driverLevel'] = entity.driverLevel;
	return data;
}