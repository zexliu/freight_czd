
import 'package:flutterdriver/generated/json/base/json_convert_content.dart';

class OrderEntity with JsonConvert<OrderEntity> {
	List<OrderRecord> records;
	int total;
	int size;
	int current;
	List<dynamic> orders;
	bool hitCount;
	bool searchCount;
	int pages;
}

class OrderRecord with JsonConvert<OrderRecord> {
	String orderId;
	String userId;
	String driverId;
	String deliveryId;
	String driverNickname;
	String driverAvatar;
	String userNickname;
	String userAvatar;
	String driverMobile;
	String loadProvinceCode;
	String loadCityCode;
	String loadDistrictCode;
	String unloadProvinceCode;
	String unloadCityCode;
	String unloadDistrictCode;
	int loadStartAt;
	int loadEndAt;
	double amount;
	double freightAmount;
	bool confirmStatus;
	bool transportStatus;
	bool payStatus;
	bool evaluateStatus;
	bool driverEvaluateStatus;
	bool cancelStatus;
	bool refundStatus;
	int protocolStatus;
	bool driverPayStatus;
	String categoryName;
}