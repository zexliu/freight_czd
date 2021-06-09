
import 'package:flutterdriver/generated/json/base/json_convert_content.dart';

class OrderProtocolEntity with JsonConvert<OrderProtocolEntity> {
	String id ;
	String orderId;
	double amount;
	double freightAmount;
	int loadStartAt;
	int loadEndAt;
	int unloadStartAt;
	int unloadEndAt;
	String loadProvinceCode;
	String loadCityCode;
	String loadDistrictCode;
	String unloadProvinceCode;
	String unloadCityCode;
	String unloadDistrictCode;
	String loadAddress;
	String unloadAddress;
	String categoryName;
	String carType;
	String carLongs;
	String carModels;
	String weight;
	String volume;
	int payDays;
	String plateNumber;
	bool driverAgree = false;
	bool userAgree = false;
}
