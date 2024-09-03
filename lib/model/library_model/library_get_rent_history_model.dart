/*
 *    历史借阅 
 */
class LibraryGetRentHistoryModel {
  int code;
  String msg;
  List<HitsoryRentBook> data;
  LibraryGetRentHistoryModel.fromJson(Map<String, dynamic> json) {
    this.code = json['code'];
    this.msg = json['msg'];
    data = [];
    json['data'].forEach((e) {
      this.data.add(HitsoryRentBook.fromJson(e));
    });
  }
}

class HitsoryRentBook {
  String bookCode;
  String bookName;
  String bookUrl;
  String rentTime;
  String returnTime;
  String bookPlace;
  String bookAuthor;

  HitsoryRentBook.fromJson(Map<String, dynamic> json) {
    bookCode = json['bookCode'];
    bookName = json['bookName'];
    bookUrl = json['bookUrl'];
    returnTime = json['returnTime'];
    bookPlace = json['bookPlace'];
    bookAuthor = json['bookAuthor'];
    this.rentTime = json['rentTime'];
  }
}
