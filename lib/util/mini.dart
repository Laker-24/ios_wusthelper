import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wust_helper_ios/model/schedule_model.dart';
import 'package:wust_helper_ios/provider/course_color_provider.dart';
import 'package:wust_helper_ios/provider/current_week_provider.dart';

import 'package:provider/provider.dart';

/*
 *          小组件（桌面小插件）
 *  
 */
updateMiniProgram(BuildContext context, List<String> courses) async {
  //因小组件不能实时刷新当前周，所以不能直接传当前周进去
  // int current = context.read<CurrentWeekProvider>().currentWeek;
  //锚点
  int anchorPoint = context.read<CurrentWeekProvider>().getAnchorPoint();
  int anchorPointWeek =
      context.read<CurrentWeekProvider>().getAnchorPointWeek();
  // bool isMonday = context.select<CurrentWeekProvider, bool>(
  //     (value) => value.currentWeekIsMonday());
  bool isLake = context.read<CurrentWeekProvider>().getIsLakeArea();
  Map<String, String> colors =
      context.read<CoursesColorProvider>().getCourseAndColor();
  List<Map<String, dynamic>> _list = [];
  MethodChannel channel =
      MethodChannel("com.linghangstudio.wusthelper.TodaySchedule");

  courses.forEach((e) {
    Courses course = Courses.fromJson(json.decode(e));
    _list.add(course.toJson());
  });
  try {
    await channel.invokeMethod("updateWidgetData", {
      "courses": _list,
      "anchorPoint": anchorPoint,
      "anchorPointWeek": anchorPointWeek,
      "isLake": isLake,
      "colors": colors,
      // "isMonday": isMonday,
    });
  } catch (e) {
    print(e);
  }
}
