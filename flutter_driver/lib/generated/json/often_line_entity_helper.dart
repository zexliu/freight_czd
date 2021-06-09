import 'package:flutterdriver/model/often_line_entity.dart';

oftenLineEntityFromJson(OftenLineEntity data, Map<String, dynamic> json) {
	if (json['records'] != null) {
		data.records = new List<OftenLineRecord>();
		(json['records'] as List).forEach((v) {
			data.records.add(new OftenLineRecord().fromJson(v));
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

Map<String, dynamic> oftenLineEntityToJson(OftenLineEntity entity) {
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

oftenLineRecordFromJson(OftenLineRecord data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['userId'] != null) {
		data.userId = json['userId']?.toString();
	}
	if (json['loadAreas'] != null) {
		data.loadAreas = json['loadAreas']?.toString();
	}
	if (json['unloadAreas'] != null) {
		data.unloadAreas = json['unloadAreas']?.toString();
	}
	if (json['carLongs'] != null) {
		data.carLongs = json['carLongs']?.toString();
	}
	if (json['carModels'] != null) {
		data.carModels = json['carModels']?.toString();
	}
	if (json['createAt'] != null) {
		data.createAt = json['createAt']?.toInt();
	}
	return data;
}

Map<String, dynamic> oftenLineRecordToJson(OftenLineRecord entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['userId'] = entity.userId;
	data['loadAreas'] = entity.loadAreas;
	data['unloadAreas'] = entity.unloadAreas;
	data['carLongs'] = entity.carLongs;
	data['carModels'] = entity.carModels;
	data['createAt'] = entity.createAt;
	return data;
}