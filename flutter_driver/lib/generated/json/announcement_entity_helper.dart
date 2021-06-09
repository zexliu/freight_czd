import 'package:flutterdriver/model/announcement_entity.dart';

announcementEntityFromJson(AnnouncementEntity data, Map<String, dynamic> json) {
	if (json['records'] != null) {
		data.records = new List<AnnouncementRecords>();
		(json['records'] as List).forEach((v) {
			data.records.add(new AnnouncementRecords().fromJson(v));
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

Map<String, dynamic> announcementEntityToJson(AnnouncementEntity entity) {
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

announcementRecordsFromJson(AnnouncementRecords data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['title'] != null) {
		data.title = json['title']?.toString();
	}
	if (json['content'] != null) {
		data.content = json['content']?.toString();
	}
	if (json['createAt'] != null) {
		data.createAt = json['createAt']?.toInt();
	}
	if (json['announcementType'] != null) {
		data.announcementType = json['announcementType']?.toInt();
	}
	if (json['params'] != null) {
		data.params = json['params']?.toString();
	}
	if (json['validStatus'] != null) {
		data.validStatus = json['validStatus'];
	}
	return data;
}

Map<String, dynamic> announcementRecordsToJson(AnnouncementRecords entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['title'] = entity.title;
	data['content'] = entity.content;
	data['createAt'] = entity.createAt;
	data['announcementType'] = entity.announcementType;
	data['params'] = entity.params;
	data['validStatus'] = entity.validStatus;
	return data;
}