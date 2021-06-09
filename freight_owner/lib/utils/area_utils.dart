

import 'package:freightowner/model/area_entity.dart';

import '../global.dart';
class AreaUtils{

  static String getCityAndDistrictName(String provinceCode,String cityCode,String districtCode){

    var province = Global.areas.firstWhere((element) => element.value == provinceCode);

    var city  =  province.children.firstWhere((element) => element.value == cityCode);

    var district = city.children.firstWhere((element) => element.value == districtCode);

    return "${city.label} ${district.label}";

  }

  static AreaEntity findProvince(String provinceCode){
    return Global.areas.firstWhere((element) => element.value == provinceCode);
  }

  static AreaEntity findCity(String provinceCode, String cityCode){
    var province = Global.areas.firstWhere((element) => element.value == provinceCode);
    return province.children.firstWhere((element) => element.value == cityCode);
  }

  static AreaEntity findDistrict(String provinceCode, String cityCode,String districtCode){

    var province = Global.areas.firstWhere((element) => element.value == provinceCode);

    var city  =  province.children.firstWhere((element) => element.value == cityCode);

    return  city.children.firstWhere((element) => element.value == districtCode);
  }
}


