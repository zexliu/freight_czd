import 'package:freightowner/model/delivery_details_entity.dart';

deliveryDetailsEntityFromJson(DeliveryDetailsEntity data, Map<String, dynamic> json) {
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
	if (json['createAt'] != null) {
		data.createAt = json['createAt']?.toInt();
	}
	if (json['expectMoney'] != null) {
		data.expectMoney = json['expectMoney']?.toInt();
	}
	if (json['expectUnit'] != null) {
		data.expectUnit = json['expectUnit']?.toString();
	}
	if (json['requireList'] != null) {
		data.requireList = json['requireList']?.toString();
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
	if (json['calls'] != null) {
		data.calls = new List<DeliveryDetailsCall>();
		(json['calls'] as List).forEach((v) {
			data.calls.add(new DeliveryDetailsCall().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> deliveryDetailsEntityToJson(DeliveryDetailsEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['userId'] = entity.userId;
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
	data['createAt'] = entity.createAt;
	data['expectMoney'] = entity.expectMoney;
	data['expectUnit'] = entity.expectUnit;
	data['requireList'] = entity.requireList;
	data['status'] = entity.status;
	data['deleteStatus'] = entity.deleteStatus;
	data['markStatus'] = entity.markStatus;
	data['packageMode'] = entity.packageMode;
	if (entity.calls != null) {
		data['calls'] =  entity.calls.map((v) => v.toJson()).toList();
	}
	return data;
}

deliveryDetailsCallFromJson(DeliveryDetailsCall data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['fromUserId'] != null) {
		data.fromUserId = json['fromUserId']?.toString();
	}
	if (json['goodsId'] != null) {
		data.goodsId = json['goodsId']?.toString();
	}
	if (json['type'] != null) {
		data.type = json['type'];
	}
	if (json['createAt'] != null) {
		data.createAt = json['createAt']?.toInt();
	}
	if (json['fromAvatar'] != null) {
		data.fromAvatar = json['fromAvatar']?.toString();
	}
	if (json['fromMobile'] != null) {
		data.fromMobile = json['fromMobile']?.toString();
	}
	if (json['fromNickname'] != null) {
		data.fromNickname = json['fromNickname']?.toString();
	}
	return data;
}

Map<String, dynamic> deliveryDetailsCallToJson(DeliveryDetailsCall entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['fromUserId'] = entity.fromUserId;
	data['goodsId'] = entity.goodsId;
	data['type'] = entity.type;
	data['createAt'] = entity.createAt;
	data['fromAvatar'] = entity.fromAvatar;
	data['fromMobile'] = entity.fromMobile;
	data['fromNickname'] = entity.fromNickname;
	return data;
}