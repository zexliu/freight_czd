import 'package:intl/intl.dart';

extension DateExtension on DateTime{

  String toZhString(){
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return dateFormat.format(this);
  }


}