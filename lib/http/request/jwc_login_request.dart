/*
 * 
 *  普通登陆
 *  请求方式 ：post
 *  请求数据格式 ： application/x-www-form-urlencoded
 * 
 */

import 'package:wust_helper_ios/http/request/base_request.dart';

class JwcLoginRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return "mobileapi/v2/jwc/login";
  }
}
