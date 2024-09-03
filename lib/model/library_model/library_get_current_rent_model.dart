/*
 * 
 *     获取本人当前借阅信息
 * 
 */

class LibraryGetCurrentRentModel {
  int code;
  String msg;
  List<CurrentRentBook> data;

  LibraryGetCurrentRentModel.fromJson(Map<String, dynamic> json) {
    this.code = json['code'];
    this.msg = json['msg'];
    this.data = [];
    if (json['data'] != null)
      json['data'].forEach((e) {
        data.add(CurrentRentBook.fromJson(e));
      });
  }
}

class CurrentRentBook {
  String bookCode; //条号码
  String bookName;
  String bookUrl;
  String rentTime;
  String bookPlace;
  String returnTime;
  String reRentNum; // 续借次数

  CurrentRentBook.fromJson(Map<String, dynamic> json) {
    this.bookCode = json['bookCode'];
    this.bookName = json['bookName'];
    this.bookUrl = json['bookUrl'];
    this.rentTime = json['rentTime'];
    this.returnTime = json['returnTime'];
    this.bookPlace = json['bookPlace'];
    this.reRentNum = json['reRentNum'];
  }
}
