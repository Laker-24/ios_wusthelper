/* 
 *        查询收藏图书
 */

class LibraryListCollectionModel {
  int code;
  String msg;
  List<LibraryCollection> data;

  LibraryListCollectionModel.fromJson(Map<String, dynamic> json) {
    this.code = json['code'];
    this.msg = json['msg'];
    data = [];
    if (json['data'].isNotEmpty) {
      json['data'].forEach((e) {
        data.add(LibraryCollection.fromJson(e));
      });
    }
  }
}

class LibraryCollection {
  int id; //收藏ID
  String title;
  String author;
  String isbn; // ISBN
  String publisher; //出版方
  String detailUrl;
  String createTime; //收藏时间

  LibraryCollection.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.author = json['author'];
    this.isbn = json['isbn'];
    this.publisher = json['publisher'];
    this.detailUrl = json['detailUrl'];
    this.createTime = json["createTime"];
  }
}
