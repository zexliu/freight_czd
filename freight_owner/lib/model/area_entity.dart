
import 'package:freightowner/generated/json/base/json_convert_content.dart';

class AreaEntity with JsonConvert<AreaEntity> {
	String value;
	String label;
	double latitude;
	double longitude;
	List<AreaEntity> children;
}
