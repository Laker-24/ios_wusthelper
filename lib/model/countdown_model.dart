class CountdownModel {
  int code;
  String msg;
  CountdownData data;

  CountdownModel({this.code, this.msg, this.data});

  CountdownModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data =
        json['data'] != null ? new CountdownData.fromJson(json['data']) : null;
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

class CountdownData {
  List<Pub> pub;
  List<Pri> pri;

  CountdownData({this.pub, this.pri});

  CountdownData.fromJson(Map<String, dynamic> json) {
    if (json['pub'] != null) {
      pub = [];
      json['pub'].forEach((v) {
        pub.add(new Pub.fromJson(v));
      });
    }
    if (json['pri'] != null) {
      pri = [];
      json['pri'].forEach((v) {
        pri.add(new Pri.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pub != null) {
      data['pub'] = this.pub.map((v) => v.toJson()).toList();
    }
    if (this.pri != null) {
      data['pri'] = this.pri.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pub {
  String name;
  String time;
  String comment;
  String uuid;
  String createTime;

  Pub({this.name, this.time, this.comment, this.uuid, this.createTime});

  Pub.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    time = json['time'];
    comment = json['comment'];
    uuid = json['uuid'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['time'] = this.time;
    data['comment'] = this.comment;
    data['uuid'] = this.uuid;
    data['createTime'] = this.createTime;
    return data;
  }
}

class Pri {
  String name;
  String time;
  String comment;
  String uuid;
  String createTime;

  Pri({this.name, this.time, this.comment, this.uuid, this.createTime});

  Pri.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    time = json['time'];
    comment = json['comment'];
    uuid = json['uuid'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['time'] = this.time;
    data['comment'] = this.comment;
    data['uuid'] = this.uuid;
    data['createTime'] = this.createTime;
    return data;
  }
}
