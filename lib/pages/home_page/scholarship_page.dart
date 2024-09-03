import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:wust_helper_ios/model/jwc_grade_model.dart';
import 'package:wust_helper_ios/navigator/base_navigator.dart';
import 'package:wust_helper_ios/util/color_util.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/dialog_model.dart';
import 'package:wust_helper_ios/util/grade_util.dart';
import 'package:wust_helper_ios/util/popup_ios_selection.dart';
import 'package:wust_helper_ios/util/toast.dart';
import 'package:wust_helper_ios/widget/grade_card.dart';
import 'package:wust_helper_ios/widget/login_button.dart';

class ScholarshipPage extends StatefulWidget {
  final List<GradeData> grades;
  final List<String> termList;
  final String stuNum;
  final List<String> allStuAgeList = ['大一', '大二', '大三', '大四', '大五', '大六', '大七'];

  ScholarshipPage(
    this.grades,
    this.stuNum,
    this.termList, {
    Key key,
  }) : super(key: key);
  @override
  _ScholarshipPageState createState() => _ScholarshipPageState();
}

class _ScholarshipPageState extends State<ScholarshipPage>
    with TickerProviderStateMixin {
  // 学年列表
  List<String> stuAgeList = [];
  // 科目选择状态
  List<bool> selectionList = [];
  // 权重列表
  List<double> weightList = [];
  // 当前要显示的成绩列表
  List<GradeData> grades;
  // 选择的学期索引，默认为0（0为全部学期）
  int currentTermIndex = 0;

  @override
  void initState() {
    super.initState();
    grades = widget.grades;
    initStuAgeList();
    initSectionList();
    initWeightList();
  }

  @override
  Widget build(BuildContext context) {
    grades = createGradeListWithStuAge(
        currentTermIndex, widget.stuNum, stuAgeList, widget.grades);

    return Scaffold(
        appBar: AppBar(
          title: Text('奖学金计算'),
          // backgroundColor: appBarColor,w
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () =>
                BaseNavigator.getInstance().onJumpTo(RouteStatus.grade),
          ),
          actions: [
            GestureDetector(
              onTap: currentTermIndex == 0
                  ? () {
                      currentTermIndex = 1;
                      clickSelectedCupertino(context, [stuAgeList],
                          [(i) => currentTermIndex = i + 1], () {
                        setState(() {});
                      });
                    }
                  : () {
                      setState(() {
                        currentTermIndex = 0;
                      });
                    },
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Center(
                    child: Text(
                  '${currentTermIndex == 0 ? '筛选学期' : '取消筛选'}',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                )),
              ),
            )
          ],
        ),
        body: WillPopScope(
          onWillPop: () async => false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
            child: grades.length == 0
                ? Center(
                    child: Text('本学年似乎还没有成绩诶～',
                        style: TextStyle(fontSize: 21, color: Colors.black26)))
                : ListView(
                    children: [
                      Column(
                          children: grades.asMap().entries.map((e) {
                        int index = e.key;
                        GradeData grade = e.value;
                        return createScholarshipCard(grade, index);
                      }).toList()),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          child: LoginButton(
                            '计算F1学分',
                            true,
                            caculateF1,
                            color: Colors.lightBlue,
                          ))
                    ],
                  ),
          ),
        ));
  }

  void handleTap(int index) {
    setState(() {
      selectionList[index] = !selectionList[index];
    });
  }

  void handleCaculateButton(bool x, int index) {
    if (weightList[index] > 0.11 || x) {
      setState(() {
        weightList[index] =
            x ? weightList[index] + 0.1 : weightList[index] - 0.1;
      });
    }
  }

  void initStuAgeList() {
    int termNum = (widget.termList.length.isEven
            ? widget.termList.length / 2
            : widget.termList.length - 1 / 2)
        .toInt();
    for (var i = 0; i < termNum; i++) {
      stuAgeList.add(widget.allStuAgeList[i] + '学年');
    }
  }

  void caculateF1() {
    double totalHours = 0;
    double totalNum = 0;

    for (var i = 0; i < grades.length; i++) {
      if (selectionList[i]) {
        totalNum +=
            grades[i].courseCredit * grades[i].gradePoint * weightList[i];
        totalHours += grades[i].courseCredit;
      }
    }
    double result = totalHours == 0 ? 0 : totalNum / totalHours;
    totalHours == 0
        ? showToast('至少选一项哦～')
        : showF1Dialog(context, result, this,
            stuAge: currentTermIndex == 0
                ? '全部'
                : widget.allStuAgeList[currentTermIndex - 1]);
  }

  ScholarshipCard createScholarshipCard(GradeData grade, int index) =>
      ScholarshipCard(
        grade,
        onTap: () => handleTap(index),
        handleCaculateButton: (bool x) => handleCaculateButton(x, index),
        isChoosed: selectionList[index],
        weight: weightList[index],
      );

  void initSectionList() {
    List<bool> list = [];
    grades.forEach((e) => list.add(true));
    selectionList = list;
  }

  void initWeightList() {
    List<double> list = [];
    grades.forEach((e) => list.add(1));
    weightList = list;
  }
}

class ScholarshipCard extends StatelessWidget {
  final GradeData grade;
  final bool isChoosed;
  final Function onTap;
  final Function handleCaculateButton;
  final double weight;
  ScholarshipCard(this.grade,
      {Key key,
      @required this.onTap,
      this.isChoosed = true,
      this.weight = 1.0,
      @required this.handleCaculateButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                  margin: EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: Row(
                    children: [
                      Checkbox(
                        value: isChoosed,
                        onChanged: (bool x) => onTap(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(7, 5, 5, 7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: SizedBox(
                                width: 200,
                                child: Text(
                                  grade.courseName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 19),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '学分：${grade.courseCredit}',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                                Container(
                                  width: 17,
                                ),
                                Text('绩点：${grade.gradePoint}',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  caculateButton(false),
                  Container(
                    width: 45,
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Center(
                      child: Text(
                        '${weight.toStringAsFixed(1)}',
                        style: TextStyle(
                            // 757575

                            color: Color(transformColor('FF', '#757575')),
                            fontWeight: FontWeight.w700,
                            fontSize: 24),
                      ),
                    ),
                  ),
                  caculateButton(true)
                ]),
          ),
        ],
      ),
    );
  }

  caculateButton(bool x /* x=true为加法，反之为减法 */) {
    return InkWell(
      // 之所以设置为 >0.11，你将 weight.toStringAsFixed(1) 改成 weight 就知道了
      onTap: () => handleCaculateButton(x),
      child: Container(
        width: 23,
        child: Center(
          child: Text(
            '${x ? '+' : '-'}',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
