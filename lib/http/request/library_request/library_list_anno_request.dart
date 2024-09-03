import 'package:wust_helper_ios/http/request/base_request.dart';

/*
 * 
 * 获取图书馆公告列表
 * 
 */
class LibraryListAnnoRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "mobileapi/v2/lib/list-anno";
  }
}