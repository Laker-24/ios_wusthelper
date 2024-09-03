import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wust_helper_ios/model/schedule_model.dart';
import 'package:wust_helper_ios/provider/course_color_provider.dart';
import 'package:wust_helper_ios/provider/courses_provider.dart';
import 'package:wust_helper_ios/provider/current_week_provider.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/dialog_model.dart';
import 'package:wust_helper_ios/util/mini.dart';
import 'package:wust_helper_ios/widget/bland_card.dart';
import 'package:wust_helper_ios/widget/course_card.dart';
import 'package:provider/provider.dart';

/*
 *     课表设计页面
 */
class CoursesListItem extends StatelessWidget {
  //总共42节课，index表示第几节
  final int index;
  const CoursesListItem(
    this.index, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //得到所有课程
    List<String> courses = context.watch<CoursesProvider>().getCPCourses();
    //当前周数
    int currentWeek =
        context.select<CurrentWeekProvider, int>((value) => value.currentWeek);
    //是否展示所有课程
    bool showCourse =
        context.select<CoursesProvider, bool>((value) => value.showCourse);
    //得到每个课表所对应的颜色
    Map<String, String> courseAndColor =
        context.watch<CoursesColorProvider>().getCourseAndColor();
    //判断每周第一天为
    bool isMonday = context.select<CurrentWeekProvider, bool>(
        (value) => value.currentWeekIsMonday());

    //返回一个整数的除法，如 5～/2 == 2
    int row = (index ~/ 7) + 1;

    /// 查找当前节次上的所有课程
    List<Courses> coursesList = courses
        .map<Courses>((course) => Courses.fromJson(json.decode(course)))
        .toList();
    //需要显示的课程
    List<Courses> neededCourses = [];
    //若周日为每周第一天，则进行处理(因为教务处现在是以周一为每周首天)
    if (!isMonday) {
      for (int i = 0; i < coursesList.length; i++) {
        if (coursesList[i].weekDay == 7) {
          coursesList[i].startWeek += 1;
          coursesList[i].endWeek += 1;
        }
      }
    }
    // updateMiniProgram(context, jsonDecode(coursesList.toString()));
    int i = 0;
    for (i = 0; i < coursesList?.length; i++) {
      //首先判断节数，然后判断星期
      if (coursesList[i].section == row &&
          coursesList[i].weekDay ==
              (isMonday ? index % 7 + 1 : (index + 6) % 7 + 1)) {
        neededCourses.add(coursesList[i]);
      }
    }

    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
            child: Padding(
                padding: EdgeInsets.all(2),
                child: Consumer2<CoursesProvider, CurrentWeekProvider>(
                    builder: (context, courseProvider, currentProvider, child) {
                  /// 优先显示本周课程
                  List<Courses> currentCourses = [];
                  for (var i = 0; i < neededCourses?.length; i++) {
                    if (neededCourses[i].startWeek <= currentWeek &&
                        neededCourses[i].endWeek >= currentWeek) {
                      currentCourses.add(neededCourses[i]);
                    }
                  }
                  if (!showCourse) {
                    // 显示本周没有的课，并去重
                    currentCourses =
                        [...currentCourses, ...neededCourses].toSet().toList();
                  }
                  return currentCourses.length != 0 //判断单元格上有没有课程
                      ? CourseCard(
                          currentCourses[0],
                          courseAndColor['${currentCourses[0].className}'],
                          handleTap: () => showCourseDetails(context,
                              currentCourses, courseAndColor, currentWeek),
                        )
                      : BlandCard();
                }))));
  }
}
