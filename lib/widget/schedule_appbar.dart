import 'dart:convert';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/provider/courses_provider.dart';
import 'package:wust_helper_ios/provider/current_week_provider.dart';
import 'package:wust_helper_ios/provider/schedule_provider.dart';
import 'package:wust_helper_ios/provider/title_time_provider.dart';
import 'package:wust_helper_ios/util/aes256.dart';
import 'package:wust_helper_ios/util/color_util.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/course_util.dart';
import 'package:wust_helper_ios/util/dialog_model.dart';
import 'package:wust_helper_ios/util/grade_util.dart';
import 'package:wust_helper_ios/util/mini.dart';
import 'package:wust_helper_ios/util/popup_ios_selection.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/util/time_util.dart';

class ScheduleAppBar extends StatefulWidget {
  final VoidCallback load;
  final DateTime mondayTime;
  final int currentWeekday;
  const ScheduleAppBar(
    this.currentWeekday,
    this.load, {
    Key key,
    this.mondayTime,
  }) : super(key: key);
  @override
  _ScheduleAppBarState createState() => _ScheduleAppBarState();
}

class _ScheduleAppBarState extends State<ScheduleAppBar>
    with SingleTickerProviderStateMixin {
  List<String> currentWeekList = [];
  String currentWeekStr;
  //迷你课表是否弹出
  bool isExpanded = false;
  //设置动画，弹出和收回
  Animation animationIn, animationOut;
  //动画控制器
  AnimationController _animationController;
  // int realCurrentWeekday; // 记录真实的工作日，方便返回
  _ScheduleAppBarState();
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      value: 0.0,
      duration: Duration(milliseconds: 400),
    );
    //设置动画曲线
    animationIn = CurvedAnimation(
        parent: _animationController, curve: Curves.easeOut); //动画过程：开始快，后面慢
    animationOut = CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticIn); //动画过程：其幅度在超出其界限时增加。
  }

  _toggleExpanded() {
    if (_animationController.value != 0) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    //每周第一天为
    bool isMonday = context.select<CurrentWeekProvider, bool>(
        (value) => value.currentWeekIsMonday());
    //得到锚点
    int anchorPoint = context
        .select<CurrentWeekProvider, int>((value) => value.getAnchorPoint());
    //锚点所在的周数
    int anchorPointWeek = context.select<CurrentWeekProvider, int>(
        (value) => value.getAnchorPointWeek());
    //得到所有课程
    var coursesProvider = context.watch<CoursesProvider>();
    List<String> courses = coursesProvider.getCPCourses();
    //当前周
    int current =
        context.select<CurrentWeekProvider, int>((value) => value.currentWeek);
    int currentWeek =
        caculateCurrentWeek(anchorPoint, anchorPointWeek, isMonday: isMonday);
    //判断登录方式(本科生0 研究生1 )
    int loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex) ?? 0;
    // int loginIndex = 0;
    //动画
    ScrollController _scrollController =
        ScrollController(initialScrollOffset: 60.0 * (currentWeek - 1));

    return Container(
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FractionallySizedBox(
              child: Stack(alignment: Alignment.center, children: [
                Container(
                  // decoration: BoxDecoration(color: Colors.white),
                  alignment: Alignment.center,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: InkWell(
                              onTap: () {
                                _toggleExpanded();
                                if (_animationController.value != 0) {
                                  CurrentWeekProvider provider =
                                      context.read<CurrentWeekProvider>();
                                  provider.setCurrentWeek(caculateCurrentWeek(
                                      anchorPoint, anchorPointWeek));
                                  context
                                      .read<TitleTimeProvider>()
                                      .setCurrentWeekday(widget.currentWeekday);
                                }

                                context
                                    .read<TitleTimeProvider>()
                                    .setTitleTime(0, widget.mondayTime);
                              },
                              child: SizedBox(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 1),
                                      child: Text(
                                        currentWeek == -1
                                            ? '休假中'
                                            : '第$currentWeek周',
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 1),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ))),
                      // SizedBox(
                      //   child: Container(
                      //     margin: EdgeInsets.only(
                      //         left: 10, right: 5, top: 2, bottom: 2),
                      //     child: InkWell(
                      //       onTap: () async {},
                      //       child: Icon(
                      //         question_mark_rounded,
                      //         color: Colors.black54,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: 10, right: 5, top: 2, bottom: 2),
                              child: InkWell(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 5, top: 2, bottom: 2),
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Image.asset(
                                      'assets/images/scan.png',
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                onTap: () => BaseNavigator.getInstance()
                                    .onJumpTo(RouteStatus.qrScanner),
                              ),
                            ),

                            /// [刷新课表]
                            Container(
                              margin: EdgeInsets.only(
                                  left: 10, right: 5, top: 2, bottom: 2),
                              child: InkWell(
                                onTap: () async {
                                  bool refresh = await showSendDialog(
                                          context,
                                          '确认刷新并返回当前学期课表',
                                          '此操作会返回当前学期课表，并删除您手动添加到课程(包括物理实验课程)，还原所有教务处预制课程，是否确认？') ??
                                      false;
                                  List<String> courses;
                                  if (refresh) {
                                    // widget.load();
                                    HubUtil.show(msg: "正在更新课程表");
                                    //重新请求获取教务处课表
                                    courses = await sendCoursesRequest(
                                      context,
                                      loginIndex,
                                      isMonday: isMonday,
                                    );
                                    HubUtil.dismiss();
                                    //将物理实验课表导入状态恢复为未导入
                                    BaseCache.getInstance()
                                        .setBool(WlsyConst.wlsyIsImport, false);
                                    if (courses?.length != 0 &&
                                        courses != null) {
                                      coursesProvider.setCourses(courses);
                                      await updateMiniProgram(context, courses);
                                    }
                                  }
                                },
                                child: Icon(
                                  Icons.loop,
                                  color: Colors.black54,
                                ),
                              ),
                            ),

                            /// [小菜单]
                            Container(
                              margin: EdgeInsets.only(
                                  left: 5, right: 15, top: 2, bottom: 2),
                              child: PopupMenuButton(
                                offset: Offset(0, 50),
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.black54,
                                ),
                                //此方法为点击某一项后使popupmenu消失后调用
                                onSelected: (value) =>
                                    handleMenuSelected(value),
                                itemBuilder: (context) =>
                                    <PopupMenuEntry<ScheduleChoises>>[
                                  menuPopupMenuItem(
                                    ScheduleChoises.setShowCourse,
                                    'assets/images/visible.webp',
                                    title: '显示全部课程',
                                    widget: Expanded(
                                      child: Consumer<CoursesProvider>(
                                        builder: (context, value, child) {
                                          bool show = context
                                              .select<CoursesProvider, bool>(
                                                  (value) => value.showCourse);
                                          return Checkbox(
                                            value: !show,
                                            onChanged: (bool value) {
                                              coursesProvider.setShowCourse(
                                                  !coursesProvider.showCourse);
                                                  
                                            },checkColor: Colors.lightBlue,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  menuPopupMenuItem(
                                      ScheduleChoises.setCurrentWeek,
                                      'assets/images/term.png',
                                      title: '选择当前周'),
                                  menuPopupMenuItem(
                                    ScheduleChoises.setLakeTime,
                                    'assets/images/campus.webp',
                                    child: Consumer<CurrentWeekProvider>(
                                      builder: (context, value, child) {
                                        bool isLakeArea = context.select<
                                                CurrentWeekProvider, bool>(
                                            (value) => value.getIsLakeArea());
                                        return Text(
                                          '切换校区时间(当前：${isLakeArea ? '湖' : '青'})',
                                          style: TextStyle(fontSize: 13),
                                        );
                                      },
                                    ),
                                  ),
                                  menuPopupMenuItem(
                                      ScheduleChoises.setChangeWeek,
                                      'assets/images/edit_week.webp',
                                      title: "课表日程设置"),
                                  loginIndex == 0
                                      ? menuPopupMenuItem(
                                          ScheduleChoises.setChangeCurrentTerm,
                                          'assets/images/semester.webp',
                                          title: "选择课程学期",
                                        )
                                      : null,
                                  menuPopupMenuItem(
                                    ScheduleChoises.setBg,
                                    'assets/images/set_background.webp',
                                    child: Consumer<ScheduleProvider>(
                                      builder: (context, value, child) {
                                        bool isCartoon = context.select<
                                                ScheduleProvider, bool>(
                                            (value) => value.getIsCartoonBg());
                                        return Text(
                                          '切换背景（当前：${isCartoon ? '卡通' : '自定义'}）',
                                          style: TextStyle(fontSize: 13),
                                        );
                                      },
                                    ),
                                  ),
                                  menuPopupMenuItem(ScheduleChoises.setChangeBg,
                                      'assets/images/set.png',
                                      title: '设置背景图片'),
                                  loginIndex == 0
                                      ? menuPopupMenuItem(
                                          ScheduleChoises.setScheduleMode,
                                          'assets/images/cp.png',
                                          title: '切换情侣课表',
                                        )
                                      : null,
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ]),
            ),
            CollapsAnimation(
              animation: isExpanded ? animationOut : animationIn,
              child: Container(
                child: OverflowBox(
                  // maxHeight: 80,
                  child: ListView.builder(
                    itemCount: 25,
                    itemExtent: 60,
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, builderIndex) {
                      TitleTimeProvider timeProvider =
                          context.read<TitleTimeProvider>();
                      return GestureDetector(
                        onTap: () {
                          int diff;
                          if (currentWeek != -1) {
                            diff = builderIndex + 1 - currentWeek;
                          } else {
                            diff = builderIndex + 1;
                          }

                          timeProvider.setTitleTime(diff, widget.mondayTime);

                          if (builderIndex + 1 !=
                              caculateCurrentWeek(
                                  anchorPoint, anchorPointWeek)) {
                            timeProvider.setCurrentWeekday(-1);
                          } else {
                            timeProvider
                                .setCurrentWeekday(widget.currentWeekday);
                          }
                          context
                              .read<CurrentWeekProvider>()
                              .setCurrentWeek(builderIndex + 1);
                        },

                        /// 单个[迷你课表]
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: current == (builderIndex + 1)
                                    ? Colors.white
                                    : null),
                            margin: EdgeInsets.all(3.0),
                            child: FractionallySizedBox(
                              widthFactor: 1,
                              heightFactor: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Text(
                                      '第${builderIndex + 1}周',
                                      // style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                    /// [迷你课表的大小]只有在这里限制
                                    /// 原点大小随该宽度变化而变化，在内部设置其圆角及半径有极限
                                    /// 只有靠外部容器宽度限制
                                    width: 35,
                                    child: GridView.builder(
                                        itemCount: 42,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 7),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return OverflowBox(
                                              child: Consumer<CoursesProvider>(
                                            builder: (context, value, child) {
                                              return Container(
                                                  margin: EdgeInsets.only(
                                                      left: 1,
                                                      right: 1,
                                                      top: 1),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: hasClass(
                                                          courses,
                                                          builderIndex,
                                                          index)));
                                            },
                                          ));
                                        }),
                                  ),
                                  builderIndex + 1 == currentWeek
                                      ? Padding(
                                          padding: EdgeInsets.all(2),
                                          child: Text(
                                            '本周',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            )),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// [右上角菜单的选择回调]
  handleMenuSelected(value) {
    switch (value) {

      /// [是否显示全部课程]
      case ScheduleChoises.setShowCourse:
        CoursesProvider coursesProvider = context.read<CoursesProvider>();
        coursesProvider.setShowCourse(!coursesProvider.showCourse);
        break;

      ///[切换校区]
      case ScheduleChoises.setLakeTime:
        CurrentWeekProvider isLakeProvider =
            context.read<CurrentWeekProvider>();
        isLakeProvider.setIsLakeArea(!isLakeProvider.getIsLakeArea());
        print(EncodeUtil.getEncoode("2002416x"));
        break;

      ///[设置当前周]
      case ScheduleChoises.setCurrentWeek:
        currentWeekList = [];
        for (var i = 1; i <= 25; i++) currentWeekList.add('第$i周');
        // List<Widget> pikers = [currentWeekPiker(currentWeekList)];
        currentWeekStr = currentWeekList[0];
        clickSelectedCupertino(context, [currentWeekList],
            [(i) => currentWeekStr = currentWeekList[i]], () {
          currentWeekStr = currentWeekStr.replaceAll('第', '');
          currentWeekStr = currentWeekStr.replaceAll('周', '');
          int anchorPointWeek = int.parse(currentWeekStr);
          CurrentWeekProvider currentWeekProvider =
              context.read<CurrentWeekProvider>();
          int anchorPoint = widget.mondayTime.millisecondsSinceEpoch;
          currentWeekProvider.setAnchorPoint(anchorPoint);
          currentWeekProvider.setAnchorPointWeek(anchorPointWeek);
          currentWeekProvider.setCurrentWeek(
              caculateCurrentWeek(anchorPoint, anchorPointWeek));
        });
        break;

      ///[设置每周第一天为周日]
      case ScheduleChoises.setChangeWeek:
        BaseNavigator.getInstance().onJumpTo(RouteStatus.scheduleSetting);
        break;

      ///[选择学期课表]
      case ScheduleChoises.setChangeCurrentTerm:
        //获取管理端的所有学期
        List<String> _termList = [];
        //当前学期（默认显示）
        String currentTerm = " ";
        //当前学期位于List中的第几个数据
        int index = 0;
        // int loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex);
        int loginIndex = 0;

        ///得到从入学到现在的学期
        _termList = termList();
        //发送请求
        _changeCurrentTerm() async {
          await sendCoursesRequest(context, loginIndex,
              currentTerm: currentTerm);
          widget.load();
        }
        //弹出齿轮选项dialog
        clickSelectedCupertino(context, [
          _termList
        ], [
          (i) {
            index = i;
          }
        ], () {
          currentTerm = _termList[index];
          if (currentTerm != " ") {
            widget.load();
            _changeCurrentTerm();
          }
        }, currentTerm: BaseCache.getInstance().get(JwcConst.currentTerm));
        break;

      ///[切换背景]
      case ScheduleChoises.setBg:
        ScheduleProvider scheduleProvider = context.read<ScheduleProvider>();
        scheduleProvider.setIsCartoonBg(!scheduleProvider.getIsCartoonBg());
        break;

      ///[设置背景图片]
      case ScheduleChoises.setChangeBg:
        BaseNavigator.getInstance().onJumpTo(RouteStatus.background);
        break;

      case ScheduleChoises.setScheduleMode:
        bool isMe =
            BaseCache.getInstance().get(ScheduleConst.switchCPSchedule) ?? true;
        switchSchedule(context, isMe);
        // await clearCPSchedule(context);
        //将物理实验课表导入状态恢复为未导入

        break;
      default:
    }
  }

//右上角菜单的每一个item
  Widget menuPopupMenuItem(ScheduleChoises value, String imagePath,
      {String title, Widget widget, Widget child, Function onTap}) {
    return PopupMenuItem(
      value: value,
      child: FractionallySizedBox(
        widthFactor: 1.0,
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: 2,
                ),
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(imagePath),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 5,
                  right: 2,
                ),
                child: child ??
                    Text(
                      title,
                      style: TextStyle(fontSize: 13),
                    ),
              ),
              widget ?? Container(),
            ],
          ),
        ),
      ),
    );
  }

  // currentWeekPiker(List<String> currentWeekList) {
  //   return CupertinoPicker(
  //     itemExtent: 50,
  //     onSelectedItemChanged: (index) {
  //       setState(() {
  //         currentWeekStr = currentWeekList[index];
  //       });
  //     },
  //     children: currentWeekList.map((data) {
  //       return Center(
  //         child: Text(data),
  //       );
  //     }).toList(),
  //   );
  // }

  /// [迷你课表颜色]
  /// 用于匹配迷你课表的颜色
  ///（因为周日的课未做处理，所以周日为每周第一天时显示会不正确，可修改可不修改）
  hasClass(List courses, int builderIndex, int index) {
    var course = getCourse(courses, (index ~/ 7) + 1, index);
    if (course != null) {
      if (builderIndex + 1 >= course.startWeek &&
          builderIndex + 1 <= course.endWeek) {
        return Color(transformColor('FF', '#7bb8ff'));
      }
    }
    return Colors.black12;
  }
}

/// [迷你课表弹出动画]
class CollapsAnimation extends AnimatedWidget {
  CollapsAnimation({key, animation, this.child})
      : super(
          key: key,
          listenable: animation,
        );

  final Widget child;
  final Tween tween = Tween<double>(begin: 0, end: 80);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable;

    double animationValue = tween.evaluate(animation);
    double height = animationValue >= 0.0 ? animationValue : 0.0;
    return Container(
      decoration: BoxDecoration(color: Colors.black12),
      height: height,
      child: height >= 80
          ? child
          : FractionallySizedBox(
              heightFactor: 1,
              widthFactor: 1,
            ),
    );
  }
}

enum ScheduleChoises {
  setCurrentWeek,
  setLakeTime,
  setBg,
  setChangeWeek,
  setShowCourse,
  setChangeBg,
  setChangeCurrentTerm,
  setScheduleMode
}




// import 'dart:convert';
// import 'package:flustars/flustars.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:wust_helper_ios/db/base_cache.dart';
// import 'package:wust_helper_ios/navigator/base_navigator.dart';
// import 'package:wust_helper_ios/provider/courses_provider.dart';
// import 'package:wust_helper_ios/provider/current_week_provider.dart';
// import 'package:wust_helper_ios/provider/schedule_provider.dart';
// import 'package:wust_helper_ios/provider/title_time_provider.dart';
// import 'package:wust_helper_ios/util/aes256.dart';
// import 'package:wust_helper_ios/util/color_util.dart';
// import 'package:wust_helper_ios/util/common.dart';
// import 'package:wust_helper_ios/util/course_util.dart';
// import 'package:wust_helper_ios/util/dialog_model.dart';
// import 'package:wust_helper_ios/util/mini.dart';
// import 'package:wust_helper_ios/util/popup_ios_selection.dart';
// import 'package:wust_helper_ios/util/time_util.dart';

// class ScheduleAppBar extends StatefulWidget {
//   final VoidCallback load;
//   final DateTime mondayTime;
//   final int currentWeekday;
//   const ScheduleAppBar(
//     this.currentWeekday,
//     this.load, {
//     Key key,
//     this.mondayTime,
//   }) : super(key: key);
//   @override
//   _ScheduleAppBarState createState() => _ScheduleAppBarState();
// }

// class _ScheduleAppBarState extends State<ScheduleAppBar>
//     with SingleTickerProviderStateMixin {
//   List<String> currentWeekList = [];
//   String currentWeekStr;
//   //迷你课表是否弹出
//   bool isExpanded = false;
//   //设置动画，弹出和收回
//   Animation animationIn, animationOut;
//   //动画控制器
//   AnimationController _animationController;
//   // int realCurrentWeekday; // 记录真实的工作日，方便返回
//   _ScheduleAppBarState();
//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       vsync: this,
//       value: 0.0,
//       duration: Duration(milliseconds: 400),
//     );
//     //设置动画曲线
//     animationIn = CurvedAnimation(
//         parent: _animationController, curve: Curves.easeOut); //动画过程：开始快，后面慢
//     animationOut = CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.elasticIn); //动画过程：其幅度在超出其界限时增加。
//   }

//   _toggleExpanded() {
//     if (_animationController.value != 0) {
//       _animationController.reverse();
//     } else {
//       _animationController.forward();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     //每周第一天为
//     bool isMonday = context.select<CurrentWeekProvider, bool>(
//         (value) => value.currentWeekIsMonday());
//     //得到锚点
//     int anchorPoint = context
//         .select<CurrentWeekProvider, int>((value) => value.getAnchorPoint());
//     //锚点所在的周数
//     int anchorPointWeek = context.select<CurrentWeekProvider, int>(
//         (value) => value.getAnchorPointWeek());
//     //得到所有课程
//     var coursesProvider = context.watch<CoursesProvider>();
//     List<String> courses = coursesProvider.getCourses();
//     //当前周
//     int current =
//         context.select<CurrentWeekProvider, int>((value) => value.currentWeek);
//     int currentWeek =
//         caculateCurrentWeek(anchorPoint, anchorPointWeek, isMonday: isMonday);
//     //判断登录方式(本科生0 研究生1 )
//     // int loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex) ?? 0;
//     int loginIndex = 0;
//     //动画
//     ScrollController _scrollController =
//         ScrollController(initialScrollOffset: 60.0 * (currentWeek - 1));

//     return Container(
//       child: SizedBox(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             FractionallySizedBox(
//               child: W rap(
//                 children: [
//                   Stack(alignment: Alignment.center, children: [
//                     Container(
//                       decoration: BoxDecoration(color: Colors.white),
//                       alignment: Alignment.center,
//                       height: 50,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                               padding: EdgeInsets.only(left: 15),
//                               child: InkWell(
//                                   onTap: () {
//                                     _toggleExpanded();
//                                     if (_animationController.value != 0) {
//                                       CurrentWeekProvider provider =
//                                           context.read<CurrentWeekProvider>();
//                                       provider.setCurrentWeek(
//                                           caculateCurrentWeek(
//                                               anchorPoint, anchorPointWeek));
//                                       context
//                                           .read<TitleTimeProvider>()
//                                           .setCurrentWeekday(
//                                               widget.currentWeekday);
//                                     }

//                                     context
//                                         .read<TitleTimeProvider>()
//                                         .setTitleTime(0, widget.mondayTime);
//                                   },
//                                   child: SizedBox(
//                                     child: Row(
//                                       children: [
//                                         Padding(
//                                           padding: EdgeInsets.only(
//                                               left: 5, right: 1),
//                                           child: Text(
//                                             currentWeek == -1
//                                                 ? '休假中'
//                                                 : '第$currentWeek周',
//                                             style: TextStyle(
//                                                 fontSize: 25,
//                                                 color: Colors.black),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: EdgeInsets.only(left: 1),
//                                           child: IconButton(
//                                             icon:
//                                                 Icon(Icons.keyboard_arrow_down),
//                                             onPressed: () {
//                                               setState(() {
//                                                 isExpanded = !isExpanded;
//                                               });
//                                             },
//                                             color: Colors.black,
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ))),
//                           // SizedBox(
//                           //   child: Container(
//                           //     margin: EdgeInsets.only(
//                           //         left: 10, right: 5, top: 2, bottom: 2),
//                           //     child: InkWell(
//                           //       onTap: () async {},
//                           //       child: Icon(
//                           //         question_mark_rounded,
//                           //         color: Colors.black54,
//                           //       ),
//                           //     ),
//                           //   ),
//                           // ),
//                           SizedBox(
//                             child: Row(
//                               children: [
//                                 /// [刷新课表]
//                                 Container(
//                                   margin: EdgeInsets.only(
//                                       left: 10, right: 5, top: 2, bottom: 2),
//                                   child: InkWell(
//                                     onTap: () async {
//                                       bool refresh = await showSendDialog(
//                                               context,
//                                               '确认刷新并返回当前学期课表',
//                                               '此操作会返回当前学期课表，并删除您手动添加到课程(包括物理实验课程)，还原所有教务处预制课程，是否确认？') ??
//                                           false;
//                                       List<String> courses;
//                                       if (refresh) {
//                                         widget.load();
//                                         //重新请求获取教务处课表
//                                         courses = await sendCoursesRequest(
//                                           context,
//                                           loginIndex,
//                                           isMonday: isMonday,
//                                         );
//                                         widget.load();
//                                         //将物理实验课表导入状态恢复为未导入
//                                         BaseCache.getInstance().setBool(
//                                             WlsyConst.wlsyIsImport, false);
//                                         if (courses?.length != 0 &&
//                                             courses != null) {
//                                           coursesProvider.setCourses(courses);
//                                           await updateMiniProgram(
//                                               context, courses);
//                                         }
//                                       }
//                                     },
//                                     child: Icon(
//                                       Icons.loop,
//                                       color: Colors.black54,
//                                     ),
//                                   ),
//                                 ),

//                                 /// [小菜单]
//                                 Container(
//                                   margin: EdgeInsets.only(
//                                       left: 5, right: 15, top: 2, bottom: 2),
//                                   child: PopupMenuButton(
//                                     offset: Offset(0, 50),
//                                     icon: Icon(
//                                       Icons.more_vert,
//                                       color: Colors.black54,
//                                     ),
//                                     //此方法为点击某一项后使popupmenu消失后调用
//                                     onSelected: (value) =>
//                                         handleMenuSelected(value),
//                                     itemBuilder: (context) =>
//                                         <PopupMenuEntry<ScheduleChoises>>[
//                                       menuPopupMenuItem(
//                                         ScheduleChoises.setShowCourse,
//                                         'assets/images/visible.webp',
//                                         title: '显示全部课程',
//                                         widget: Expanded(
//                                           child: Consumer<CoursesProvider>(
//                                             builder: (context, value, child) {
//                                               bool show = context.select<
//                                                       CoursesProvider, bool>(
//                                                   (value) => value.showCourse);
//                                               return Checkbox(
//                                                 value: !show,
//                                                 onChanged: (bool value) {
//                                                   coursesProvider.setShowCourse(
//                                                       !coursesProvider
//                                                           .showCourse);
//                                                 },
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       ),
//                                       menuPopupMenuItem(
//                                           ScheduleChoises.setCurrentWeek,
//                                           'assets/images/term.png',
//                                           title: '选择当前周'),
//                                       menuPopupMenuItem(
//                                         ScheduleChoises.setLakeTime,
//                                         'assets/images/campus.webp',
//                                         child: Consumer<CurrentWeekProvider>(
//                                           builder: (context, value, child) {
//                                             bool isLakeArea = context.select<
//                                                     CurrentWeekProvider, bool>(
//                                                 (value) =>
//                                                     value.getIsLakeArea());
//                                             return Text(
//                                               '切换校区时间(当前：${isLakeArea ? '湖' : '青'})',
//                                               style: TextStyle(fontSize: 13),
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                       menuPopupMenuItem(
//                                           ScheduleChoises.setChangeWeek,
//                                           'assets/images/edit_week.webp',
//                                           title: "课表日程设置"),
//                                       loginIndex == 0
//                                           ? menuPopupMenuItem(
//                                               ScheduleChoises
//                                                   .setChangeCurrentTerm,
//                                               'assets/images/semester.webp',
//                                               title: "选择课程学期",
//                                             )
//                                           : null,
//                                       menuPopupMenuItem(
//                                         ScheduleChoises.setBg,
//                                         'assets/images/set_background.webp',
//                                         child: Consumer<ScheduleProvider>(
//                                           builder: (context, value, child) {
//                                             bool isCartoon = context
//                                                 .select<ScheduleProvider, bool>(
//                                                     (value) =>
//                                                         value.getIsCartoonBg());
//                                             return Text(
//                                               '切换背景（当前：${isCartoon ? '卡通' : '自定义'}）',
//                                               style: TextStyle(fontSize: 13),
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                       menuPopupMenuItem(
//                                           ScheduleChoises.setChangeBg,
//                                           'assets/images/set.png',
//                                           title: '设置背景图片'),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ]),
//                 ],
//               ),
//             ),
//             AnimatedCrossFade(
//               // animation: isExpanded ? animationOut : animationIn,
//               firstChild: Container(),
//               crossFadeState: isExpanded
//                   ? CrossFadeState.showSecond
//                   : CrossFadeState.showFirst,
//               firstCurve: Curves.easeInCirc,
//               // secondCurve: Curves.easeInToLinear,
//               // sizeCurve: Curves.fastOutSlowIn,
//               //  sizeCurve: Curves.fastOutSlowIn,

//               sizeCurve: Curves.easeInOutCirc,
//               duration: Duration(milliseconds: 1000),
//               secondChild: Container(
//                 height: 80,
//                 child: ListView.builder(
//                   itemCount: 25,
//                   itemExtent: 60,
//                   controller: _scrollController,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, builderIndex) {
//                     TitleTimeProvider timeProvider =
//                         context.read<TitleTimeProvider>();
//                     return GestureDetector(
//                       onTap: () {
//                         int diff;
//                         if (currentWeek != -1) {
//                           diff = builderIndex + 1 - currentWeek;
//                         } else {
//                           diff = builderIndex + 1;
//                         }

//                         timeProvider.setTitleTime(diff, widget.mondayTime);

//                         if (builderIndex + 1 !=
//                             caculateCurrentWeek(anchorPoint, anchorPointWeek)) {
//                           timeProvider.setCurrentWeekday(-1);
//                         } else {
//                           timeProvider.setCurrentWeekday(widget.currentWeekday);
//                         }
//                         context
//                             .read<CurrentWeekProvider>()
//                             .setCurrentWeek(builderIndex + 1);
//                       },

//                       /// 单个[迷你课表]
//                       child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: current == (builderIndex + 1)
//                                   ? Colors.white
//                                   : null),
//                           margin: EdgeInsets.all(3.0),
//                           child: FractionallySizedBox(
//                             widthFactor: 1,
//                             heightFactor: 1,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Padding(
//                                   padding: EdgeInsets.all(2),
//                                   child: Text(
//                                     '第${builderIndex + 1}周',
//                                     // style: TextStyle(color: Colors.black),
//                                   ),
//                                 ),
//                                 Container(
//                                   /// [迷你课表的大小]只有在这里限制
//                                   /// 原点大小随该宽度变化而变化，在内部设置其圆角及半径有极限
//                                   /// 只有靠外部容器宽度限制
//                                   width: 35,
//                                   child: GridView.builder(
//                                       itemCount: 42,
//                                       gridDelegate:
//                                           SliverGridDelegateWithFixedCrossAxisCount(
//                                               crossAxisCount: 7),
//                                       shrinkWrap: true,
//                                       physics: NeverScrollableScrollPhysics(),
//                                       itemBuilder: (context, index) {
//                                         return OverflowBox(
//                                             child: Consumer<CoursesProvider>(
//                                           builder: (context, value, child) {
//                                             return Container(
//                                                 margin: EdgeInsets.only(
//                                                     left: 1, right: 1, top: 1),
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             100),
//                                                     color: hasClass(courses,
//                                                         builderIndex, index)));
//                                           },
//                                         ));
//                                       }),
//                                 ),
//                                 builderIndex + 1 == currentWeek
//                                     ? Padding(
//                                         padding: EdgeInsets.all(2),
//                                         child: Text(
//                                           '本周',
//                                           style: TextStyle(fontSize: 10),
//                                         ),
//                                       )
//                                     : Container()
//                               ],
//                             ),
//                           )),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// [右上角菜单的选择回调]
//   handleMenuSelected(value) {
//     switch (value) {

//       /// [是否显示全部课程]
//       case ScheduleChoises.setShowCourse:
//         CoursesProvider coursesProvider = context.read<CoursesProvider>();
//         coursesProvider.setShowCourse(!coursesProvider.showCourse);
//         break;

//       ///[切换校区]
//       case ScheduleChoises.setLakeTime:
//         CurrentWeekProvider isLakeProvider =
//             context.read<CurrentWeekProvider>();
//         isLakeProvider.setIsLakeArea(!isLakeProvider.getIsLakeArea());
//         print(EncodeUtil.getEncoode("2002416x"));
//         break;

//       ///[设置当前周]
//       case ScheduleChoises.setCurrentWeek:
//         currentWeekList = [];
//         for (var i = 1; i <= 25; i++) currentWeekList.add('第$i周');
//         // List<Widget> pikers = [currentWeekPiker(currentWeekList)];
//         currentWeekStr = currentWeekList[0];
//         clickSelectedCupertino(context, [currentWeekList],
//             [(i) => currentWeekStr = currentWeekList[i]], () {
//           currentWeekStr = currentWeekStr.replaceAll('第', '');
//           currentWeekStr = currentWeekStr.replaceAll('周', '');
//           int anchorPointWeek = int.parse(currentWeekStr);
//           CurrentWeekProvider currentWeekProvider =
//               context.read<CurrentWeekProvider>();
//           int anchorPoint = widget.mondayTime.millisecondsSinceEpoch;
//           currentWeekProvider.setAnchorPoint(anchorPoint);
//           currentWeekProvider.setAnchorPointWeek(anchorPointWeek);
//           currentWeekProvider.setCurrentWeek(
//               caculateCurrentWeek(anchorPoint, anchorPointWeek));
//         });
//         break;

//       ///[设置每周第一天为周日]
//       case ScheduleChoises.setChangeWeek:
//         BaseNavigator.getInstance().onJumpTo(RouteStatus.scheduleSetting);
//         break;

//       ///[选择学期课表]
//       case ScheduleChoises.setChangeCurrentTerm:

//         //获取管理端的所有学期
//         List<String> termList = [];
//         //得到学号，用于判断入学学期
//         String stuNum;
//         //当前学期（默认显示）
//         String currentTerm = " ";
//         //当前学期位于List中的第几个数据
//         int index = 0;
//         // int loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex);
//         int loginIndex = 0;

//         ///得到从入学到现在的学期
//         stuNum = JhEncryptUtils.aesDecrypt(
//             BaseCache.getInstance().get(ConstList.STU_NUM));
//         Map<String, dynamic> termListMap = JsonDecoder()
//             .convert(BaseCache.getInstance().get(JwcConst.termList));
//         // currentTerm = BaseCache.getInstance().get(JwcConst.currentTerm);
//         termListMap.forEach((key, value) {
//           if (int.parse(key.substring(0, 4)) >=
//               int.parse(stuNum.substring(0, 4))) {
//             termList.add(key);
//           }
//         });
//         //发送请求
//         _changeCurrentTerm() async {
//           await sendCoursesRequest(context, loginIndex,
//               currentTerm: currentTerm);
//           widget.load();
//         }
//         //弹出齿轮选项dialog
//         clickSelectedCupertino(context, [
//           termList
//         ], [
//           (i) {
//             index = i;
//           }
//         ], () {
//           currentTerm = termList[index];
//           if (currentTerm != " ") {
//             widget.load();
//             _changeCurrentTerm();
//           }
//         }, currentTerm: BaseCache.getInstance().get(JwcConst.currentTerm));
//         break;

//       ///[切换背景]
//       case ScheduleChoises.setBg:
//         ScheduleProvider scheduleProvider = context.read<ScheduleProvider>();
//         scheduleProvider.setIsCartoonBg(!scheduleProvider.getIsCartoonBg());
//         break;

//       ///[设置背景图片]
//       case ScheduleChoises.setChangeBg:
//         BaseNavigator.getInstance().onJumpTo(RouteStatus.background);
//         break;
//       default:
//     }
//   }

// //右上角菜单的每一个item
//   Widget menuPopupMenuItem(ScheduleChoises value, String imagePath,
//       {String title, Widget widget, Widget child, Function onTap}) {
//     return PopupMenuItem(
//       value: value,
//       child: FractionallySizedBox(
//         widthFactor: 1.0,
//         child: GestureDetector(
//           onTap: onTap,
//           child: Row(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(
//                   right: 2,
//                 ),
//                 child: SizedBox(
//                   height: 25,
//                   width: 25,
//                   child: Image.asset(imagePath),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                   left: 5,
//                   right: 2,
//                 ),
//                 child: child ??
//                     Text(
//                       title,
//                       style: TextStyle(fontSize: 13),
//                     ),
//               ),
//               widget ?? Container(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // currentWeekPiker(List<String> currentWeekList) {
//   //   return CupertinoPicker(
//   //     itemExtent: 50,
//   //     onSelectedItemChanged: (index) {
//   //       setState(() {
//   //         currentWeekStr = currentWeekList[index];
//   //       });
//   //     },
//   //     children: currentWeekList.map((data) {
//   //       return Center(
//   //         child: Text(data),
//   //       );
//   //     }).toList(),
//   //   );
//   // }

//   /// [迷你课表颜色]
//   /// 用于匹配迷你课表的颜色
//   ///（因为周日的课未做处理，所以周日为每周第一天时显示会不正确，可修改可不修改）
//   hasClass(List courses, int builderIndex, int index) {
//     var course = getCourse(courses, (index ~/ 7) + 1, index);
//     if (course != null) {
//       if (builderIndex + 1 >= course.startWeek &&
//           builderIndex + 1 <= course.endWeek) {
//         return Color(transformColor('FF', '#7bb8ff'));
//       }
//     }
//     return Colors.black12;
//   }
// }

// /// [迷你课表弹出动画]
// class CollapsAnimation extends AnimatedWidget {
//   CollapsAnimation({key, animation, this.child})
//       : super(
//           key: key,
//           listenable: animation,
//         );

//   final Widget child;
//   final Tween tween = Tween<double>(begin: 0, end: 80);

//   @override
//   Widget build(BuildContext context) {
//     Animation<double> animation = listenable;

//     double animationValue = tween.evaluate(animation);
//     double height = animationValue >= 0.0 ? animationValue : 0.0;
//     return Container(
//       decoration: BoxDecoration(color: Colors.black12),
//       height: height,
//       child: height >= 80
//           ? child
//           : FractionallySizedBox(
//               heightFactor: 1,
//               widthFactor: 1,
//             ),
//     );
//   }
// }

// enum ScheduleChoises {
//   setCurrentWeek,
//   setLakeTime,
//   setBg,
//   setChangeWeek,
//   setShowCourse,
//   setChangeBg,
//   setChangeCurrentTerm,
// }
