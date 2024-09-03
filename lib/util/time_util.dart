import 'dart:convert';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/model/admin_time_model.dart';
import 'package:wust_helper_ios/provider/current_week_provider.dart';
import 'package:wust_helper_ios/util/common.dart';

/// 计算当前周
///  [周一为每周第一天计算逻辑：]
///  [当前周 = （当前时间 - 锚点）/ 时间单位 + 锚点周数 ]
///  [锚点本身是一个时间戳]
/// [周日为第一天的逻辑]
/// [当前周 = （当前时间 - 锚点六天后的时间）/时间单位 +锚点周数 + 1]
/// [相当于从锚点的下一周的周日开始计算]
int caculateCurrentWeek(int anchorPoint, int anchorPointWeek,
    {bool isMonday = true}) {
  int _currentWeek;

  int toBeProcessedNum =
      (DateTime.now().millisecondsSinceEpoch - (anchorPoint ?? 0));
  // 未开学统一返回 -1
  if (isMonday) {
    _currentWeek = toBeProcessedNum < 0
        ? -1
        : (toBeProcessedNum ~/ (1000 * 60 * 60 * 24 * 7)) +
            (anchorPointWeek ?? 0);
  } else {
    int currentWeek =
        (toBeProcessedNum ~/ (1000 * 60 * 60 * 24 * 6)) + anchorPointWeek;
    if (toBeProcessedNum < 0) {
      _currentWeek = -1;
    } else if (currentWeek == 2) {
      _currentWeek = currentWeek;
    } else {
      toBeProcessedNum = DateTime.now().millisecondsSinceEpoch -
          DateTime.fromMillisecondsSinceEpoch(anchorPoint)
              .add(Duration(days: 6))
              .millisecondsSinceEpoch;
      _currentWeek = ((toBeProcessedNum) ~/ (1000 * 60 * 60 * 24 * 7)) +
          anchorPointWeek +
          1;
    }
  }

  return _currentWeek;
}

initAnchorPoint(int anchorPoint) async {
  CurrentWeekProvider().setAnchorPoint(anchorPoint);
  CurrentWeekProvider().setAnchorPointWeek(1);
  CurrentWeekProvider().setCurrentWeek(null);
}

setSchoolTime(AdminTimeData data) async {
  BaseCache cache = BaseCache.getInstance();
  await cache.setString(JwcConst.currentTerm, data.currentTerm);
  await cache.setString(
      JwcConst.termList, JsonEncoder().convert(data.termSetting));
  List timeList = data.termSetting[data.currentTerm]
      .split('-')
      .map((e) => int.parse(e))
      .toList();

  DateTime anchorPoint = DateTime(timeList[0], timeList[1], timeList[2]);
  initAnchorPoint(anchorPoint.millisecondsSinceEpoch);
}

String saveDateTime(DateTime dateTime) {
  StringBuffer stringBuffer = StringBuffer();
  stringBuffer
    ..writeAll([
      dateTime.year,
      "-",
      dateTime.month,
      "-",
      dateTime.day,
      "-",
      dateTime.hour,
      "-",
      dateTime.minute,
    ]);
  return stringBuffer.toString();
}

//两个datetime相差的分钟(dateTime2是datetime.toString())
int differMinute(DateTime nowTime, String dateTime2) {
  //2021-09-25 20:22:13.995743
  List<String> dateTime = dateTime2.split('-');
  DateTime preTime = DateTime(
    int.parse(dateTime[0]),
    int.parse(dateTime[1]),
    int.parse(dateTime[2]),
    int.parse(dateTime[3]),
    int.parse(dateTime[4]),
  );
  return nowTime.difference(preTime).inMinutes;
}
