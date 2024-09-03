import 'package:flutter/material.dart';
import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/model/graduate_stu_grade_model.dart';
import 'package:wust_helper_ios/model/jwc_grade_model.dart';
import 'package:wust_helper_ios/util/color_util.dart';
import 'package:wust_helper_ios/util/common.dart';
import 'package:wust_helper_ios/util/dialog_model.dart';

class GradeCard extends StatelessWidget {
  final GradeData grade;
  final GraduateStuGradeData graStuData;
  final int loginIndex;

  const GradeCard({this.grade, Key key, this.graStuData, this.loginIndex})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> newCourse =
        BaseCache.getInstance().getStringList(GradeConst.newCourse) ?? [];
    print(newCourse);
    bool ifnew = newCourse.contains(grade.courseNum);
    return Container(
      height: 150,
      margin: EdgeInsets.only(top: 10, bottom: 5),
      decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Color(transformColor('38', '#dcdcdc')),
                offset: Offset(1, 1),
                spreadRadius: 2,
                blurRadius: 2),
          ]),
      child: MaterialButton(
        onPressed: () {
          if (loginIndex == 0)
            showGradeDetail(context, loginIndex,
                gradeData: grade, ifnew: ifnew);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // 绩点为4则挂个奖牌
                    (loginIndex == 0
                            ? grade.gradePoint == 4
                            : int.parse(graStuData.grade) >= 90)
                        ? Padding(
                            padding: const EdgeInsets.only(right: 5, top: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    height: 35,
                                    width: 35,
                                    child:
                                        Image.asset('assets/images/reward.png'))
                              ],
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: Text(
                        loginIndex == 0
                            ? grade.courseName
                            : graStuData.courseName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Text(
                  '课程性质：${loginIndex == 0 ? grade.evaluationMode ?? '' : "考核 "}',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '成绩：',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              ifnew
                                  ? "--"
                                  : '${loginIndex == 0 ? grade.grade : graStuData.grade}',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: loginIndex == 0
                                      ? grade.gradePoint == 4
                                          ? Color(
                                              transformColor('ff', '#f4a73e'))
                                          : grade.gradePoint == 0
                                              ? Colors.red
                                              : Colors.lightBlue
                                      : Colors.lightBlue),
                            )
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('学分：'),
                            Text(
                              '${loginIndex == 0 ? grade.courseCredit : graStuData.courseCredit}',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: loginIndex == 0
                                      ? grade.gradePoint == 4
                                          ? Color(
                                              transformColor('ff', '#f4a73e'))
                                          : grade.gradePoint == 0
                                              ? Colors.red
                                              : Colors.lightBlue
                                      : Colors.lightBlue),
                            )
                          ],
                        )),
                    if (loginIndex == 1)
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '学期：',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '${graStuData.term}',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.lightBlue),
                              )
                            ],
                          )),
                    // 目前只有本科生需要显示绩点
                    loginIndex == 0
                        ? Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('绩点：'),
                                Text(
                                  ifnew ? "--" : '${grade.gradePoint}',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: grade.gradePoint == 4
                                          ? Color(
                                              transformColor('ff', '#f4a73e'))
                                          : grade.gradePoint == 0
                                              ? Colors.red
                                              : Colors.lightBlue),
                                )
                              ],
                            ))
                        : Container()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
