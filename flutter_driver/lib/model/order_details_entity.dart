
import 'package:flutterdriver/generated/json/base/json_convert_content.dart';

class OrderDetailsEntity with JsonConvert<OrderDetailsEntity> {
	String id;
	String deliveryId;
	String userId;
	String driverId;
	double amount;
	double freightAmount;
	bool confirmStatus;
	bool transportStatus;
	bool payStatus;
	bool evaluateStatus;
	bool driverEvaluateStatus;
	bool cancelStatus;
	bool refundStatus;
	String loadProvinceCode;
	String loadCityCode;
	String loadDistrictCode;
	String loadAddress;
	String unloadProvinceCode;
	String unloadCityCode;
	String unloadDistrictCode;
	String unloadAddress;
	String categoryName;
	//傻逼想法改需求
	String weight;
	String volume;
	String carType;
	String carLongs;
	String carModels;
	String loadUnload;
	int loadStartAt;
	int loadEndAt;
	String remark;
	String requireList;
	int createAt;
	int status;
	int deleteStatus;
	int markStatus;
	String packageMode;
	String driverAvatar;
	String driverName;
	String driverMobile;
	String userAvatar;
	String userName;
	String companyName;
	String userMobile;
	int protocolStatus;
	bool driverPayStatus;
}
