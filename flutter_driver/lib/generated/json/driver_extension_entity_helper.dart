import 'package:flutterdriver/model/driver_extension_entity.dart';

driverExtensionEntityFromJson(DriverExtensionEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['userId'] != null) {
		data.userId = json['userId']?.toString();
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
	if (json['carLong'] != null) {
		data.carLong = json['carLong']?.toString();
	}
	if (json['carModel'] != null) {
		data.carModel = json['carModel']?.toString();
	}
	if (json['nature'] != null) {
		data.nature = json['nature']?.toString();
	}
	if (json['carNo'] != null) {
		data.carNo = json['carNo']?.toString();
	}
	if (json['vehicleLicense'] != null) {
		data.vehicleLicense = json['vehicleLicense']?.toString();
	}
	if (json['vehicleLicenseBackend'] != null) {
		data.vehicleLicenseBackend = json['vehicleLicenseBackend']?.toString();
	}
	if (json['driverLicense'] != null) {
		data.driverLicense = json['driverLicense']?.toString();
	}
	if (json['driverLicenseBackend'] != null) {
		data.driverLicenseBackend = json['driverLicenseBackend']?.toString();
	}
	if (json['carGroupPhoto'] != null) {
		data.carGroupPhoto = json['carGroupPhoto']?.toString();
	}
	if (json['histories'] != null) {
		data.histories = new List<DeliveryExtensionHistory>();
		(json['histories'] as List).forEach((v) {
			data.histories.add(new DeliveryExtensionHistory().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> driverExtensionEntityToJson(DriverExtensionEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['userId'] = entity.userId;
	data['auditStatus'] = entity.auditStatus;
	data['identityCard'] = entity.identityCard;
	data['identityCardBackend'] = entity.identityCardBackend;
	data['identityCardTake'] = entity.identityCardTake;
	data['avatar'] = entity.avatar;
	data['realName'] = entity.realName;
	data['carLong'] = entity.carLong;
	data['carModel'] = entity.carModel;
	data['nature'] = entity.nature;
	data['carNo'] = entity.carNo;
	data['vehicleLicense'] = entity.vehicleLicense;
	data['vehicleLicenseBackend'] = entity.vehicleLicenseBackend;
	data['driverLicense'] = entity.driverLicense;
	data['driverLicenseBackend'] = entity.driverLicenseBackend;
	data['carGroupPhoto'] = entity.carGroupPhoto;
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