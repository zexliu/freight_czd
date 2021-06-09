
import 'package:flutterdriver/generated/json/base/json_convert_content.dart';

class DictEntryEntity with JsonConvert<DictEntryEntity> {
	List<DictEntryRecord> records;
	int total;
	int size;
	int current;
	List<dynamic> orders;
	bool hitCount;
	bool searchCount;
	int pages;
}

class DictEntryRecord with JsonConvert<DictEntryRecord> {
	String id;
	String dictCode;
	String dictEntryName;
	String dictEntryValue;
	String description;
	int createAt;
	int seq;
	bool enable;
}
