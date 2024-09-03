/*
 *    通过URL获取图书馆图书详情
 * 
 */

class LibraryGetBookDetailModel {
  int code;
  String msg;
  BookDetail data;
  LibraryGetBookDetailModel() {}
  LibraryGetBookDetailModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null)
      data = BookDetail.fromJson(json['data']);
    else
      data = null;
  }
}

class BookDetail {
  String bookNameAndAuth; //题名/责任者
  String publisher;
  String introduction;
  String imgUrl;
  int isCollection;
  List<BookRentDetail> list;
  String isbn;
  BookDetail.fromJson(Map<String, dynamic> json) {
    this.bookNameAndAuth = json['bookNameAndAuth'];
    this.publisher = json['publisher'];
    this.introduction = json['introduction'];
    this.imgUrl = json['imgUrl'];
    this.isCollection = json['isCollection'];
    list = [];
    if (json['list'] != null)
      json['list'].forEach((e) {
        list.add(BookRentDetail.fromJson(e));
      });

    isbn = json['isbn'];
  }
}

class BookRentDetail {
  String callNo;
  String barCode;
  String location;
  String status;

  BookRentDetail.fromJson(Map<String, dynamic> json) {
    this.callNo = json['callNo'];
    this.barCode = json['barCode'];
    this.location = json['location'];
    this.status = json['status'];
  }
}
