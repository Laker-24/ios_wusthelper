// 根据学期构建成绩列表
import 'dart:convert';

import 'package:wust_helper_ios/db/base_cache.dart';
import 'package:wust_helper_ios/model/graduate_stu_grade_model.dart';
import 'package:wust_helper_ios/model/jwc_grade_model.dart';
import 'package:wust_helper_ios/util/aes256.dart';
import 'package:wust_helper_ios/util/common.dart';

//返回当前需要显示的课程
List createGradeListWithTerm(int index, String stuNum, List<String> termList,
    {List<GradeData> allGrades,
    int loginIndex,
    List<GraduateStuGradeData> allGraStuGrades}) {
  if (loginIndex == 0) {
    List<GradeData> list = [];
    if (index == 0) {
      list = allGrades;
    } else {
      // 注册年份：即入学年，取学号前四位
      int signUpYear = int.parse(stuNum.substring(0, 4));
      // 选择的学年
      int currentAge = ((termList.length - index) / 2).ceil();
      // 选择的学期
      /// 当可选学期列表中`学期数目(即列表长度-1) = index` 时，学期为上学期(1)，否则为下学期(2)
      int term = (termList.length - 1) % 2 == index % 2 ? 1 : 2;

      allGrades.forEach((element) {
        if (element.schoolTerm ==
            '${signUpYear + currentAge - 1}-${signUpYear + currentAge}-$term') {
          list.add(element);
        }
      });
    }
    return list;
  } else {
    List<GraduateStuGradeData> list = [];
    if (index == 0) {
      list = allGraStuGrades;
    }
    return list;
  }
}

List<GradeData> createGradeListWithStuAge(int index, String stuNum,
    List<String> stuAgeList, List<GradeData> allGrades) {
  List<GradeData> list = [];
  if (index == 0) {
    list = allGrades;
  } else {
    // 注册年份：即入学年，取学号前四位
    int signUpYear = int.parse(stuNum.substring(0, 4));

    allGrades.forEach((element) {
      if (element.schoolTerm
          .contains('${signUpYear + index - 1}-${signUpYear + index}')) {
        list.add(element);
      }
    });
  }
  return list;
}

//得到“我”的学期
List<String> termList() {
  //通过学号判断我的学期
  List<String> _termList = [];
  //学号
  String stuNum =
      JhEncryptUtils.aesDecrypt(BaseCache.getInstance().get(ConstList.STU_NUM));
  //得到所有学期
  Map<String, dynamic> termListMap =
      JsonDecoder().convert(BaseCache.getInstance().get(JwcConst.termList));
  //我的学期
  termListMap.forEach((key, value) {
    if (int.parse(key.substring(0, 4)) >= int.parse(stuNum.substring(0, 4))) {
      _termList.add(key);
    }
  });
  //对 "我" 的学期进行处理，从大一上开始排列(重新排列我的学期)
  List<String> _list = [];
  //得到最新的学期
  String currentTerm = BaseCache.getInstance().get(JwcConst.currentTerm);
  for (int i = 0;
      i <=
          int.parse(currentTerm.substring(0, 4)) -
              int.parse(stuNum.substring(0, 4));
      i++) {
    _termList.forEach((termName) {
      int.parse(termName.substring(0, 4)) - int.parse(stuNum.substring(0, 4)) ==
              i
          ? _list.add(termName)
          : null;
    });
  }
  return _list;
}
