import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/http/dao/jwc_dao.dart';
import 'package:wust_helper_ios/model/schedule_model.dart';
import 'package:wust_helper_ios/model/unsccessful_model.dart';
import 'package:wust_helper_ios/provider/course_color_provider.dart';
import 'package:wust_helper_ios/util/common.dart';

import 'package:wust_helper_ios/util/request_util.dart';
import 'package:wust_helper_ios/util/toast.dart';

/*
 * 匹配对应关系(主要用于匹配每节课对应的颜色)
 * weekday => index
 * section => row
*/
Courses getCourse(List<String> courses, int row, int index) {
  bool isMonday =
      BaseCache.getInstance().get(ScheduleConst.currentMondayTime) ?? true;
  if (courses != null) {
    List<Courses> coursesList = courses
        .map<Courses>((course) => Courses.fromJson(json.decode(course)))
        .toList();
    for (int i = 0; i < coursesList?.length; i++) {
      if (coursesList[i].section == row &&
          (coursesList[i].weekDay ==
              (isMonday ? (index % 7 + 1) : (index + 6) % 7 + 1))) {
        return coursesList[i];
      }
    }
  }
  return null;
}

/*
 * 找到课程（按名字）
 * 随机赋值颜色
 * 在颜色数组中剔除已使用的颜色
 * 将未使用的颜色保存至本地
 */
setCourseColor(List<String> courses, BuildContext context) async {
  List<String> _colors = [];
  List<Courses> coursesList = courses
      .map<Courses>((course) => Courses.fromJson(json.decode(course)))
      .toList();
  CoursesColors.forEach((color) => _colors.add(color));
  Map<String, String> courseAndColor = {};
  for (var i = 0; i < coursesList.length; i++) {
    int j = 0;
    if (courseAndColor[coursesList[i].className] == null) {
      courseAndColor[coursesList[i].className] = _colors[j];
      _colors.remove(_colors[j]);
      if (_colors == []) {
        CoursesColors.forEach((color) => _colors.add(color));
      }
      j++;
    }
  }
  await context.read<CoursesColorProvider>().setCourseAndColor(courseAndColor);
  // if (_colors.length != 0)
  //   await context.read<CoursesColorProvider>().setColors(_colors);
}

bool hasClass(Courses courses, int currentWeek) {
  return currentWeek >= courses.startWeek && currentWeek <= courses.endWeek;
}

/// 发送[课表数据]请求
Future<List<String>> sendCoursesRequest(BuildContext context, int loginIndex,
    {bool isMonday = true,
    String currentTerm,
    ToastGravity toastGravity = ToastGravity.CENTER}) async {
  Map args = {JwcConst.currentTerm: currentTerm};
  List<String> courses = [];
  String token;
  try {
    BaseCache baseCache = BaseCache.getInstance();
    token = baseCache.get<String>(JwcConst.token);
    var result;
    if (loginIndex == 0) {
      result = await JwcDao.getSchedule(token, args: args);
    } else if (loginIndex == 1) {
      result = await JwcDao.graduateStuSchedule(token);
    }

    if (isSuccessful(result)) {
      courses = ScheduleModel.fromJson(result).data.map((e) {
        /// [教务处设置周一为第一天，故应进行处理]
        /// [首先判断用户设置每周第一天为]
        if (!isMonday) {
          if (e.weekDay == 7) {
            e.startWeek += 1;
            e.endWeek += 1;
          }
        }
        return json.encode(e.toJson());
      }).toList();

      await baseCache.setStringList(JwcConst.courses, courses);
      baseCache.setBool(ScheduleConst.switchCPSchedule, true);
      await setCourseColor(courses, context);
    }
    String msg = UnsccessfulModel.fromJson(result).msg;
    if (msg == "success") {
      showToast("教务处课表获取成功～", toastGravity: toastGravity);
    } else {
      showToast(msg, toastGravity: toastGravity);
    }
  } catch (e) {
    showToast('获取课表失败！');
  }

  return courses;
}

Future<bool> sendCPCoursesRequest(
    BuildContext context, int loginIndex, String token,
    {bool isMonday = true,
    String currentTerm,
    ToastGravity toastGravity = ToastGravity.CENTER}) async {
  Map args = {JwcConst.currentTerm: currentTerm};
  List<String> courses = [];

  try {
    BaseCache baseCache = BaseCache.getInstance();

    var result;
    if (loginIndex == 0) {
      result = await JwcDao.getSchedule(token, args: args);
    } else if (loginIndex == 1) {
      result = await JwcDao.graduateStuSchedule(token);
    }

    if (isSuccessful(result)) {
      courses = ScheduleModel.fromJson(result).data.map((e) {
        if (!isMonday) {
          if (e.weekDay == 7) {
            e.startWeek += 1;
            e.endWeek += 1;
          }
        }
        e.className = e.className + "(Ta)";
        return json.encode(e.toJson());
      }).toList();
      await baseCache.setStringList(ScheduleConst.cpSchedule, courses);
      baseCache.setBool(ScheduleConst.switchCPSchedule, false);
      await setCourseColor(courses, context);
    }
    String msg = UnsccessfulModel.fromJson(result).msg;
    if (msg == "success") {
      showToast("教务处课表获取成功～", toastGravity: toastGravity);
    } else {
      showToast(msg, toastGravity: toastGravity);
    }
  } catch (e) {
    showToast('获取课表失败！');
  }
  return true;
}

Future<void> switchSchedule(BuildContext context, bool isMe) async {
  List<String> courses = [];
  ToastGravity toastGravity = ToastGravity.CENTER;
  BaseCache baseCache = BaseCache.getInstance();
  try {
    if (isMe)
      courses = baseCache.getStringList(ScheduleConst.cpSchedule);
    else
      courses = baseCache.getStringList(JwcConst.courses);
    print(courses[0]);
    if (courses?.length != 0 && courses != null) {
      showToast("切换成功！", toastGravity: toastGravity);
    } else {
      // showToast("你好像还没有cp～", toastGravity: toastGravity);
      throw Exception();
    }
    await setCourseColor(courses, context);
    baseCache.setBool(ScheduleConst.switchCPSchedule, !isMe);
  } catch (e) {
    showToast('你好像还没有cp～');
  }
}

void clearCPSchedule(BuildContext context) async {
  List<String> courses = [];
  BaseCache baseCache = BaseCache.getInstance();
  baseCache.setStringList(ScheduleConst.cpSchedule, []);
  baseCache.setBool(ScheduleConst.switchCPSchedule, true);
  courses = baseCache.getStringList(JwcConst.courses);
  await setCourseColor(courses, context);
  showToast('已清理情侣课表');
}
