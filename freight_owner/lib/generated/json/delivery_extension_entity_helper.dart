import 'package:freightowner/model/delivery_extension_entity.dart';

deliveryExtensionEntityFromJson(DeliveryExtensionEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['userId'] != null) {
		data.userId = json['userId']?.toString();
	}
	if (json['nature'] != null) {
		data.nature = json['nature']?.toString();
	}
	if (json['businessLicense'] != null) {
		data.businessLicense = json['businessLicense']?.toString();
	}
	if (json['auditStatus'] != null) {
		data.auditStatus = json['auditStatus']?.toString();
	}
	if (json['identityCard'] != null) {
		data.identityCard = json['identityCard']?.toString();
	}
	if (json['identityCardBackend'] != null) {
		data.identityCardBackend = json['identityCardBackend']?.toString();
	}
	if (json['identityCardTake'] != null) {
		data.identityCardTake = json['identityCardTake']?.toString();
	}
	if (json['avatar'] != null) {
		data.avatar = json['avatar']?.toString();
	}
	if (json['realName'] != null) {
		data.realName = json['realName']?.toString();
	}
	if (json['companyName'] != null) {
		data.companyName = json['companyName']?.toString();
	}
	if (json['shopGroupPhoto'] != null) {
		data.shopGroupPhoto = json['shopGroupPhoto']?.toString();
	}
	if (json['histories'] != null) {
		data.histories = new List<DeliveryExtensionHistory>();
		(json['histories'] as List).forEach((v) {
			data.histories.add(new DeliveryExtensionHistory().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> deliveryExtensionEntityToJson(DeliveryExtensionEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['userId'] = entity.userId;
	data['nature'] = entity.nature;
	data['businessLicense'] = entity.businessLicense;
	data['auditStatus'] = entity.auditStatus;
	data['identityCard'] = entity.identityCard;
	data['identityCardBackend'] = entity.identityCardBackend;
	data['identityCardTake'] = entity.identityCardTake;
	data['avatar'] = entity.avatar;
	data['realName'] = entity.realName;
	data['companyName'] = entity.companyName;
	data['shopGroupPhoto'] = entity.shopGroupPhoto;
	if (entity.histories != null) {
		data['histories'] =  entity.histories.map((v) => v.toJson()).toList();
	}
	return data;
}

deliveryExtensionHistoryFromJson(DeliveryExtensionHistory data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toInt();
	}
	if (json['targetId'] != null) {
		data.targetId = json['targetId']?.toInt();
	}
	if (json['targetType'] != null) {
		data.targetType = json['targetType']?.toString();
	}
	if (json['snapshot'] != null) {
		data.snapshot = json['snapshot']?.toString();
	}
	if (json['status'] != null) {
		data.status = json['status']?.toString();
	}
	if (json['message'] != null) {
		data.message = json['message']?.toString();
	}
	if (json['operatorId'] != null) {
		data.operatorId = json['operatorId']?.toInt();
	}
	if (json['operatorIp'] != null) {
		data.operatorIp = json['operatorIp']?.toString();
	}
	if (json['createAt'] != null) {
		data.createAt = json['createAt']?.toInt();
	}
	return data;
}

Map<String, dynamic> deliveryExtensionHistoryToJson(DeliveryExtensionHistory entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['targetId'] = entity.targetId;
	data['targetType'] = entity.targetType;
	data['snapshot'] = entity.snapshot;
	data['status'] = entity.status;
	data['message'] = entity.message;
	data['operatorId'] = entity.operatorId;
	data['operatorIp'] = entity.operatorIp;
	data['createAt'] = entity.createAt;
	return data;
}