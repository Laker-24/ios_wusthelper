/*
 *      获取图书馆公告列表(Json -> Model)
 */

class LibraryListAnnoModel {
  int code;
  String msg;
  List<Anno> data;

  LibraryListAnnoModel.fromJson(Map<String, dynamic> json) {
    this.code = json['code'];
    this.msg = json['msg'];
    data = [];
    json['data'].forEach((e) {
      data.add(Anno.fromJson(e));
    });
  }
}

class Anno {
  int id;
  String title;
  String publishTime;

  Anno.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.publishTime = json['publishTime'];
  }
}
