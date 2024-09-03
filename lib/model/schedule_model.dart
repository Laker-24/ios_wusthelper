class ScheduleModel {
  int code;
  String msg;
  List<Courses> data;

  ScheduleModel({this.code, this.msg, this.data});

  ScheduleModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Courses>[];
      json['data'].forEach((v) {
        data.add(new Courses.fromJson(v));
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

class Courses {
  String className;
  String teachClass;
  String teacher;
  int startWeek;
  int endWeek;
  int section;
  int weekDay;
  String classroom;

  Courses(
      {this.className,
      this.teachClass,
      this.teacher,
      this.startWeek,
      this.endWeek,
      this.section,
      this.weekDay,
      this.classroom});

  Courses.fromJson(Map<String, dynamic> json) {
    className = json['className'];
    teachClass = json['teachClass'];
    teacher = json['teacher'];
    startWeek = json['startWeek'];
    endWeek = json['endWeek'];
    section = json['section'];
    weekDay = json['weekDay'];
    classroom = json['classroom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['className'] = this.className;
    data['teachClass'] = this.teachClass;
    data['teacher'] = this.teacher;
    data['startWeek'] = this.startWeek;
    data['endWeek'] = this.endWeek;
    data['section'] = this.section;
    data['weekDay'] = this.weekDay;
    data['classroom'] = this.classroom;
    return data;
  }

  @override
  String toString() {
    // print();
    return super.toString() +
        this.className +
        " st: " +
        this.startWeek.toString() +
        " ed: " +
        this.endWeek.toString() +
        " sc: " +
        this.section.toString();
  }
}
