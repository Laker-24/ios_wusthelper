/*
 * 本科生成绩数据Model
 * 
 */
class GradeModel {
  int code;
  String msg;
  List<GradeData> data;

  GradeModel({this.code, this.msg, this.data});

  GradeModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <GradeData>[];
      json['data'].forEach((v) {
        data.add(new GradeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GradeData {
  // assets/comment/成绩参数.png
  String courseNum;
  String courseName;
  String grade;
  double courseCredit;
  double courseHours;
  double gradePoint;
  String evaluationMode;
  String examNature;
  String courseNature;
  String schoolTerm;
  int rebuildTag;
  int reExamTag;
  int missExamTag;

  GradeData(
      {this.courseNum,
      this.courseName,
      this.grade,
      this.courseCredit,
      this.courseHours,
      this.gradePoint,
      this.evaluationMode,
      this.examNature,
      this.courseNature,
      this.schoolTerm,
      this.rebuildTag,
      this.reExamTag,
      this.missExamTag});

  GradeData.fromJson(Map<String, dynamic> json) {
    courseNum = json['courseNum'];
    courseName = json['courseName'];
    grade = json['grade'];
    courseCredit = json['courseCredit'];
    courseHours = json['courseHours'];
    gradePoint = json['gradePoint'];
    evaluationMode = json['evaluationMode'];
    examNature = json['examNature'];
    courseNature = json['courseNature'];
    schoolTerm = json['schoolTerm'];
    rebuildTag = json['rebuildTag'];
    reExamTag = json['reExamTag'];
    missExamTag = json['missExamTag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseNum'] = this.courseNum;
    data['courseName'] = this.courseName;
    data['grade'] = this.grade;
    data['courseCredit'] = this.courseCredit;
    data['courseHours'] = this.courseHours;
    data['gradePoint'] = this.gradePoint;
    data['evaluationMode'] = this.evaluationMode;
    data['examNature'] = this.examNature;
    data['courseNature'] = this.courseNature;
    data['schoolTerm'] = this.schoolTerm;
    data['rebuildTag'] = this.rebuildTag;
    data['reExamTag'] = this.reExamTag;
    data['missExamTag'] = this.missExamTag;
    return data;
  }
}
