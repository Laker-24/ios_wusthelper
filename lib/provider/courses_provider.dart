import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/util/common.dart';

class CoursesProvider extends ChangeNotifier {
  List<String> _courses;

  List<String> getCourses() {
    _courses = BaseCache.getInstance().getStringList(JwcConst.courses);
    return _courses;
  }

  List<String> getCPCourses() {
    bool isMe =
        BaseCache.getInstance().get(ScheduleConst.switchCPSchedule) ?? true;
    if (isMe)
      _courses = BaseCache.getInstance().getStringList(JwcConst.courses);
    else
      _courses =
          BaseCache.getInstance().getStringList(ScheduleConst.cpSchedule) ?? [];
    return _courses;
  }

  setCourses(List<String> courses) {
    BaseCache.getInstance().setStringList(JwcConst.courses, courses);
    BaseCache.getInstance().setBool(ScheduleConst.switchCPSchedule, true);
    notifyListeners();
  }

  setCPCourses(List<String> courses) {
    BaseCache.getInstance().setStringList(ScheduleConst.cpSchedule, courses);
    notifyListeners();
  }

  bool get showCourse =>
      BaseCache.getInstance().get<bool>('showCourse') ?? true;
  setShowCourse(bool showCourse) {
    BaseCache.getInstance().setBool('showCourse', showCourse);
    notifyListeners();
  }
}
