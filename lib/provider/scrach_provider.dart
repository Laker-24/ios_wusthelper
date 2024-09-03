import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/util/common.dart';

class ScrachProvider extends ChangeNotifier{
  bool get scrach=>BaseCache.getInstance().get(ScheduleConst.scrach)??false;
  // List<String> get newCourse=>BaseCache.getInstance().getStringList(GradeConst.newCourse)??[];
  setScrach(bool scrach){
    BaseCache.getInstance().setBool(ScheduleConst.scrach, scrach);
    BaseCache.getInstance(). setStringList(GradeConst.newCourse, []);
    notifyListeners();
  }
}