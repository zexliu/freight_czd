
import 'package:flutterdriver/generated/json/base/json_convert_content.dart';

class EvaluationListEntity with JsonConvert<EvaluationListEntity> {
	List<EvaluationListRecord> records;
	int total;
	int size;
	int current;
	List<dynamic> orders;
	bool hitCount;
	bool searchCount;
	int pages;
}

class EvaluationListRecord with JsonConvert<EvaluationListRecord> {
	String userAvatar;
	String userName;
	String driverAvatar;
	String driverName;
	String loadProvinceCode;
	String loadCityCode;
	String loadDistrictCode;
	String unloadProvinceCode;
	String unloadCityCode;
	String unloadDistrictCode;
	String categoryName;
	String orderId;
	String userEvaluationId;
	String userTags;
	String userDescription;
	int userCreateAt;
	int userLevel;

	String driverEvaluationId;
	String driverTags;
	String driverDescription;
	int driverCreateAt;
	int driverLevel;
}
