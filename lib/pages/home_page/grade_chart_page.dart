import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_echart/flutter_echart.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/model/jwc_grade_model.dart';
import 'package:wust_helper_ios/util/aes256.dart';
import 'package:wust_helper_ios/util/color_util.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/grade_util.dart';
import 'package:charts_flutter/flutter.dart' as charts;

enum calGPA {
  CURRENT_TERM, //当前学期
  ALL_TERM, //全年
}

class GradeChart extends StatefulWidget {
  const GradeChart({Key key}) : super(key: key);

  @override
  State<GradeChart> createState() => _GradeChartState();
}

class _GradeChartState extends State<GradeChart> {
  //本地存储
  List<String> localGrades = [];
  //当前所有成绩
  List<GradeData> grades = [];
  //平均学分绩
  String gpa = '';
  String gga = '';
  //通过个数去计算百分比
  int gp40 = 0,
      gp37 = 0,
      gp33 = 0,
      gp30 = 0,
      gp27 = 0,
      gp23 = 0,
      gp20 = 0,
      gp15 = 0,
      gp10 = 0,
      gp00 = 0;

  ///成绩总个数
  int length;

  ///各个绩点所占的百分比
  Map<String, dynamic> _gradePointPercent;

  ///绩点种类
  List<String> _gradePointType = [];

  ///得到 “我” 有的学期
  List<String> _terms = termList();

  ///条形图的数据
  ///当前学期的
  List<GradePointChartData> _currentTermSeries = [];

  ///整个学年
  List<GradePointChartData> _allTermSeries = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    localGrades = BaseCache.getInstance().getStringList(GradeConst.grade);
    localGrades.forEach((gradeData) {
      grades.add(GradeData.fromJson(json.decode(gradeData)));
    });
    gpa = BaseCache.getInstance().get(GradeConst.gpa) ?? "暂无～";
    gga = BaseCache.getInstance().get(GradeConst.gga) ?? "暂无～";
    if (grades.isNotEmpty) {
      grades.forEach((gradeData) {
        if (gradeData.gradePoint == 4.0) {
          gp40++;
        } else if (gradeData.gradePoint == 3.7) {
          gp37++;
        } else if (gradeData.gradePoint == 3.3) {
          gp33++;
        } else if (gradeData.gradePoint == 3.0) {
          gp30++;
        } else if (gradeData.gradePoint == 2.7) {
          gp27++;
        } else if (gradeData.gradePoint == 2.3) {
          gp23++;
        } else if (gradeData.gradePoint == 2.0) {
          gp20++;
        } else if (gradeData.gradePoint == 1.5) {
          gp15++;
        } else if (gradeData.gradePoint == 1.0) {
          gp10++;
        } else if (gradeData.gradePoint == 0.0) {
          gp00++;
        }
      });
    }

    length = grades.length;

    ///绩点的种类
    _gradePointType = [
      "4.0",
      "3.7",
      "3.3",
      "3.0",
      "2.7",
      "2.3",
      "2.0",
      "1.5",
      "1.0",
      "0.0"
    ];

    ///该同学的各绩点所占的比例
    _gradePointPercent = {
      "4.0": cal(gp40),
      "3.7": cal(gp37),
      "3.3": cal(gp33),
      "3.0": cal(gp30),
      "2.7": cal(gp27),
      "2.3": cal(gp23),
      "2.0": cal(gp20),
      "1.5": cal(gp15),
      "1.0": cal(gp10),
      "0.0": cal(gp00),
    };

    ///条形图数据
    for (int i = 0; i < _terms.length; i++) {
      GradePointChartData gradePointChartData =
          _calCurrentTermGpa(grades, _terms[i], calGPA.CURRENT_TERM);
      gradePointChartData.setColor(charts.ColorUtil.fromDartColor(
          Color(transformColor('FF', CoursesColors[i + 1]))));
      //判断 空
      if (!double.parse(gradePointChartData.gradePointPercent).isNaN) {
        _currentTermSeries.add(gradePointChartData);
      }
    }

    for (int i = 0; i < _terms.length; i += 2) {
      GradePointChartData gradePointChartData = _calCurrentTermGpa(
          grades, _terms[i].substring(0, 4), calGPA.ALL_TERM);
      gradePointChartData.setColor(charts.ColorUtil.fromDartColor(
          Color(transformColor('FF', CoursesColors[i ~/ 2 + 6]))));
      if (!double.parse(gradePointChartData.gradePointPercent).isNaN)
        _allTermSeries.add(gradePointChartData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "图表统计",
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 40, left: 20, right: 20),
        child: ListView(
          children: [
            ///平均学分绩点样式
            Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "平均学分绩点",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          '$gpa',
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "平均成绩",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          '$gga',
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                )),

            ///绩点分布样式
            TitleWidget(title: "绩点分布"),

            //饼状图(查看绩点分布)
            grades.isNotEmpty
                ? Center(
                    child: SizedBox(
                      height: ScreenUtil.getInstance().screenHeight * 0.25,
                      width: double.infinity,
                      child: PieChatWidget(
                        dataList: _showGradePoint(),
                        isLineText: true,
                        bgColor: Colors.white54,
                        openType: OpenType.ANI,
                        isFrontgText: true,
                        loopType: LoopType.DOWN_LOOP,
                      ),
                    ),
                  )
                : Center(
                    child: Text("暂无成绩哦～"),
                  ),
            //学期绩点
            Padding(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: TitleWidget(title: "学期绩点"),
            ),
            if (grades.isNotEmpty)
              Container(
                  height: 400,
                  width: 100,
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: ChartWidget(_currentTermSeries))
            else
              SizedBox(),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: TitleWidget(title: "学年绩点"),
            ),

            if (grades.isNotEmpty)
              if (grades.isNotEmpty)
                Container(
                    height: 400,
                    width: 300,
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: ChartWidget(_allTermSeries))
              else
                SizedBox(),
          ],
        ),
      ),
    );
  }

  //饼图数据
  List<EChartPieBean> _showGradePoint() {
    List<EChartPieBean> list = [];
    if (_gradePointPercent.isNotEmpty) {
      _gradePointPercent.forEach((gradePoint, percent) {
        if (percent != "0.000") {
          list.add(EChartPieBean(
            title: gradePoint,
            number: (double.parse(percent) * 100).toInt(),
            color: Color(transformColor(
                'FF', CoursesColors[_gradePointType.indexOf(gradePoint)])),
          ));
        }
      });
    }

    return list;
  }

  //计算对应学期的平均绩点(计算整个学年还是单个学期，)
  _calCurrentTermGpa(List<GradeData> grades, String currentTerm, calGPA type) {
    /*
    * _total: 各科 学分*绩点 总和
    *_totalCredit：各科总学分
    *_gpa ：计算相应的gpa
    */
    List<String> _allTermName = ["大一", "大二", "大三", "大四", "大五", "大六"];
    List<String> _currTermName = [
      "大一上",
      "大一下",
      "大二上",
      "大二下",
      "大三上",
      "大三下",
      "大四上",
      "大四下",
      "大五上",
      "大五下",
      "大六上",
      "大六下",
    ];
    double _total = 0, _totalCredit = 0;
    String _gpa, _termName;
    //筛选需要进行计算的科目
    List<GradeData> _list = [];
    // 先得到我的学号
    String _stuNum = JhEncryptUtils.aesDecrypt(
        BaseCache.getInstance().get(ConstList.STU_NUM));
    switch (type) {
      case calGPA.ALL_TERM:
        grades.forEach((element) {
          if (element.schoolTerm.substring(0, 4) == currentTerm) {
            _list.add(element);
          }
        });
        _termName = _allTermName[
            int.parse(currentTerm) - int.parse(_stuNum.substring(0, 4))];
        break;
      case calGPA.CURRENT_TERM:
        grades.forEach((element) {
          if (element.schoolTerm == currentTerm) {
            _list.add(element);
          }
        });
        /**
         * 将 _currTermName 分为6组
         * 取学号和当前学期的前四位相减
         * 乘2 得到其组数
         * 若最后一位为1 则为该组第一个 ；反之
         */
        _termName = _currTermName[(int.parse(currentTerm.substring(0, 4)) -
                    int.parse(_stuNum.substring(0, 4))) *
                2 +
            (int.parse(currentTerm.substring(currentTerm.length - 2)) % 2 == 0
                ? 1
                : 0)];
        break;
      default:
        break;
    }
    // 经过去重处理后
    _list = _removeRepeatGrades(_list);
    //计算平均学分绩
    _list.forEach((gradeData) {
      _total += gradeData.courseCredit * gradeData.gradePoint;
      _totalCredit += gradeData.courseCredit;
    });
    _gpa = (_total / _totalCredit).toStringAsFixed(3);

    return GradePointChartData(_termName, _gpa);
  }

  //成绩去重处理
  _removeRepeatGrades(List<GradeData> setGrades) {
    List<GradeData> _setGrades = [];
    //（多门成绩取最高分,主要是存在挂科的情况）
    for (GradeData data in setGrades) {
      if (_setGrades.length == 0) {
        _setGrades.add(data);
        continue;
      }
      int i = 0;
      for (; i < _setGrades.length; i++) {
        if (!(_setGrades[i].courseNum == data.courseNum)) {
          //如果不相同则直接添加
        } else {
          //名字相同，与原数据比较
          if (data.gradePoint > _setGrades[i].gradePoint) {
            _setGrades[i] = data;
          } //小于则不复盖
          break;
        }
      }
      if (i == _setGrades.length) {
        //如果查找完成，没有重复的就添加
        _setGrades.add(data);
      }
    }
    // for (int i = 0; i < setGrades.length; i++) {
    //   _setGrades.add(setGrades[i]);
    //   for (int j = i + 1; j < setGrades.length; j++) {
    //     //如果有相同的科目，成绩高者存入数组 (但若都不及格，保存一个即可)
    //     if ((grades[i].courseNum == setGrades[j].courseNum)) {
    //       double.parse(setGrades[i].grade) < double.parse(setGrades[j].grade)
    //           ? _setGrades[i] = setGrades[j]
    //           : null;
    //     }
    //   }
    // }
    return _setGrades;
  }

  // //计算百分比，返回3位小数
  String cal(int gp) => (gp / length).toStringAsFixed(3);
}

//带边框的说明信息
class TitleWidget extends StatelessWidget {
  final String title;
  const TitleWidget({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 30),
        padding: EdgeInsets.all(3),
        width: ScreenUtil.getInstance().screenWidth * 0.35,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(fontSize: 18.0),
        )),
      ),
    );
  }
}

///创建一个图表数据类
///便于传递数据
class GradePointChartData {
  String termName;
  String gradePointPercent;
  charts.Color colorName;

  GradePointChartData(
    this.termName,
    this.gradePointPercent,
  );

  setColor(colorName) {
    this.colorName = colorName;
  }
}

//柱状图
class ChartWidget extends StatefulWidget {
  final List<GradePointChartData> termPercent;
  ChartWidget(this.termPercent, {Key key}) : super(key: key);

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget>
    with AutomaticKeepAliveClientMixin {
  List<GradePointChartData> _termPercent;
  List<charts.Series<GradePointChartData, String>> series = [];

  @override
  void initState() {
    super.initState();
    _termPercent = widget.termPercent;

    series = [
      charts.Series(
        id: _termPercent[0].termName.length > 2 ? "学期绩点" : "学年绩点",
        data: _termPercent,
        domainFn: (datum, _) => datum.termName,
        measureFn: (datum, _) => double.parse(datum.gradePointPercent),
        colorFn: (datum, __) => datum.colorName,
        labelAccessorFn: (datum, index) => datum.gradePointPercent,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      series,
      animate: true,
      barGroupingType: charts.BarGroupingType.stacked,
      barRendererDecorator: charts.BarLabelDecorator<String>(
        labelAnchor: charts.BarLabelAnchor.end,
        labelPosition: charts.BarLabelPosition.outside,
      ),
      behaviors: [
        charts.SlidingViewport(),
        charts.PanAndZoomBehavior(),

        // charts.DomainA11yExploreBehavior(),
        charts.InitialHintBehavior(
          maxHintTranslate: 4.0,
          hintDuration: Duration(
            milliseconds: 1000,
          ),
        ),
        charts.SeriesLegend(),
      ],
      domainAxis: new charts.OrdinalAxisSpec(
          viewport: new charts.OrdinalViewport(_termPercent[0].termName, 5)),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
