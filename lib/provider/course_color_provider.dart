import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/util/common.dart';

class CoursesColorProvider extends ChangeNotifier {
  Map _courseAndColor;
  List<String> _colors;
  Map<String, String> getCourseAndColor() {
    if (BaseCache.getInstance().get<String>(ScheduleConst.courseAndColor) !=
        null)
      _courseAndColor = Map<String, String>.from(JsonDecoder().convert(
          BaseCache.getInstance().get<String>(ScheduleConst.courseAndColor)));
    return _courseAndColor;
  }

  List<String> getColors() {
    _colors = BaseCache.getInstance().get<List<String>>(ScheduleConst.colors);
    return _colors;
  }

  setCourseAndColor(Map<String, String> courseAndColor) {
    BaseCache.getInstance().setString(
        ScheduleConst.courseAndColor, JsonEncoder().convert(courseAndColor));
    notifyListeners();
  }

  setColors(List<String> colors) {
    BaseCache.getInstance().setStringList(ScheduleConst.colors, colors);
    notifyListeners();
  }
}
