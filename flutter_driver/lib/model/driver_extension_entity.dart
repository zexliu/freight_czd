import 'package:flutterdriver/generated/json/base/json_convert_content.dart';

class DriverExtensionEntity with JsonConvert<DriverExtensionEntity> {
  String id;
  String userId;
  String auditStatus;
  String identityCard;
  String identityCardBackend;
  String identityCardTake;
  String avatar;
  String realName;
  String carLong;
  String carModel;
  String nature;
  String carNo;
  String vehicleLicense;
  String vehicleLicenseBackend;
  String driverLicense;
  String driverLicenseBackend;
  String carGroupPhoto;
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
