import 'package:freightowner/generated/json/base/json_convert_content.dart';
import 'package:freightowner/model/dict_entry_entity.dart';


class CategoryEntity with JsonConvert<CategoryEntity> {
	List<CategoryRecord> records;
	int total;
	int size;
	int current;
	List<dynamic> orders;
	bool hitCount;
	bool searchCount;
	int pages;
}

class CategoryRecord with JsonConvert<CategoryRecord> {
	String id;
	String categoryName;
	String categoryCode;
	String parentId;
	String description;
	int createAt;
	int seq;
	bool isHot;
	List<CategoryRecord> children;
	List<DictEntryRecord> dictEntries;
}
