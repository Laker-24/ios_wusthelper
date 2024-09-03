class AdminNoticeModel {
  int code;
  String msg;
  List<AdminNoticeData> data;

  AdminNoticeModel({this.code, this.msg, this.data});

  AdminNoticeModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <AdminNoticeData>[];
      json['data'].forEach((v) {
        data.add(new AdminNoticeData.fromJson(v));
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

class AdminNoticeData {
  int newsid;
  String title;
  String content;
  String obj;
  String updateTime;
  bool repeat;

  AdminNoticeData(
      {this.newsid, this.title, this.content, this.obj, this.updateTime});

  AdminNoticeData.fromJson(Map<String, dynamic> json) {
    newsid = json['newsid'];
    title = json['title'];
    content = json['content'];
    obj = json['obj'];
    updateTime = json['updateTime'];
    repeat = json['repeat'] ?? true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newsid'] = this.newsid;
    data['title'] = this.title;
    data['content'] = this.content;
    data['obj'] = this.obj;
    data['updateTime'] = this.updateTime;
    data['repeat'] = this.repeat;
    return data;
  }
}
