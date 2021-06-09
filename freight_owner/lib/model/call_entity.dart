
import 'package:freightowner/generated/json/base/json_convert_content.dart';

class CallEntity with JsonConvert<CallEntity> {
	List<CallRecord> records;
	int total;
	int size;
	int current;
	List<dynamic> orders;
	bool hitCount;
	bool searchCount;
	int pages;
}

class CallRecord with JsonConvert<CallRecord> {
	String id;
	String fromUserId;
	String toUserId;
	String goodsId;
	bool type;
	int createAt;
	String fromAvatar;
	String fromMobile;
	String fromNickname;
	String toAvatar;
	String toMobile;
	String toNickname;
	String loadProvinceCode;
	String loadCityCode;
	String loadDistrictCode;
	String unloadProvinceCode;
	String unloadCityCode;
	String unloadDistrictCode;
	int goodsStatus;
	String carLongs;
	String carModels;
	String weight;
	String volume;
}
