import 'package:flutter/widgets.dart';

import 'model/area_entity.dart';
import 'model/user_entity.dart';

class Global{
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static UserEntity userEntity;

  static isAuthenticated() {
    if(Global.userEntity == null){
      return false;
    }
    var hasRole = false;
    for (int i = 0; i < Global.userEntity.roles.length; i++) {
      var role = Global.userEntity.roles[i];
      if (role.roleCode == "DRIVER") {
        hasRole = true;
      }
    }
    return hasRole;
  }


  static String defaultNoneString  = "NONE";

  static List<AreaEntity> areas;

}


