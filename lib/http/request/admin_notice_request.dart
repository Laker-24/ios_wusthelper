/*
 * 
 * 
 *  获取管理端公告
 * 
 * 
 */
import 'package:wust_helper_ios/http/request/base_request.dart';

class AdminNoticeRequest extends BaseRequest {
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
    return 'wusthelperadminapi/v1/wusthelper/notice';
  }
}
