/*
    结合登陆 json解析
*/

import 'package:wust_helper_ios/model/jwc_info_model.dart';
import 'package:wust_helper_ios/model/schedule_model.dart';

class JwcCombineModel {
  int code;
  String msg;
  Data data;

  JwcCombineModel({this.code, this.msg, this.data});

  JwcCombineModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String token;
  List<Courses> courses;
  InfoData info;

  Data({this.token, this.courses, this.info});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['courses'] != null) {
      courses = <Courses>[];
      json['courses'].forEach((v) {
        courses.add(new Courses.fromJson(v));
      });
    }
    info = json['info'] != null ? new InfoData.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.courses != null) {
      data['courses'] = this.courses.map((v) => v.toJson()).toList();
    }
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    return data;
  }
}
