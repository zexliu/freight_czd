import 'package:freightowner/model/app_version_entity.dart';

appVersionEntityFromJson(AppVersionEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['downloadUrl'] != null) {
		data.downloadUrl = json['downloadUrl']?.toString();
	}
	if (json['versionCode'] != null) {
		data.versionCode = json['versionCode']?.toInt();
	}
	if (json['versionName'] != null) {
		data.versionName = json['versionName']?.toString();
	}
	if (json['content'] != null) {
		data.content = json['content']?.toString();
	}
	if (json['createAt'] != null) {
		data.createAt = json['createAt']?.toInt();
	}
	if (json['isForce'] != null) {
		data.isForce = json['isForce'];
	}
	if (json['sha256checksum'] != null) {
		data.sha256checksum = json['sha256checksum']?.toString();
	}
	return data;
}

Map<String, dynamic> appVersionEntityToJson(AppVersionEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['downloadUrl'] = entity.downloadUrl;
	data['versionCode'] = entity.versionCode;
	data['versionName'] = entity.versionName;
	data['content'] = entity.content;
	data['createAt'] = entity.createAt;
	data['isForce'] = entity.isForce;
	data['sha256checksum'] = entity.sha256checksum;
	return data;
}