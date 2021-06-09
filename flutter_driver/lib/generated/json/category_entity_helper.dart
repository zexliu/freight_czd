import 'package:flutterdriver/model/category_entity.dart';
import 'package:flutterdriver/model/dict_entry_entity.dart';

categoryEntityFromJson(CategoryEntity data, Map<String, dynamic> json) {
	if (json['records'] != null) {
		data.records = new List<CategoryRecord>();
		(json['records'] as List).forEach((v) {
			data.records.add(new CategoryRecord().fromJson(v));
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

Map<String, dynamic> categoryEntityToJson(CategoryEntity entity) {
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

categoryRecordFromJson(CategoryRecord data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['categoryName'] != null) {
		data.categoryName = json['categoryName']?.toString();
	}
	if (json['categoryCode'] != null) {
		data.categoryCode = json['categoryCode']?.toString();
	}
	if (json['parentId'] != null) {
		data.parentId = json['parentId']?.toString();
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
	if (json['isHot'] != null) {
		data.isHot = json['isHot'];
	}
	if (json['children'] != null) {
		data.children = new List<CategoryRecord>();
		(json['children'] as List).forEach((v) {
			data.children.add(new CategoryRecord().fromJson(v));
		});
	}
	if (json['dictEntries'] != null) {
		data.dictEntries = new List<DictEntryRecord>();
		(json['dictEntries'] as List).forEach((v) {
			data.dictEntries.add(new DictEntryRecord().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> categoryRecordToJson(CategoryRecord entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['categoryName'] = entity.categoryName;
	data['categoryCode'] = entity.categoryCode;
	data['parentId'] = entity.parentId;
	data['description'] = entity.description;
	data['createAt'] = entity.createAt;
	data['seq'] = entity.seq;
	data['isHot'] = entity.isHot;
	if (entity.children != null) {
		data['children'] =  entity.children.map((v) => v.toJson()).toList();
	}
	if (entity.dictEntries != null) {
		data['dictEntries'] =  entity.dictEntries.map((v) => v.toJson()).toList();
	}
	return data;
}