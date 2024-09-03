import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wust_helper_ios/model/schedule_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/provider/course_color_provider.dart';
import 'package:wust_helper_ios/provider/courses_provider.dart';
import 'package:wust_helper_ios/provider/current_week_provider.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:provider/provider.dart';
import 'package:wust_helper_ios/util/course_util.dart';
import 'package:wust_helper_ios/util/mini.dart';
import 'package:wust_helper_ios/util/popup_ios_selection.dart';
import 'package:wust_helper_ios/util/string_util.dart';
import 'package:wust_helper_ios/widget/login_button.dart';
import 'package:wust_helper_ios/widget/login_input_widget.dart';

class AddCoursesPage extends StatefulWidget {
  final Courses course;

  /// 修改课程时携带参数
  /// 添加课程则提供了空白模板
  AddCoursesPage(
    this.course, {
    Key key,
  }) : super(key: key);
  @override
  _AddCoursesPageState createState() => _AddCoursesPageState();
}

class _AddCoursesPageState extends State<AddCoursesPage> {
  // 生成[空白课程]数据用以在修改后返回
  Courses course = Courses();
  bool addEnable = false;
  // List<Widget> cupertinoPikers;
  List<String> courses = [];
  List<String> weekDayList = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  List<String> sectionList = [
    '1-2节',
    '3-4节',
    '5-6节',
    '7-8节',
    '9-10节',
    '11-12节'
  ];

  String weekDaySelector = ''; // 选择器的默认值
  String sectionSelector = ''; // 选择器的默认值

  TextEditingController _classNameController = TextEditingController();
  TextEditingController _classRoomController = TextEditingController();
  TextEditingController _teachClassController = TextEditingController();
  TextEditingController _teacherController = TextEditingController();
  TextEditingController _startWeekController = TextEditingController();
  TextEditingController _endWeekController = TextEditingController();
  TextEditingController _weekdayController = TextEditingController();

  String className = '';
  String teachClass = '';
  String teacher = '';
  String classroom = '';
  String startWeek = '';
  String endWeek = '';

  @override
  void initState() {
    initInput();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var coursesProvider = context.read<CoursesProvider>();
    var courseColorProvider = context.read<CoursesColorProvider>();
    bool isMonday = context.select<CurrentWeekProvider, bool>(
        (value) => value.currentWeekIsMonday());
    return FutureBuilder(
      future: initData(coursesProvider),
      builder: (context, snapshot) {
        return Scaffold(
            appBar: AppBar(
              title: Text('添加课程'),
              // backgroundColor: darlAppBarColor.withOpacity(0.3),
              elevation: 0,
              // leading: BackButton(onPressed: () => Navigator.pop(context)),
            ),
            body: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: LoginInput(
                    '*课程名称',
                    '请输入课程名称(必填)',
                    // initValue: widget.course?.className,
                    controller: _classNameController,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      className = value;
                      _checkIsEnable();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: LoginInput(
                    '教学班',
                    '请输入教学班',
                    controller: _teachClassController,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      teachClass = value;
                      _checkIsEnable();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: LoginInput(
                    '老师',
                    '请输入老师姓名',
                    controller: _teacherController,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      teacher = value;
                      _checkIsEnable();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: LoginInput(
                    '教室',
                    '请输入教室',
                    controller: _classRoomController,
                    onChanged: (value) {
                      classroom = value;
                      _checkIsEnable();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: LoginInput(
                    '*开始周',
                    '周数：未设置（必填）',
                    controller: _startWeekController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      startWeek = value;
                      _checkIsEnable();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: LoginInput(
                    '*结束周',
                    '周数：未设置（必填）',
                    controller: _endWeekController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      endWeek = value;
                      _checkIsEnable();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: LoginInput(
                    '*上课时间',
                    '时间：未设置（必填）',
                    onfocous: didClickSelected,
                    controller: _weekdayController,
                  ),
                ),
                widget.course?.className == null
                    ? Container(
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 20, bottom: 10),
                        child: LoginButton(
                            '添加课程',
                            addEnable,
                            () => addCourse(
                                coursesProvider, courseColorProvider)))
                    : Container(
                        height: 150,
                        child: SizedBox(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 20),
                                    child: LoginButton(
                                      '删除课程',
                                      widget.course.className != '',
                                      () => removeCourse(coursesProvider,
                                          courseColorProvider, isMonday),
                                      color: Colors.red,
                                    )),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 15,
                                          bottom: 10),
                                      child: LoginButton(
                                          '保存修改',
                                          addEnable,
                                          () => addCourse(coursesProvider,
                                              courseColorProvider))))
                            ],
                          ),
                        )),
              ],
            ));
      },
    );
  }

  /// [弹出上课日与节次选择器]
  void didClickSelected() {
    weekDaySelector = weekDayList[0];
    sectionSelector = sectionList[0];
    clickSelectedCupertino(context, [
      weekDayList,
      sectionList
    ], [
      (i) => weekDaySelector = weekDayList[i],
      (i) => sectionSelector = sectionList[i]
    ], () {
      setState(() {
        weekDaySelector =
            weekDaySelector == '' ? '${weekDayList[0]}' : weekDaySelector;
        sectionSelector =
            sectionSelector == '' ? '${sectionList[0]}' : sectionSelector;
        _weekdayController.text = '$weekDaySelector $sectionSelector';
      });

      _checkIsEnable();
    });
  }

  /// [创建新的课程信息] 以替换旧课程
  Courses createCourse() {
    int weekDay = weekDayList.indexOf(weekDaySelector) + 1;
    int startWeek = int.parse(_startWeekController.text);
    int endWeek = int.parse(_endWeekController.text);
    CurrentWeekProvider currentWeekProvider =
        context.read<CurrentWeekProvider>();
    bool isMonday = currentWeekProvider.currentWeekIsMonday();

    /// 直接返回
    course = Courses(
        className: _classNameController.text,
        classroom: _classRoomController.text,
        teachClass: _teachClassController.text,
        teacher: _teacherController.text,
        startWeek: weekDay == 7 && !isMonday ? startWeek - 1 : startWeek,
        endWeek: weekDay == 7 && !isMonday ? endWeek - 1 : endWeek,
        //教务处返回的数据以前是周日为每周第一天的，现在是周一为第一天（改为下面正常版本）
        // startWeek: startWeek,
        // endWeek: endWeek,
        section: sectionList.indexOf(sectionSelector) + 1,
        weekDay: weekDay);

    return course;
  }

  /// [初始化课程数据]
  initData(CoursesProvider coursesProvider) {
    courses = coursesProvider.getCourses();
  }

  /// [初始化输入框]
  initInput() {
    if (widget.course != null) {
      _classNameController.text = widget.course.className;
      _classRoomController.text = widget.course.classroom;
      _teachClassController.text = widget.course.teachClass;
      _teacherController.text = widget.course.teacher;
      _startWeekController.text = '${widget.course.startWeek}' == 'null'
          ? ''
          : '${widget.course.startWeek}';
      _endWeekController.text = '${widget.course.endWeek}' == 'null'
          ? ''
          : '${widget.course.endWeek}';
      _weekdayController.text = widget.course.weekDay == null
          ? ''
          : '${weekDayList[widget.course.weekDay - 1]} ${sectionList[widget.course.section - 1]}';
      className = widget.course.className;
      teachClass = widget.course.teachClass;

      teacher = widget.course?.teacher;
      classroom = widget.course?.classroom;
      startWeek = '${widget.course.startWeek}';
      endWeek = '${widget.course.endWeek}';

      weekDaySelector = weekDayList[widget.course.weekDay - 1];
      sectionSelector = sectionList[widget.course.section - 1];
    } else {
      _classNameController.text = '';
      _classRoomController.text = '';
      _teachClassController.text = '';
      _teacherController.text = '';
      _startWeekController.text = '';
      _endWeekController.text = '';
      _weekdayController.text = '';
      className = '';
      teachClass = '';
      teacher = '';
      classroom = '';
      startWeek = '';
      endWeek = '';
    }
    _checkIsEnable();
  }

  /// [删除课程]
  removeCourse(CoursesProvider coursesProvider,
      CoursesColorProvider coursesColorProvider, bool isMonday) async {
    Courses currentCourse = widget.course;

    if (!isMonday) {
      currentCourse.startWeek -= 1;
      currentCourse.endWeek -= 1;
    }
    int courseIndex = courses.indexOf(json.encode(currentCourse.toJson()));
    if (courseIndex != -1) {
      courses.remove(courses[courseIndex]);
    }

    // BaseCache.getInstence().setStringList(JwcConst.courses, courses);
    BaseNavigator.getInstance().onJumpTo(RouteStatus.navigator2);

    coursesProvider.setCourses(courses);
    await updateMiniProgram(context, courses);
    setCourseColor(courses, context);
  }

  /// [添加/修改课程]
  addCourse(CoursesProvider coursesProvider,
      CoursesColorProvider coursesColorProvider) async {
    String newCourseStr = json.encode(createCourse().toJson());
    // 将原有课程删除
    int courseIndex = -1;
    if (widget.course != null) {
      courseIndex = courses.indexOf(json.encode(widget.course.toJson()));
    }

    if (courseIndex != -1) {
      courses.remove(courses[courseIndex]);
    }

    courses.add(newCourseStr);

    BaseNavigator.getInstance().onJumpTo(RouteStatus.navigator2);
    // await BaseCache.getInstence().setStringList(JwcConst.courses, courses);
    coursesProvider.setCourses(courses);
    await updateMiniProgram(context, courses);
    setCourseColor(courses, context);
  }

  /// [检查]【添加】/【修改】按钮[是否可用]
  void _checkIsEnable() {
    bool enable;
    bool isNotBland = className != '' &&
        startWeek != '' &&
        endWeek != '' &&
        weekDaySelector != '';
    // 结束周不能早于开始周
    //
    bool isLate = false;
    if (isNotEmpty(startWeek) && isNotEmpty(endWeek)) {
      isLate = int.parse(startWeek) <= int.parse(endWeek);
    }

    enable = isNotBland && isLate ? true : false;
    setState(() {
      addEnable = enable;
    });
  }
}
