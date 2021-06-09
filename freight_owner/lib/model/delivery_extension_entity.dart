import 'package:freightowner/generated/json/base/json_convert_content.dart';

class DeliveryExtensionEntity with JsonConvert<DeliveryExtensionEntity> {
	String id;
	String userId;
	String nature;
	String businessLicense;
	String auditStatus;
	String identityCard;
	String identityCardBackend;
	String identityCardTake;
	String avatar;
	String realName;
	String companyName;
	String shopGroupPhoto;
	List<DeliveryExtensionHistory> histories;
}

class DeliveryExtensionHistory with JsonConvert<DeliveryExtensionHistory> {
	int id;
	int targetId;
	String targetType;
	String snapshot;
	String status;
	String message;
	int operatorId;
	String operatorIp;
	int createAt;
}
