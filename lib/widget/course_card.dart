import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wust_helper_ios/model/schedule_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/provider/course_color_provider.dart';
import 'package:wust_helper_ios/provider/courses_provider.dart';
import 'package:wust_helper_ios/provider/current_week_provider.dart';
import 'package:wust_helper_ios/util/color_util.dart';
import 'package:wust_helper_ios/util/common.dart';

class CourseCard extends StatefulWidget {
  final Courses course;
  final String courseColor;
  final Function handleTap;

  CourseCard(this.course, this.courseColor, {Key key, this.handleTap})
      : super(key: key);
  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    //当前周
    int currentWeek =
        context.select<CurrentWeekProvider, int>((value) => value.currentWeek);
    // int anchorPoint = context
    //     .select<CurrentWeekProvider, int>((value) => value.getAnchorPoint());
    // int anchorPointWeek = context.select<CurrentWeekProvider, int>(
    //     (value) => value.getAnchorPointWeek());
    // int now = context.select<CurrentWeekProvider, int>((value) => value.now);
    return Consumer3<CurrentWeekProvider, CoursesProvider,
        CoursesColorProvider>(
      builder: (context,
          CurrentWeekProvider currentWeekProvider,
          CoursesProvider coursesProvider,
          CoursesColorProvider coursesColorProvider,
          child) {
        // caculateCurrentWeek(now, anchorPoint, anchorPointWeek);
        //将以下字符删除
        List<String> classroom = widget.course.classroom
            .replaceAll('(黄家湖)', '')
            .replaceAll('(汽车学院)', '')
            .replaceAll('(管理学院)', '')
            .split('楼');

        classroom = [
          classroom[0],
          ...classroom.length > 1 ? classroom[1].split('区') : []
        ];
        return Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(1.5, 3.0),
                      blurRadius: 5),
                ],
                color: currentWeek >= widget.course.startWeek &&
                        currentWeek <= widget.course.endWeek
                    ? Color(
                        transformColor('C8', widget.courseColor),
                      )
                    : Color(transformColor('CF', '#dcdcdc')),
                borderRadius: BorderRadius.circular(10)),
            child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 1,
                child: InkWell(
                    onTap: widget.handleTap ?? () {},
                    onLongPress: () {
                      BaseNavigator.getInstance().onJumpTo(
                          RouteStatus.addCourse,
                          args: {'course': widget.course});
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      heightFactor: 0.8,
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 2),
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 1, right: 1, top: 2),
                                //课程名称显示
                                child: Text(
                                  '${widget.course.className}',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: currentWeek >=
                                                  widget.course.startWeek &&
                                              currentWeek <=
                                                  widget.course.endWeek
                                          ? Colors.white
                                          : Colors.grey,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Padding(
                                padding: EdgeInsets.only(left: 1, right: 1),
                                child: Column(
                                  children: [
                                    //教学楼显示
                                    Text(
                                      '${classroom[0]}${classroom.length > 1 ? '楼' : ''}',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      //当前课程是否在所在周数内，不在的课程用灰颜色显示
                                      style: TextStyle(
                                          color: currentWeek >=
                                                      widget.course.startWeek &&
                                                  currentWeek <=
                                                      widget.course.endWeek
                                              ? Colors.white
                                              : Colors.grey,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    //部分教学楼出现 区
                                    classroom.length > 1
                                        ? Text(
                                            '${classroom[1]}${(classroom[0] == '恒大' || classroom[0] == '教十一' || classroom[0] == '教二') ? '区' : ''}',
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: currentWeek >=
                                                            widget.course
                                                                .startWeek &&
                                                        currentWeek <=
                                                            widget
                                                                .course.endWeek
                                                    ? Colors.white
                                                    : Colors.grey,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : Container(),
                                    classroom.length > 2
                                        ? Text(
                                            '${classroom[2]}',
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: currentWeek >=
                                                            widget.course
                                                                .startWeek &&
                                                        currentWeek <=
                                                            widget
                                                                .course.endWeek
                                                    ? Colors.white
                                                    : Colors.grey,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : Container(),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ))));
      },
    );
  }
}
