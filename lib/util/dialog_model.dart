import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:scratcher/scratcher.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/model/graduate_stu_grade_model.dart';
import 'package:wust_helper_ios/model/jwc_grade_model.dart';
import 'package:wust_helper_ios/model/schedule_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/color_util.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/countdown_util.dart';
import 'package:wust_helper_ios/util/course_util.dart';
import 'package:wust_helper_ios/util/login_util.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/util/toast.dart';
import 'package:wust_helper_ios/widget/countdown_input.dart';

/// 双选项的提示卡
Future<bool> showSendDialog(BuildContext context, String title, String content,
    {String cancelWord = '取消', String confirm = '确认'}) {
  return showDialog(
    context: context,
    barrierColor: Color.fromRGBO(0, 0, 0, 0.15),
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
        content: Container(
          margin: EdgeInsets.only(top: 10),
          child: SizedBox(
              child: Text(
            content,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            textAlign: TextAlign.start,
          )),
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.of(context).pop(false),
            child: Container(
              height: 50,
              child: Center(
                  child: Text(
                cancelWord,
                style:
                    TextStyle(fontWeight: FontWeight.w400, color: Colors.red),
              )),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(true),
            child: Container(
              height: 50,
              child: Center(
                  child: Text(
                confirm,
                style: TextStyle(
                    fontWeight: FontWeight.w400, color: Colors.lightBlue),
              )),
            ),
          )
        ],
      );
    },
  );
}

/// 单选项的提示卡
Future<bool> showSingleDialog(
    BuildContext context, String title, String content,
    {String cancelWord = '知道了'}) {
  return showDialog(
    context: context,
    barrierColor: Color.fromRGBO(0, 0, 0, 0.15),
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
        content: Container(
          margin: EdgeInsets.only(top: 10),
          child: SizedBox(
              child: Text(
            content,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            textAlign: TextAlign.start,
          )),
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.of(context).pop(false),
            child: Container(
              height: 50,
              child: Center(
                  child: Text(
                cancelWord,
                style:
                    TextStyle(fontWeight: FontWeight.w400, color: Colors.red),
              )),
            ),
          ),
        ],
      );
    },
  );
}

/// 课程详情卡片组
showCourseDetails(BuildContext context, List<Courses> courses,
    Map courseAndColor, int currentWeek) async {
  double width = MediaQuery.of(context).size.width;
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Center(
          child: Wrap(
        direction: Axis.horizontal,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: getCourseDetails(courses, courseAndColor, width, currentWeek),
      ));
    },
  );
}

/// 返回课程详情卡片
List<Widget> getCourseDetails(
    List<Courses> courses, Map courseAndColor, double width, int currentWeek) {
  return courses.map((e) {
    Color textColor = hasClass(e, currentWeek) ? Colors.white : Colors.black54;
    return Container(
      height: width * 0.65,
      width: width * 0.47,
      decoration: BoxDecoration(
          color: hasClass(e, currentWeek)
              ? (e.className.endsWith("(Ta)")
                  ? Colors.pink[100]
                  : Color(transformColor('ff', courseAndColor[e.className])))
              : Colors.white70,
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: textColor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            hasClass(e, currentWeek) ? '本周' : '非本周',
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      ),
                      Text(
                        e.className,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: width * 0.015),
                          child: Text(
                            e.teacher,
                            style: TextStyle(color: textColor, fontSize: 15),
                          ),
                        ),
                        Text(
                          e.classroom,
                          style: TextStyle(color: textColor, fontSize: 15),
                        ),
                        Text(
                          e.teachClass,
                          style: TextStyle(color: textColor, fontSize: 15),
                        ),
                        Text(
                          '${e.startWeek} - ${e.endWeek}周',
                          style: TextStyle(color: textColor, fontSize: 15),
                        )
                      ]),
                ),
              ])),
    );
  }).toList();
}

/// 成绩详情卡片
showGradeDetail(BuildContext context, int loginIndex,
    {GradeData gradeData, GraduateStuGradeData graStuData, bool ifnew}) async {
  // print(Theme.of(context).brightness);
  bool ifdark = Theme.of(context).brightness == Brightness.dark;
  double width = MediaQuery.of(context).size.width;
  TextStyle gradeDetailTextStyle = TextStyle(fontSize: width * 0.04);
  await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: Container(
            width: width * 0.75,
            height: width * 0.95,
            padding: EdgeInsets.fromLTRB(50, 25, 50, 40),
            decoration: BoxDecoration(
              color: ifdark ? Colors.grey[400] : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  ///课程名称
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    '${loginIndex == 0 ? gradeData.courseName : graStuData.courseName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (ifnew)
                  Scratcher(
                    brushSize: 30,
                    threshold: 60,
                    color: Colors.lightBlue[50],
                    onChange: (value) => print("Scratch progress: $value%"),
                    onThreshold: () {
                      List<String> newCourse = BaseCache.getInstance()
                              .getStringList(GradeConst.newCourse) ??
                          [];
                      newCourse.remove(gradeData.courseNum);
                      BaseCache.getInstance()
                          .setStringList(GradeConst.newCourse, newCourse);

                      if (gradeData.gradePoint == 4.0) {
                        print(gradeData.courseCredit);
                        showToast("恭喜你满绩了！！！");
                      }
                    },
                    child:

                        ///课程成绩
                        Container(
                      // height: 100,
                      width: 100,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                                '${loginIndex == 0 ? gradeData.grade : graStuData.grade}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: width * 0.09,
                                    color: gradeData.gradePoint == 4
                                        ? Color(transformColor('ff', '#f4a73e'))
                                        : gradeData.gradePoint == 0
                                            ? Colors.red
                                            : Colors.lightBlue)),
                          ),
                          loginIndex == 0
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    '绩点：${gradeData.gradePoint}',
                                    style: TextStyle(
                                        fontSize: width * 0.04,
                                        color: Colors.black54),
                                  ))
                              : Container(),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    // height: 100,
                    width: 100,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                              '${loginIndex == 0 ? gradeData.grade : graStuData.grade}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: width * 0.09,
                                  color: gradeData.gradePoint == 4
                                      ? Color(transformColor('ff', '#f4a73e'))
                                      : gradeData.gradePoint == 0
                                          ? Colors.red
                                          : Colors.lightBlue)),
                        ),
                        loginIndex == 0
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  '绩点：${gradeData.gradePoint}',
                                  style: TextStyle(
                                      fontSize: width * 0.04,
                                      color: Colors.black54),
                                ))
                            : Container(),
                      ],
                    ),
                  ),
                //绩点显示(研究生不需要显示)

                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('学分：', style: gradeDetailTextStyle),
                        Text(
                          '${loginIndex == 0 ? gradeData.courseCredit : graStuData.courseCredit}',
                          style: gradeDetailTextStyle,
                        ),
                      ],
                    )),
                //研究生不需要显示
                loginIndex == 0
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '学时：',
                              style: gradeDetailTextStyle,
                            ),
                            Text('${gradeData.courseHours}',
                                style: gradeDetailTextStyle),
                          ],
                        ))
                    : Container(),
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '考核方式：',
                          style: gradeDetailTextStyle,
                        ),
                        Text(
                          '${loginIndex == 0 ? gradeData.evaluationMode : "考试"}',
                          style: gradeDetailTextStyle,
                        ),
                      ],
                    )),
                //
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '考试性质：',
                          style: gradeDetailTextStyle,
                        ),
                        Text(
                          '${loginIndex == 0 ? gradeData.examNature : "正常考试"}',
                          style: gradeDetailTextStyle,
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '开课学期：',
                          style: gradeDetailTextStyle,
                        ),
                        Text(
                          '${loginIndex == 0 ? gradeData.schoolTerm : graStuData.term}',
                          style: gradeDetailTextStyle,
                        ),
                      ],
                    )),
              ],
            ),
          ),
        );
      });
}

/// 绩点分段卡片
showLevelList(BuildContext context) async {
  double width = MediaQuery.of(context).size.width;
  await showDialog(
    context: context,
    builder: (context) => Center(
        child: Container(
      width: width * 0.85,
      height: width * 1.2,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: FractionallySizedBox(
          child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.lightBlue[300],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Center(
                    child: Text(
                      '绩点分段',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w400),
                    ),
                  ))),
          Expanded(
            flex: 15,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 3.0, right: 3.0, top: 3.0, bottom: 5.0),
              child: Image.asset('assets/images/绩点分段.png'),
            ),
          ),
        ],
      )),
    )),
  );
}

/// F1学分计算结果卡片
showF1Dialog(BuildContext context, double f1Num, TickerProvider state,
    {String stuAge = '全部'}) async {
  double width = MediaQuery.of(context).size.width;
  AnimationController _animationController = AnimationController(
      vsync: state, value: 0.0, duration: Duration(milliseconds: 600));

  Animation animation =
      CurvedAnimation(parent: _animationController, curve: Curves.ease);

  await showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            width: width * 0.75,
            height: width * 0.50,
            padding: EdgeInsets.fromLTRB(50, 25, 50, 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 0),
                    child: Center(
                        child: Text(
                      stuAge + '学年',
                      style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ))),
                Container(
                    margin: EdgeInsets.only(bottom: 6),
                    child: Center(
                      child: Text(
                        'F1学分计',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    )),
                f1Animation(_animationController, animation, f1Num),
              ],
            ),
          ),
        );
      });
}

//f1计算动画
Widget f1Animation(
  AnimationController _animationController,
  Animation animation,
  double f1Num,
) {
  _animationController.forward();
  return F1Animation(
    f1: f1Num,
    animation: animation,
  );
}

class F1Animation extends AnimatedWidget {
  final double f1;
  final Widget child;

  F1Animation({
    @required this.f1,
    this.child,
    animation,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable;
    var animationValue = Tween(begin: 0.0, end: f1).evaluate(animation);
    double text = animationValue >= 0.0 ? animationValue : 0.0;

    return Center(
      child: Text(
        '${text.toStringAsFixed(4)}',
        style: TextStyle(
            fontSize: 38, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}

///倒计时卡片
showCountdownCard(BuildContext context, String title, bool isAddCountdown,
    {String courseNameContent,
    String examTimeContent,
    String notesContent,
    String uuid}) async {
  ///添加倒计时参数
  String courseName; //课程名称
  String examTime; //考试时间
  String notes; //备注
  ///修改倒计时参数
  TextEditingController courseController;
  TextEditingController examController;
  TextEditingController notesController;
  if (courseNameContent != null && examTimeContent != null) {
    courseController = TextEditingController(text: courseNameContent);
    examController = TextEditingController(text: examTimeContent);
    notesController = TextEditingController(text: notesContent);
  }
  //获取屏幕大小
  double width = MediaQuery.of(context).size.width;
  TextStyle countdownTextStyle = TextStyle(fontSize: width * 0.04);

  await showDialog(
    context: context,
    builder: (context) => Center(
      child: Container(
          width: width * 0.9,
          height: width * 0.8,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: Icon(Icons.arrow_back),
                  ),
                  Spacer(
                    flex: 3,
                  ),
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Spacer(),
                  isAddCountdown == false
                      ? TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            BaseNavigator.getInstance()
                                .onJumpTo(RouteStatus.shareCountdown, args: {
                              "uuid": uuid,
                              "courseName": courseNameContent,
                            });
                          },
                          child: Image.asset(
                            'assets/images/qrImage.png',
                            width: 20.0,
                            height: 20.0,
                          ),
                        )
                      : Spacer(
                          flex: 2,
                        ),
                  IconButton(
                    onPressed: () async {
                      if (courseName == null) {
                        showToast('请输入课程名称哦~');
                      } else if (examTime == null) {
                        showToast("请输入考试时间哦~");
                      } else {
                        bool isSaveSuccess;
                        if (isAddCountdown) {
                          isSaveSuccess = await sendAddCountdownRequest(
                              courseName, examTime, notes);
                        } else {
                          isSaveSuccess = await modifyCountdownRequest(
                              courseController.text,
                              examController.text,
                              notesController.text,
                              uuid);
                        }

                        if (isSaveSuccess == true) {
                          showToast("保存成功");
                          Navigator.of(context).pop(true);
                        } else {
                          showToast('保存失败');
                        }
                      }
                    },
                    icon: Icon(Icons.check),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CountdownInput(
                    title: "课程名称：",
                    hint: "输入考试内容",
                    controller: courseController,
                    countdownTextStyle: countdownTextStyle,
                    onChanged: (value) {
                      courseName = value;
                    },
                  ),
                  CountdownInput(
                    title: "考试时间：",
                    hint: "点击选择时间",
                    controller: examController,
                    countdownTextStyle: countdownTextStyle,
                    onChanged: (value) {
                      examTime = value;
                    },
                  ),
                  CountdownInput(
                    title: "备注：",
                    hint: "输入考试地点，注意事项等",
                    controller: notesController,
                    countdownTextStyle: countdownTextStyle,
                    onChanged: (value) {
                      notes = value;
                    },
                  ),
                ],
              )
            ],
          )),
    ),
  );
}

///物理实验登陆卡片
showWLSYcard(BuildContext context, String stuNum) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return WLSYcard(
          stuNum: stuNum,
        );
      });
}

//
class WLSYcard extends StatefulWidget {
  final String stuNum;
  const WLSYcard({Key key, this.stuNum}) : super(key: key);

  @override
  State<WLSYcard> createState() => _WLSYcardState();
}

class _WLSYcardState extends State<WLSYcard> {
  double screenWidth = ScreenUtil.getInstance().screenWidth;
  TextEditingController _stuPwdController;
  String stuNum;
  String jwcPwd;
  //是否在加载
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    stuNum = widget.stuNum;
    _stuPwdController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: screenWidth * 0.9,
        height: screenWidth * 0.73,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 10.0,
            left: 20.0,
            right: 15.0,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "物理实验登陆",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                child: Text(
                  "学号",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.0,
                  ),
                ),
              ),
              Text(
                stuNum,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 18.0,
                ),
              ),
              Divider(
                color: Colors.grey[600],
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 0.1 * screenWidth * 0.7, bottom: 20.0),
                child: TextField(
                  controller: _stuPwdController,
                  decoration: InputDecoration(
                    hintText: "物理实验密码",
                    hintTextDirection: TextDirection.ltr,
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18.0,
                    ),
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    jwcPwd = value;
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "密码是物理实验预约系统的密码",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: TextButton(
                  onPressed: () async {
                    // showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return Center(
                    //         child: Container(
                    //           width: 150,
                    //           height: 150,
                    //           decoration: BoxDecoration(
                    //               color: Colors.black12,
                    //               borderRadius: BorderRadius.circular(10)),
                    //           child: Padding(
                    //               padding: EdgeInsets.all(45),
                    //               child: CircularProgressIndicator(
                    //                 strokeWidth: 6,
                    //               )),
                    //         ),
                    //       );
                    //     });

                    bool isSuccess =
                        BaseCache.getInstance().get(WlsyConst.wlsyIsLogin) ??
                            false;
                    if (isSuccess) {
                      Navigator.of(context).pop(false);
                      BaseNavigator.getInstance()
                          .onJumpTo(RouteStatus.wlsyPage);
                    } else {
                      jwcPwd = _stuPwdController.text;
                      if (jwcPwd.isNotEmpty) {
                        HubUtil.show(msg: "登陆中... ");
                        isSuccess = await wlsyLogin(context, jwcPwd);
                        HubUtil.dismiss();
                        //TODO 应作修改，传入密钥key
                        isSuccess
                            ? BaseNavigator.getInstance()
                                .onJumpTo(RouteStatus.wlsyPage)
                            : null;

                        BaseCache.getInstance()
                            .setBool(WlsyConst.wlsyIsLogin, isSuccess);

                        Navigator.of(context).pop(false);
                      } else {
                        showToast("请输入密码");
                      }
                    }
                  },
                  child: Text(
                    "确认",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
