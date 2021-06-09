import 'package:freightowner/generated/json/base/json_convert_content.dart';

class DeliverGoodsEntity with JsonConvert<DeliverGoodsEntity> {
	List<DeliverGoodsRecord> records;
	int total;
	int size;
	int current;
	List<dynamic> orders;
	bool hitCount;
	bool searchCount;
	int pages;
}

class DeliverGoodsRecord with JsonConvert<DeliverGoodsRecord> {
	String id;
	String userId;
	String loadProvinceCode;
	String loadCityCode;
	String loadDistrictCode;
	String loadAddress;
	String loadWayProvinceCode;
	String loadWayCityCode;
	String loadWayDistrictCode;
	String loadWayAddress;
	String unloadProvinceCode;
	String unloadCityCode;
	String unloadDistrictCode;
	String unloadAddress;
	String unloadWayProvinceCode;
	String unloadWayCityCode;
	String unloadWayDistrictCode;
	String unloadWayAddress;
	String categoryName;
	//发货改的傻逼需求
	String weight;
	//发货改的傻逼需求
	String volume;
	String carType;
	String carLongs;
	double carPlaceLong;
	String carModels;
	String loadUnload;
	int loadStartAt;
	int loadEndAt;
	String remark;
	String requireList;
	double expectMoney;
	String expectUnit;
	int createAt;
	int status;
	int deleteStatus;
	int markStatus;
	double loadLat;
	double loadLon;
	double loadWayLat;
	double loadWayLon;
	double unloadLat;
	double unloadLon;
	double unloadWayLat;
	double unloadWayLon;
	String packageMode;
	int callCount;
	int lookCount;

}
