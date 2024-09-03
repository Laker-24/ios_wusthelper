class VersionModel {
  int code;
  String msg;
  VersionData data;

  VersionModel({this.code, this.msg, this.data});

  VersionModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new VersionData.fromJson(json['data']) : null;
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

class VersionData {
  String version;
  String updateContent;
  String apkUrl;

  VersionData({this.version, this.updateContent, this.apkUrl});

  VersionData.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    updateContent = json['updateContent'];
    apkUrl = json['apkUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['version'] = this.version;
    data['updateContent'] = this.updateContent;
    data['apkUrl'] = this.apkUrl;
    return data;
  }
}
