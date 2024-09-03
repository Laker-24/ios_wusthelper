class AdminTime {
  int code;
  String msg;
  AdminTimeData data;

  AdminTime({this.code, this.msg, this.data});

  AdminTime.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data =
        json['data'] != null ? new AdminTimeData.fromJson(json['data']) : null;
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

class AdminTimeData {
  //当前学期
  String currentTerm;
  //学期配置
  Map termSetting;

  AdminTimeData({this.currentTerm, this.termSetting});

  AdminTimeData.fromJson(Map<String, dynamic> json) {
    currentTerm = json['currentTerm'];
    termSetting = json['termSetting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentTerm'] = this.currentTerm;
    if (this.termSetting != null) {
      data['termSetting'] = this.termSetting;
    }
    return data;
  }
}

// class TermSetting {
//   String s201820192;
//   String s201820191;
//   String s201920201;
//   String s201920202;
//   String s202020211;
//   String s202020212;

//   TermSetting(
//       {this.s201820192,
//       this.s201820191,
//       this.s201920201,
//       this.s201920202,
//       this.s202020211,
//       this.s202020212});

//   TermSetting.fromJson(Map<String, dynamic> json) {
//     s201820192 = json['2018-2019-2'];
//     s201820191 = json['2018-2019-1'];
//     s201920201 = json['2019-2020-1'];
//     s201920202 = json['2019-2020-2'];
//     s202020211 = json['2020-2021-1'];
//     s202020212 = json['2020-2021-2'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['2018-2019-2'] = this.s201820192;
//     data['2018-2019-1'] = this.s201820191;
//     data['2019-2020-1'] = this.s201920201;
//     data['2019-2020-2'] = this.s201920202;
//     data['2020-2021-1'] = this.s202020211;
//     data['2020-2021-2'] = this.s202020212;
//     return data;
//   }
// }
