/*
  * 研究生成绩数据Model
  * 
  */

class GraduateStuGradeModel {
  int code;
  String msg;
  List<GraduateStuGradeData> data;

  GraduateStuGradeModel({this.code, this.msg, this.data});
  GraduateStuGradeModel.fromJson(Map<dynamic, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <GraduateStuGradeData>[];
      json['data'].forEach((value) {
        data.add(new GraduateStuGradeData.fromJson(value));
      });
    }
  }
}

class GraduateStuGradeData {
  int id; //没有使用，只是用来对应后台数据格式
  String courseName;
  double courseCredit; //学分
  int term;
  String grade; //分数

  GraduateStuGradeData(
      {this.id, this.courseName, this.courseCredit, this.term, this.grade});

  GraduateStuGradeData.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    courseName = json['name'];
    courseCredit = json['credit'];
    term = json['term'];
    grade = json['point'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map();
    data['name'] = this.courseName;
    data['point'] = this.grade;
    data['id'] = this.id;
    data['term'] = this.term;
    data['credit'] = this.courseCredit;
    return data;
  }
}
