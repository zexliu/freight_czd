import 'package:flutterdriver/generated/json/base/json_convert_content.dart';

class OftenLineEntity with JsonConvert<OftenLineEntity> {
	List<OftenLineRecord> records;
	int total;
	int size;
	int current;
	List<dynamic> orders;
	bool hitCount;
	bool searchCount;
	int pages;
}

class OftenLineRecord with JsonConvert<OftenLineRecord> {
	String id;
	String userId;
	String loadAreas;
	String unloadAreas;
	String carLongs;
	String carModels;
	int createAt;
}
