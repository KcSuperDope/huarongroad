import 'package:get/get.dart';
import 'package:huaroad/assets/intl/intl_keys.dart';

class TimeUtil {
  static String transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    String minutesStr = minutes.toString().padLeft(2, "0");
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String millSecondsStr = (milliseconds % (1000) ~/ 10).toString().padLeft(2, '0');
    if (millSecondsStr.length > 2) {
      millSecondsStr = millSecondsStr.substring(0, 2);
    }
    return "$minutesStr:$secondsStr.$millSecondsStr";
  }

  static String formatTimeMillisV2(int time, {bool doubleLine = false}) {
    String formatTime = "未知";
    final DateTime fromTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    final String s1 = fromTime.month.toString().padLeft(2, "0");
    final String s2 = fromTime.day.toString().padLeft(2, "0");
    final String s3 = fromTime.hour.toString().padLeft(2, "0");
    final String s4 = fromTime.minute.toString().padLeft(2, "0");
    final wrap = doubleLine ? "\n" : " ";
    formatTime = "$s1-$s2$wrap$s3:$s4";
    return formatTime;
  }

  static String formatDateTime(int time) {
    String formatTime = "未知";
    final DateTime fromTime = DateTime.fromMillisecondsSinceEpoch(time);
    final String s0 = fromTime.year.toString();
    final String s1 = fromTime.month.toString().padLeft(2, "0");
    final String s2 = fromTime.day.toString().padLeft(2, "0");
    final String s3 = fromTime.hour.toString().padLeft(2, "0");
    final String s4 = fromTime.minute.toString().padLeft(2, "0");
    formatTime = "$s0/$s1/$s2 $s3:$s4";
    return formatTime;
  }

  static int currentTimeMillis() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /*
  1小时内：xx分钟前
  今日内：xx小时前
  昨天内：昨天
  昨天前但在本年内发布：xx月yy日
  本年前发布：xxxx年yy月zz日
  */
  static String formatTimeMillis(int time) {
    String formatTime = "unkonwon";
    final DateTime currentTime = DateTime.now();
    final DateTime fromTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);

    if (currentTime.year == fromTime.year) {
      //本年内的时间
      final int diffDays = currentTime.difference(fromTime).inDays;
      if (diffDays == 0) {
        //今天内的时间
        final int diffHours = currentTime.difference(fromTime).inHours;
        if (diffHours > 0) {
          formatTime = "$diffHours${S.hrsago.tr}";
        } else {
          final int diffMinute = currentTime.difference(fromTime).inMinutes;
          if (diffMinute >= 0) {
            formatTime = "$diffMinute${S.minsago.tr}";
          } else {
            formatTime = "最近";
          }
        }
      } else if (diffDays == 1) {
        //昨天
        formatTime = "昨天";
      } else {
        //昨天前本年内
        formatTime = "${fromTime.month}-${fromTime.day}";
      }
    } else {
      //本年前发布的
      formatTime = "${fromTime.year}-${fromTime.month}-${fromTime.day}";
    }
    return formatTime;
  }
}
