import 'package:freightowner/model/deliver_goods_entity.dart';

deliverGoodsEntityFromJson(DeliverGoodsEntity data, Map<String, dynamic> json) {
	if (json['records'] != null) {
		data.records = new List<DeliverGoodsRecord>();
		(json['records'] as List).forEach((v) {
			data.records.add(new DeliverGoodsRecord().fromJson(v));
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

Map<String, dynamic> deliverGoodsEntityToJson(DeliverGoodsEntity entity) {
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

deliverGoodsRecordFromJson(DeliverGoodsRecord data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['userId'] != null) {
		data.userId = json['userId']?.toString();
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
	if (json['loadWayProvinceCode'] != null) {
		data.loadWayProvinceCode = json['loadWayProvinceCode']?.toString();
	}
	if (json['loadWayCityCode'] != null) {
		data.loadWayCityCode = json['loadWayCityCode']?.toString();
	}
	if (json['loadWayDistrictCode'] != null) {
		data.loadWayDistrictCode = json['loadWayDistrictCode']?.toString();
	}
	if (json['loadWayAddress'] != null) {
		data.loadWayAddress = json['loadWayAddress']?.toString();
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
	if (json['unloadWayProvinceCode'] != null) {
		data.unloadWayProvinceCode = json['unloadWayProvinceCode']?.toString();
	}
	if (json['unloadWayCityCode'] != null) {
		data.unloadWayCityCode = json['unloadWayCityCode']?.toString();
	}
	if (json['unloadWayDistrictCode'] != null) {
		data.unloadWayDistrictCode = json['unloadWayDistrictCode']?.toString();
	}
	if (json['unloadWayAddress'] != null) {
		data.unloadWayAddress = json['unloadWayAddress']?.toString();
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
	if (json['carPlaceLong'] != null) {
		data.carPlaceLong = json['carPlaceLong']?.toDouble();
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
	if (json['expectMoney'] != null) {
		data.expectMoney = json['expectMoney']?.toDouble();
	}
	if (json['expectUnit'] != null) {
		data.expectUnit = json['expectUnit']?.toString();
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
	if (json['loadLat'] != null) {
		data.loadLat = json['loadLat']?.toDouble();
	}
	if (json['loadLon'] != null) {
		data.loadLon = json['loadLon']?.toDouble();
	}
	if (json['loadWayLat'] != null) {
		data.loadWayLat = json['loadWayLat']?.toDouble();
	}
	if (json['loadWayLon'] != null) {
		data.loadWayLon = json['loadWayLon']?.toDouble();
	}
	if (json['unloadLat'] != null) {
		data.unloadLat = json['unloadLat']?.toDouble();
	}
	if (json['unloadLon'] != null) {
		data.unloadLon = json['unloadLon']?.toDouble();
	}
	if (json['unloadWayLat'] != null) {
		data.unloadWayLat = json['unloadWayLat']?.toDouble();
	}
	if (json['unloadWayLon'] != null) {
		data.unloadWayLon = json['unloadWayLon']?.toDouble();
	}
	if (json['packageMode'] != null) {
		data.packageMode = json['packageMode']?.toString();
	}
	if (json['callCount'] != null) {
		data.callCount = json['callCount']?.toInt();
	}
	if (json['lookCount'] != null) {
		data.lookCount = json['lookCount']?.toInt();
	}
	return data;
}

Map<String, dynamic> deliverGoodsRecordToJson(DeliverGoodsRecord entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['userId'] = entity.userId;
	data['loadProvinceCode'] = entity.loadProvinceCode;
	data['loadCityCode'] = entity.loadCityCode;
	data['loadDistrictCode'] = entity.loadDistrictCode;
	data['loadAddress'] = entity.loadAddress;
	data['loadWayProvinceCode'] = entity.loadWayProvinceCode;
	data['loadWayCityCode'] = entity.loadWayCityCode;
	data['loadWayDistrictCode'] = entity.loadWayDistrictCode;
	data['loadWayAddress'] = entity.loadWayAddress;
	data['unloadProvinceCode'] = entity.unloadProvinceCode;
	data['unloadCityCode'] = entity.unloadCityCode;
	data['unloadDistrictCode'] = entity.unloadDistrictCode;
	data['unloadAddress'] = entity.unloadAddress;
	data['unloadWayProvinceCode'] = entity.unloadWayProvinceCode;
	data['unloadWayCityCode'] = entity.unloadWayCityCode;
	data['unloadWayDistrictCode'] = entity.unloadWayDistrictCode;
	data['unloadWayAddress'] = entity.unloadWayAddress;
	data['categoryName'] = entity.categoryName;
	data['weight'] = entity.weight;
	data['volume'] = entity.volume;
	data['carType'] = entity.carType;
	data['carLongs'] = entity.carLongs;
	data['carPlaceLong'] = entity.carPlaceLong;
	data['carModels'] = entity.carModels;
	data['loadUnload'] = entity.loadUnload;
	data['loadStartAt'] = entity.loadStartAt;
	data['loadEndAt'] = entity.loadEndAt;
	data['remark'] = entity.remark;
	data['requireList'] = entity.requireList;
	data['expectMoney'] = entity.expectMoney;
	data['expectUnit'] = entity.expectUnit;
	data['createAt'] = entity.createAt;
	data['status'] = entity.status;
	data['deleteStatus'] = entity.deleteStatus;
	data['markStatus'] = entity.markStatus;
	data['loadLat'] = entity.loadLat;
	data['loadLon'] = entity.loadLon;
	data['loadWayLat'] = entity.loadWayLat;
	data['loadWayLon'] = entity.loadWayLon;
	data['unloadLat'] = entity.unloadLat;
	data['unloadLon'] = entity.unloadLon;
	data['unloadWayLat'] = entity.unloadWayLat;
	data['unloadWayLon'] = entity.unloadWayLon;
	data['packageMode'] = entity.packageMode;
	data['callCount'] = entity.callCount;
	data['lookCount'] = entity.lookCount;
	return data;
}