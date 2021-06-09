import 'package:freightowner/generated/json/base/json_convert_content.dart';

class SimpleDriverEntity with JsonConvert<SimpleDriverEntity> {
	List<SimpleDriverRecord> records;
	int total;
	int size;
	int current;
	List<dynamic> orders;
	bool hitCount;
	bool searchCount;
	int pages;
}

class SimpleDriverRecord with JsonConvert<SimpleDriverRecord> {
	String id;
	String username;
	String mobile;
	String nickname;
	String avatar;
	int createAt;
	String carLong;
	String carModel;
}
