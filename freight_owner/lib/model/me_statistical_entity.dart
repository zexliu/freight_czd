import 'package:freightowner/generated/json/base/json_convert_content.dart';

class MeStatisticalEntity with JsonConvert<MeStatisticalEntity> {
	double transactionAmount = 0;
	int deliveryCount = 0;
	int orderCount = 0;
}
