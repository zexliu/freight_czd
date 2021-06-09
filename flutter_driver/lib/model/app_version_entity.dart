import 'package:flutterdriver/generated/json/base/json_convert_content.dart';

class AppVersionEntity with JsonConvert<AppVersionEntity> {
	String id;
	String downloadUrl;
	int versionCode;
	String versionName;
	String content;
	int createAt;
	bool isForce;
	String sha256checksum;
}
