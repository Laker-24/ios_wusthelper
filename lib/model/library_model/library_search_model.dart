class LibrarySearchModel {
  int code;
  String msg;
  List<SearchBook> data;

  LibrarySearchModel.fromJson(Map<String, dynamic> json) {
    this.code = json['code'];
    this.msg = json['msg'];
    this.data = [];
    if (json['data'] != null)
      json['data'].forEach((e) {
        this.data.add(SearchBook.fromJson(e));
      });
  }
}

class SearchBook {
  String title;
  String author;
  String pubYear;
  String publisher;
  String callNo;
  String detailUrl;
  String imgUrl;
  String allNum;
  String remainNum;

  SearchBook.fromJson(Map<String, dynamic> json) {
    this.title = json['title'];
    this.author = json['author'];
    this.pubYear = json['pubYear'];
    this.publisher = json['publisher'];
    this.callNo = json['callNo'];
    this.detailUrl = json['detailUrl'];
    this.imgUrl = json['imgUrl'];
    this.allNum = json['allNum'];
    this.remainNum = json['remainNum'];
  }
}
