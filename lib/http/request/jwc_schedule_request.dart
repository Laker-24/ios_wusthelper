/*
 * 
 *  获取课表
 *  请求方式 ：get
 *  请求头 ：Platform => ios
 * 
 */

import 'package:wust_helper_ios/http/request/base_request.dart';

class JwcSchedulerequest extends BaseRequest {
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
    return "mobileapi/v2/jwc/get-curriculum";
  }
}
