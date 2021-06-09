import 'package:freightowner/generated/json/base/json_convert_content.dart';

class DeliveryDetailsEntity with JsonConvert<DeliveryDetailsEntity> {
	String id;
	String userId;
	String loadProvinceCode;
	String loadCityCode;
	String loadDistrictCode;
	String loadAddress;
	String unloadProvinceCode;
	String unloadCityCode;
	String unloadDistrictCode;
	String unloadAddress;
	String categoryName;
	//傻逼需求修改
	String weight;
	String volume;
	String carType;
	String carLongs;
	String carModels;
	String loadUnload;
	int loadStartAt;
	int loadEndAt;
	String remark;
	int createAt;
	int expectMoney;
	String expectUnit;
	String requireList;
	int status;
	int deleteStatus;
	int markStatus;
	String packageMode;
	List<DeliveryDetailsCall> calls;
}

class DeliveryDetailsCall with JsonConvert<DeliveryDetailsCall> {
	String id;
	String fromUserId;
	String goodsId;
	bool type;
	int createAt;
	String fromAvatar;
	String fromMobile;
	String fromNickname;
}
