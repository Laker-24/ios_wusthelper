class BannerModel {
  int code;
  String msg;
  List<Data> data;

  BannerModel({this.code, this.msg, this.data});

  BannerModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }
}

class Data {
  int actid;
  String title;
  String bannerContentUrl;
  String imgUrl;
  String updateTime;

  Data(
      {this.actid,
      this.title,
      this.bannerContentUrl,
      this.imgUrl,
      this.updateTime});

  Data.fromJson(Map<String, dynamic> json) {
    actid = json['actid'];
    title = json['title'];
    bannerContentUrl = json['content'];
    imgUrl = json['imgUrl'];
    updateTime = json['updateTime'];
  }
}
