import 'package:flutterdriver/model/call_entity.dart';

callEntityFromJson(CallEntity data, Map<String, dynamic> json) {
	if (json['records'] != null) {
		data.records = new List<CallRecord>();
		(json['records'] as List).forEach((v) {
			data.records.add(new CallRecord().fromJson(v));
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

Map<String, dynamic> callEntityToJson(CallEntity entity) {
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

callRecordFromJson(CallRecord data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['fromUserId'] != null) {
		data.fromUserId = json['fromUserId']?.toString();
	}
	if (json['toUserId'] != null) {
		data.toUserId = json['toUserId']?.toString();
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
	if (json['toAvatar'] != null) {
		data.toAvatar = json['toAvatar']?.toString();
	}
	if (json['toMobile'] != null) {
		data.toMobile = json['toMobile']?.toString();
	}
	if (json['toNickname'] != null) {
		data.toNickname = json['toNickname']?.toString();
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
	if (json['goodsStatus'] != null) {
		data.goodsStatus = json['goodsStatus']?.toInt();
	}
	return data;
}

Map<String, dynamic> callRecordToJson(CallRecord entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['fromUserId'] = entity.fromUserId;
	data['toUserId'] = entity.toUserId;
	data['goodsId'] = entity.goodsId;
	data['type'] = entity.type;
	data['createAt'] = entity.createAt;
	data['fromAvatar'] = entity.fromAvatar;
	data['fromMobile'] = entity.fromMobile;
	data['fromNickname'] = entity.fromNickname;
	data['toAvatar'] = entity.toAvatar;
	data['toMobile'] = entity.toMobile;
	data['toNickname'] = entity.toNickname;
	data['loadProvinceCode'] = entity.loadProvinceCode;
	data['loadCityCode'] = entity.loadCityCode;
	data['loadDistrictCode'] = entity.loadDistrictCode;
	data['unloadProvinceCode'] = entity.unloadProvinceCode;
	data['unloadCityCode'] = entity.unloadCityCode;
	data['unloadDistrictCode'] = entity.unloadDistrictCode;
	data['goodsStatus'] = entity.goodsStatus;
	return data;
}