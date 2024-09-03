/*

    网络适配层基类

*/

import 'dart:convert';
import 'package:wust_helper_ios/http/request/base_request.dart';

///网络请求抽象类
abstract class BaseNetAdepter {
  Future<BaseNetResponse<T>> send<T>(BaseRequest request);
}

///统一网络层返回格式
class BaseNetResponse<T> {
  T data;
  BaseRequest request;
  int statusCode;
  String statusMessage;
  dynamic extraData;

  BaseNetResponse(
      {this.data,
      this.request,
      this.statusCode,
      this.statusMessage,
      this.extraData});

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}
