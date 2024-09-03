import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/http/dao/jwc_dao.dart';
import 'package:wust_helper_ios/model/graduate_stu_grade_model.dart';

import 'package:wust_helper_ios/model/jwc_grade_model.dart';

import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/provider/scrach_provider.dart';

import 'package:wust_helper_ios/provider/token_provider.dart';
import 'package:wust_helper_ios/util/aes256.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/dialog_model.dart';
import 'package:wust_helper_ios/util/grade_util.dart';
import 'package:wust_helper_ios/util/popup_ios_selection.dart';
import 'package:wust_helper_ios/util/show_dialog.dart';
import 'package:wust_helper_ios/util/time_util.dart';
import 'package:wust_helper_ios/util/toast.dart';
import 'package:wust_helper_ios/widget/grade_card.dart';

class GradePage extends StatefulWidget {
  @override
  _GradePageState createState() => _GradePageState();
}

class _GradePageState extends State<GradePage>
    with AutomaticKeepAliveClientMixin {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  Future future;
  //判断本科生还是研究生
  int loginIndex = BaseCache.getInstance().get(JwcConst.loginIndex) ?? 0;
  bool scrach = ScrachProvider().scrach;

  List<String> newCourse =
      BaseCache.getInstance().getStringList(GradeConst.newCourse) ?? [];
  // int loginIndex = 0;
  //本科生所有成绩
  List<GradeData> allGrades = [];
  //研究生所有成绩
  List<GraduateStuGradeData> allGraStuGrades = [];
  //所有的学期
  List<String> termList;
  //当前学期的成绩
  List currentTermGrade = [];
  //用于转换每一个termList的数据
  Map termListMap;
  //当前学期
  String currentTerm;
  //需要显示的学号
  String stuNum;
  // 0表示全部，1～8表示大一至大四的上下学期
  int index = 0;

  // Gpa
  String gpa = '0';
  //gga学生平均成绩
  String gga = '0';
  // 输入框搜索文字
  String searchText = '';

  final List<String> allTermList = [
    '大一上',
    '大一下',
    '大二上',
    '大二下',
    '大三上',
    '大三下',
    '大四上',
    '大四下',
    '大五上',
    '大五下',
    '大六上',
    '大六下',
  ];

  @override
  void initState() {
    super.initState();
    future = _memoizer.runOnce(() async {
      HubUtil.show(msg: "正在加载成绩...");
      await initGrade();
      stuNum = await JhEncryptUtils.aesDecrypt(
          BaseCache.getInstance().get(ConstList.STU_NUM));
      HubUtil.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        initTermList();
        initGradeList();

        // 计算GPA
        if (loginIndex == 0 &&
            currentTermGrade != null &&
            currentTermGrade.length != 0) {
          /// `∑(学分 * 绩点) / 总学分`
          // 学分*绩点的和
          //同样的科目（名字相同）取最高成绩
          double totalGradePointMultiCourseCredit = 0.0;

          double totalGradeMultiPoint = 0.0;

          // 总学分
          double totalCourseCredit = 0.0;
          //筛选需要加入计算的课程
          List needCalGrade = [];
          Iterable iterable = currentTermGrade;
          needCalGrade.addAll(iterable);
          for (int i = 0; i < needCalGrade.length; i++) {
            for (int j = i + 1; j < needCalGrade.length; j++) {
              if (needCalGrade[i].courseNum == needCalGrade[j].courseNum) {
                if (needCalGrade[i].courseCredit >
                    needCalGrade[j].courseCredit) {
                  needCalGrade.removeAt(j);
                } else {
                  needCalGrade.removeAt(i);
                }
              }
            }
          }
          needCalGrade.forEach((element) {
            if (loginIndex == 0) {
              totalGradePointMultiCourseCredit +=
                  element.gradePoint * element.courseCredit;
              totalGradeMultiPoint +=
                  gradeToDouble(element.grade) * element.courseCredit;
              totalCourseCredit += element.courseCredit;
              //计算GPA精度取小数点后两位
              gpa = (totalGradePointMultiCourseCredit / totalCourseCredit)
                  .toStringAsFixed(2);
              // print(gpa);
              gga =
                  (totalGradeMultiPoint / totalCourseCredit).toStringAsFixed(2);
              // print("gga::::" + gga);
              //保存gpa到本地（需要显示3位小数）
              BaseCache.getInstance().setString(
                  GradeConst.gpa,
                  (totalGradePointMultiCourseCredit / totalCourseCredit)
                      .toStringAsFixed(3));
              BaseCache.getInstance().setString(
                  GradeConst.gga,
                  (totalGradeMultiPoint / totalCourseCredit)
                      .toStringAsFixed(3));
            } else if (loginIndex == 1) {
              //TODO 研究生暂不需要计算GPA，若需要计算，请在此处添加计算逻辑
            }
          });
        }
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back)),
            centerTitle: true,
            title: GestureDetector(
                onTap: () {
                  if (loginIndex == 0) screenGrade(termList);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${termList[index]}${index == 0 ? '成绩' : '学期'}',
                      style: TextStyle(color: Colors.black87),
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                )),
            actions: [
              index == 0
                  ? Container(
                      margin: EdgeInsets.only(
                          left: 5, right: 15, top: 2, bottom: 2),
                      child: PopupMenuButton(
                        offset: Offset(0, 50),
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black54,
                        ),
                        onSelected: (value) => _handleMenuSelected(value),
                        itemBuilder: (context) => <PopupMenuEntry<GradeChoise>>[
                          _createPopMenuItems(
                              GradeChoise.showLevelList, '绩点分段'),
                          _createPopMenuItems(
                              GradeChoise.gradeScratch, '成绩刮刮乐'),
                          _createPopMenuItems(GradeChoise.showFormula, '成绩说明'),
                          loginIndex == 0
                              ? _createPopMenuItems(
                                  GradeChoise.gradeChart, '图表统计')
                              : null,
                          loginIndex == 0
                              ? _createPopMenuItems(
                                  GradeChoise.caculateScholarship, '计算奖学金')
                              : null,
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          index = 0;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Center(
                            child: Text(
                          '取消筛选',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 17),
                        )),
                      ),
                    )
            ],
            elevation: 0,
            // backgroundColor: appBarColor,
          ),
          body: snapshot.connectionState == ConnectionState.done
              ? Column(
                  children: [
                    Expanded(
                      child: Column(children: [
                        /// 顶部[信息栏]和[搜索框]
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))),
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25,
                                        bottom: 15,
                                        left: 5,
                                        right: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: [
                                                TextSpan(
                                                    text: '学号：',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    )),
                                                TextSpan(
                                                    text: stuNum,
                                                    style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.lightBlue,
                                                    )),
                                              ]),
                                        ),
                                        //目前只有本科生用显示gpa
                                        loginIndex == 0
                                            ? RichText(
                                                text: TextSpan(
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style,
                                                    children: [
                                                      TextSpan(
                                                          text: 'GPA：',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                          )),
                                                      TextSpan(
                                                          text: '$gpa',
                                                          style: TextStyle(
                                                            fontSize: 19,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors
                                                                .lightBlue,
                                                          ))
                                                    ]),
                                              )
                                            : Container(),
                                      ],
                                    )),
                                loginIndex == 0
                                    ? RichText(
                                        text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: [
                                              TextSpan(
                                                  text: '平均成绩：',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  )),
                                              TextSpan(
                                                  text: gga,
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.lightBlue,
                                                  )),
                                            ]),
                                      )
                                    : Container(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 10, bottom: 20),
                                  child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                              // offset: Offset(3, 3),
                                              blurRadius: 5,
                                              color: Colors.black12)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                      ),
                                      child: TextField(
                                        onChanged: (text) {
                                          setState(() {
                                            this.searchText = text;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '搜索课程～',
                                            hintStyle: TextStyle(fontSize: 13)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        currentTermGrade.length == 0
                            ? Expanded(
                                child: Center(
                                  // TODO：加点样式
                                  child: Text(
                                    '好像什么都没有查到QAQ～～',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 19),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                itemCount: currentTermGrade.length,
                                itemBuilder: (context, index) {
                                  return loginIndex == 0
                                      ? GradeCard(
                                          grade: currentTermGrade[index],
                                          loginIndex: 0)
                                      : GradeCard(
                                          graStuData: currentTermGrade[index],
                                          loginIndex: 1,
                                        );
                                },
                              ))
                      ]),
                    )
                  ],
                )
              : SizedBox(),
        );
      },
    );
  }

  // 初始化顶部学期选项
  initTermList() {
    // 可选学期列表，初始只有全部字样
    termList = ['全部'];
    // 计算学龄
    if (currentTerm != null) {
      /// [当前学期前四位]（如：2019-2020-1） - [学号前四位(入学时间)] + [1] = [学龄(年级)]
      int stuAge = int.parse(currentTerm.substring(0, 4)) -
          int.parse(stuNum.substring(0, 4)) +
          1;
      // 判断当前学期为上学期还是下学期
      // 判断学期中最后一位为1还是2，确定为上学期或下学期
      for (var i = currentTerm.substring(currentTerm.length - 1) == '1'
              //学龄*2即每学年分为上下两学期
              ? stuAge * 2 - 2
              : stuAge * 2 - 1;
          i >= 0;
          i--) {
        termList.add(allTermList[i]);
      }
    }
  }

  // 初始化成绩列表
  void initGradeList() {
    //当前显示的课程
    currentTermGrade = createGradeListWithTerm(
      index,
      stuNum,
      termList,
      allGrades: allGrades,
      allGraStuGrades: allGraStuGrades,
      loginIndex: loginIndex,
    );
    // 根据查找构建成绩列表
    if (searchText != '') {
      List<GradeData> list = [];
      currentTermGrade.forEach((e) {
        if (e.courseName.contains(searchText)) {
          list.add(e);
        }
      });
      currentTermGrade = list;
    }
  }

  initGrade() async {
    await _send();
    //得到相应学期 返回形式如：“2021-2022-2”：2022-02-28
    termListMap = JsonDecoder()
        .convert(await BaseCache.getInstance().get(JwcConst.termList));
    currentTerm = await BaseCache.getInstance().get(JwcConst.currentTerm);
    stuNum = await JhEncryptUtils.aesDecrypt(
        BaseCache.getInstance().get(ConstList.STU_NUM));
  }

  _send() async {
    String token = TokenProvider().token;
    var result;
    //从本地提取数据
    allGrades = [];
    //上一次请求时间
    String preRequestTime = "-1";
    List localGrades = BaseCache.getInstance().getStringList(GradeConst.grade);

    if (loginIndex == 0) {
      if (localGrades != null) {
        localGrades
            .forEach((e) => allGrades.add(GradeData.fromJson(json.decode(e))));
      }
    } else if (loginIndex == 1) {
      allGraStuGrades = [];
      if (localGrades != null) {
        localGrades.forEach((e) =>
            allGraStuGrades.add(GraduateStuGradeData.fromJson(json.decode(e))));
      }
    }
    //20分钟内只允许请求一次
    if (allGrades != null && allGrades.length != 0) {
      preRequestTime =
          BaseCache.getInstance().get<String>(GradeConst.gradeRequestTime) ??
              "-1";

      if (preRequestTime != "-1" &&
          differMinute(DateTime.now(), preRequestTime) < 20) return;
    }
    try {
      BaseCache baseCache = BaseCache.getInstance();
      List<GradeData> gradeDataList = [];

      if (loginIndex == 0) {
        result = await JwcDao.getGrade(token);
        gradeDataList = GradeModel.fromJson(result).data;
        if (allGrades.length == gradeDataList.length) {
          showToast("暂无最新成绩!");
        } else {
          allGrades = gradeDataList;
          gradeDataList.remove(allGrades);
          newCourse = gradeDataList.map((e) => e.courseNum).toList();
          showToast("有新的成绩，已经同步!");
        }
        // 请求到成绩后缓存至本地
        await baseCache.setStringList(GradeConst.grade,
            allGrades.map((e) => json.encode(e.toJson())).toList());
        currentTermGrade = allGrades;
        if (scrach && newCourse.length < 5)
          await baseCache.setStringList(GradeConst.newCourse, newCourse);
      } else if (loginIndex == 1) {
        result = await JwcDao.graduateStuGrade(token);
        allGraStuGrades = GraduateStuGradeModel.fromJson(result).data;
        await baseCache.setStringList(GradeConst.grade,
            allGraStuGrades.map((e) => json.encode(e.toJson())).toList());
      }
      //以毫秒形式保存
      baseCache.setString(
          GradeConst.gradeRequestTime, saveDateTime(DateTime.now()));
    } catch (e) {
      showToast('网络错误！已显示本地缓存');
    }
  }

  // 筛选学期
  screenGrade(List<String> termList) {
    // 初始化选项为全部学期
    index = 0;
    clickSelectedCupertino(context, [termList], [(i) => index = i], () {
      setState(() {});
    });
  }

  Widget _createPopMenuItems(GradeChoise gradeChoise, String text) {
    return PopupMenuItem(
        value: gradeChoise,
        child: Row(children: [
          Padding(
            padding: EdgeInsets.only(
              right: 2,
            ),
            child: SizedBox(
              height: 25,
              width: 25,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 5,
              right: 2,
            ),
            child: Text(text),
          ),
        ]));
  }

// 处理小菜单点击事件
  _handleMenuSelected(value) async {
    const String formulaText = '''本软件的成绩数据仅供参考,具体请以教务处官网为准

1.计算平均学分绩点(GPA)

平均学分绩点=∑(学分*绩点)÷学分 

2.平均成绩算法同GPA,成绩为ABCD等级制的换算成成绩区间平均数进行计算''';
    switch (value) {
      case GradeChoise.showLevelList:
        await showLevelList(context);
        break;
      case GradeChoise.showFormula:
        await showSingleDialog(context, '成绩说明', formulaText);
        break;
      case GradeChoise.gradeScratch:
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(
                "成绩刮刮乐",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              content: Container(
                margin: EdgeInsets.only(top: 10),
                child: SizedBox(
                    child: Column(
                  children: [
                    Text(
                      "是否关闭成绩刮刮乐",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.start,
                    ),
                    Consumer<ScrachProvider>(
                      builder: (context, value, child) {
                        // bool show = context.select<ScrachProvider, bool>(
                        //     (value) => value.scrach);
                        return CupertinoSwitch(
                            value: context.select<ScrachProvider, bool>(
                                (value) => value.scrach),
                            onChanged: (value) {
                              // show = value;
                              Provider.of<ScrachProvider>(context,
                                      listen: false)
                                  .setScrach(value);
                            });
                      },
                    ),
                  ],
                )),
              ),
            );
          },
        );
        break;
      case GradeChoise.gradeChart:
        BaseNavigator.getInstance().onJumpTo(RouteStatus.gradeChart);
        break;
      case GradeChoise.caculateScholarship:
        if (allGrades.length == 0) {
          showToast('还在加载成绩数据，请稍等哦！');
        } else {
          BaseNavigator.getInstance().onJumpTo(RouteStatus.scholarship, args: {
            'grades': allGrades,
            'termList': termList,
            ConstList.STU_NUM: stuNum
          });
        }
        if (allGraStuGrades.length == 0) {
          showToast('还在加载成绩数据，请稍等哦！');
        } else {
          BaseNavigator.getInstance().onJumpTo(
            RouteStatus.scholarship,
          );
        }

        break;
    }
  }

  @override
  bool get wantKeepAlive => true;
}

double gradeToDouble(String s) {
  switch (s) {
    case 'A':
      return 95;
    case 'A-':
      return 87;
    case 'B+':
      return 83;
    case 'B':
      return 79.5;
    case 'B-':
      return 76;
    case 'C+':
      return 73;
    case 'C':
      return 69.5;
    case 'C-':
      return 65.5;
    case 'D':
      return 61.5;
    case 'F':
      return 30;
    default:
      return double.parse(s);
  }
}

enum GradeChoise {
  // 展示成绩与等级对照表
  showLevelList,
  // 展示GPA计算公式
  showFormula,
  // 计算奖学金
  caculateScholarship,
  // 图表统计
  gradeChart,

  gradeScratch,
}
