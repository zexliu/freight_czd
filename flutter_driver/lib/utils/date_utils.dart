import 'package:intl/intl.dart';

class DateUtils{
  static getTimeString(int loadStartAt, int loadEndAt) {
    String day = "";
    String time = "";
    var format = DateFormat("yyyy-MM-dd");
    var loadAt = DateTime.fromMillisecondsSinceEpoch(loadStartAt);
    var endAt = DateTime.fromMillisecondsSinceEpoch(loadEndAt);
    DateTime now = DateTime.now();
    if (loadAt.year == now.year &&
        loadAt.month == now.month &&
        loadAt.day == now.day) {
      day = "今天";
      if (endAt.year == now.year &&
          endAt.month == now.month &&
          endAt.day == now.day + 1) {
        day = "今天或明天";
      }
    } else if (endAt.year == now.year &&
        endAt.month == now.month &&
        endAt.day == now.day + 1) {
      day = "明天";
    } else {
      day = format.format(loadAt);
    }
    if (loadAt.hour != 18 && endAt.hour == 23) {
      time = "全天";
    } else if (loadAt.hour == 0 && endAt.hour == 5) {
      time = "凌晨";
    } else if (loadAt.hour == 6 && endAt.hour == 11) {
      time = "上午";
    } else if (loadAt.hour == 12 && endAt.hour == 17) {
      time = "下午";
    } else {
      time = "晚上";
    }
    return "$day $time";
  }


  static getDayString(int loadStartAt, int loadEndAt) {
    String day = "";
    var format = DateFormat("yyyy-MM-dd");
    var loadAt = DateTime.fromMillisecondsSinceEpoch(loadStartAt);
    var endAt = DateTime.fromMillisecondsSinceEpoch(loadEndAt);
    DateTime now = DateTime.now();
    if (loadAt.year == now.year &&
        loadAt.month == now.month &&
        loadAt.day == now.day) {
      day = "今天";
      if (endAt.year == now.year &&
          endAt.month == now.month &&
          endAt.day == now.day + 1) {
        day = "今天或明天";
      }
    } else if (endAt.year == now.year &&
        endAt.month == now.month &&
        endAt.day == now.day + 1) {
      day = "明天";
    } else {
      day = format.format(loadAt);
    }

    return "$day";
  }


  static getHourString(int loadStartAt, int loadEndAt) {
    String time = "";
    var loadAt = DateTime.fromMillisecondsSinceEpoch(loadStartAt);
    var endAt = DateTime.fromMillisecondsSinceEpoch(loadEndAt);

    if (loadAt.hour != 18 && endAt.hour == 23) {
      time = "全天";
    } else if (loadAt.hour == 0 && endAt.hour == 5) {
      time = "凌晨";
    } else if (loadAt.hour == 6 && endAt.hour == 11) {
      time = "上午";
    } else if (loadAt.hour == 12 && endAt.hour == 17) {
      time = "下午";
    } else {
      time = "晚上";
    }
    return "$time";
  }



  static String diffDay(int loadStartAt, int unloadEndAt) {
    if(unloadEndAt == null){
      return "-";
    }
    var loadAt = DateTime.fromMillisecondsSinceEpoch(loadStartAt);
    var endAt = DateTime.fromMillisecondsSinceEpoch(unloadEndAt);
    var difference = endAt.difference(loadAt);
    return "${difference.inDays}";

  }
}