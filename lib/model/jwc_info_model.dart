class JwcInfoModel {
  int code;
  String msg;
  InfoData data;

  JwcInfoModel({this.code, this.msg, this.data});

  JwcInfoModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new InfoData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class InfoData {
  String stuNum;
  String stuName;
  String nickName;
  String college;
  String major;
  String classes;

  InfoData(
      {this.stuNum,
      this.stuName,
      this.nickName,
      this.college,
      this.major,
      this.classes});

  InfoData.fromJson(Map<String, dynamic> json) {
    stuNum = json['stuNum'];
    stuName = json['stuName'];
    nickName = json['nickName'];
    college = json['college'];
    major = json['major'];
    classes = json['classes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stuNum'] = this.stuNum;
    data['stuName'] = this.stuName;
    data['nickName'] = this.nickName;
    data['college'] = this.college;
    data['major'] = this.major;
    data['classes'] = this.classes;
    return data;
  }
}
