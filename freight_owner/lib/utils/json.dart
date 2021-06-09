
import 'dart:convert';

import 'package:freightowner/generated/json/base/json_convert_content.dart';

class JsonUtils{
  static  List<T> convertList<T>(String jsonStr){
    List<dynamic> list = json.decode(jsonStr);
    List<T> result = [];
    list.forEach((item){
      result.add(JsonConvert.fromJsonAsT(item));
    });
    return result;
  }
}