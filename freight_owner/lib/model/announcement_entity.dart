import 'package:freightowner/generated/json/base/json_convert_content.dart';

class AnnouncementEntity with JsonConvert<AnnouncementEntity> {
	List<AnnouncementRecords> records;
	int total;
	int size;
	int current;
	List<dynamic> orders;
	bool hitCount;
	bool searchCount;
	int pages;
}

class AnnouncementRecords with JsonConvert<AnnouncementRecords> {
	String id;
	String title;
	String content;
	int createAt;
	int announcementType;
	String params;
	bool validStatus;
}
