/*
 * 
 * 物理实验课表登陆
 * 
 */

import 'package:wust_helper_ios/http/request/base_request.dart';

class WlsyRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  HttpStyles httpStyles() {
    return HttpStyles.WLSY;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "mobileapi/v2/wlsy/login";
  }
}
