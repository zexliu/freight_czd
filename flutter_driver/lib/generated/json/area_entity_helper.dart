import 'package:flutterdriver/model/area_entity.dart';

areaEntityFromJson(AreaEntity data, Map<String, dynamic> json) {
	if (json['value'] != null) {
		data.value = json['value']?.toString();
	}
	if (json['label'] != null) {
		data.label = json['label']?.toString();
	}
	if (json['latitude'] != null) {
		data.latitude = json['latitude']?.toDouble();
	}
	if (json['longitude'] != null) {
		data.longitude = json['longitude']?.toDouble();
	}
	if (json['children'] != null) {
		data.children = new List<AreaEntity>();
		(json['children'] as List).forEach((v) {
			data.children.add(new AreaEntity().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> areaEntityToJson(AreaEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['value'] = entity.value;
	data['label'] = entity.label;
	data['latitude'] = entity.latitude;
	data['longitude'] = entity.longitude;
	if (entity.children != null) {
		data['children'] =  entity.children.map((v) => v.toJson()).toList();
	}
	return data;
}