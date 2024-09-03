class ColorCourse {
  String color;
  String className;
  String teachClass;
  String teacher;
  int startWeek;
  int endWeek;
  int section;
  int weekDay;
  String classroom;

  ColorCourse(
      {this.color,
      this.className,
      this.teachClass,
      this.teacher,
      this.startWeek,
      this.endWeek,
      this.section,
      this.weekDay,
      this.classroom});

  ColorCourse.fromJson(Map<String, dynamic> json) {
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
}
