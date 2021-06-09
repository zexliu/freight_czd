import 'package:freightowner/model/evaluation_statistical_entity.dart';

evaluationStatisticalEntityFromJson(EvaluationStatisticalEntity data, Map<String, dynamic> json) {
	if (json['level1Count'] != null) {
		data.level1Count = json['level1Count']?.toInt();
	}
	if (json['level2Count'] != null) {
		data.level2Count = json['level2Count']?.toInt();
	}
	if (json['level3Count'] != null) {
		data.level3Count = json['level3Count']?.toInt();
	}
	return data;
}

Map<String, dynamic> evaluationStatisticalEntityToJson(EvaluationStatisticalEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['level1Count'] = entity.level1Count;
	data['level2Count'] = entity.level2Count;
	data['level3Count'] = entity.level3Count;
	return data;
}