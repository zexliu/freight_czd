import 'package:flutterdriver/model/dict_entry_entity.dart';

dictEntryEntityFromJson(DictEntryEntity data, Map<String, dynamic> json) {
	if (json['records'] != null) {
		data.records = new List<DictEntryRecord>();
		(json['records'] as List).forEach((v) {
			data.records.add(new DictEntryRecord().fromJson(v));
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

Map<String, dynamic> dictEntryEntityToJson(DictEntryEntity entity) {
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

dictEntryRecordFromJson(DictEntryRecord data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['dictCode'] != null) {
		data.dictCode = json['dictCode']?.toString();
	}
	if (json['dictEntryName'] != null) {
		data.dictEntryName = json['dictEntryName']?.toString();
	}
	if (json['dictEntryValue'] != null) {
		data.dictEntryValue = json['dictEntryValue']?.toString();
	}
	if (json['description'] != null) {
		data.description = json['description']?.toString();
	}
	if (json['createAt'] != null) {
		data.createAt = json['createAt']?.toInt();
	}
	if (json['seq'] != null) {
		data.seq = json['seq']?.toInt();
	}
	if (json['enable'] != null) {
		data.enable = json['enable'];
	}
	return data;
}

Map<String, dynamic> dictEntryRecordToJson(DictEntryRecord entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['dictCode'] = entity.dictCode;
	data['dictEntryName'] = entity.dictEntryName;
	data['dictEntryValue'] = entity.dictEntryValue;
	data['description'] = entity.description;
	data['createAt'] = entity.createAt;
	data['seq'] = entity.seq;
	data['enable'] = entity.enable;
	return data;
}