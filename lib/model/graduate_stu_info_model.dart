class GraduateStuInfoModel {
  int code;
  String msg;
  GraduateStuInfoData data;

  GraduateStuInfoModel({this.code, this.msg, this.data});

  GraduateStuInfoModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null
        ? new GraduateStuInfoData.fromJson(json['data'])
        : null;
  }
}

class GraduateStuInfoData {
  // int id;
  String name; //姓名
  String degree; //学位
  String tutorName; //导师名字
  String academy; //学院
  String specialty; //专业
  int grade; //年级
  String avatar; //头像

  GraduateStuInfoData({
    this.name,
    this.degree,
    this.tutorName,
    this.academy,
    this.specialty,
    this.grade,
    this.avatar,
  });

  GraduateStuInfoData.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    name = json['name'];
    degree = json['degree'];
    tutorName = json['tutorName'];
    academy = json['academy'];
    specialty = json['specialty'];
    grade = json['grade'];
    avatar = json['avatar'] == "" ? "无" : json['avatar'];
  }
  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "degree": this.degree,
      "tutorName": this.tutorName,
      "academy": this.academy,
      "grade": this.grade,
      "avatar": this.avatar,
      "specialty": this.specialty
    };
  }
}
