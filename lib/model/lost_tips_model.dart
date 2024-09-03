/*
 * 
 *        失物招领公告获取
 *  
 */
class LostTipsModel {
  int code;
  String msg;
  Map<String, String> data;

  LostTipsModel.fromJson(Map<String, dynamic> json) {
    this.code = json['code'];
    this.msg = json['msg'];
    this.data = json['data'] != null ? json['data'] : null;
  }
}
