import 'package:freightowner/model/simple_driver_entity.dart';

simpleDriverEntityFromJson(SimpleDriverEntity data, Map<String, dynamic> json) {
	if (json['records'] != null) {
		data.records = new List<SimpleDriverRecord>();
		(json['records'] as List).forEach((v) {
			data.records.add(new SimpleDriverRecord().fromJson(v));
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

Map<String, dynamic> simpleDriverEntityToJson(SimpleDriverEntity entity) {
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

simpleDriverRecordFromJson(SimpleDriverRecord data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['username'] != null) {
		data.username = json['username']?.toString();
	}
	if (json['mobile'] != null) {
		data.mobile = json['mobile']?.toString();
	}
	if (json['nickname'] != null) {
		data.nickname = json['nickname']?.toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar']?.toString();
	}
	if (json['createAt'] != null) {
		data.createAt = json['createAt']?.toInt();
	}
	if (json['carLong'] != null) {
		data.carLong = json['carLong']?.toString();
	}
	if (json['carModel'] != null) {
		data.carModel = json['carModel']?.toString();
	}
	return data;
}

Map<String, dynamic> simpleDriverRecordToJson(SimpleDriverRecord entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['username'] = entity.username;
	data['mobile'] = entity.mobile;
	data['nickname'] = entity.nickname;
	data['avatar'] = entity.avatar;
	data['createAt'] = entity.createAt;
	data['carLong'] = entity.carLong;
	data['carModel'] = entity.carModel;
	return data;
}