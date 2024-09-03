/*
 * 
 * 研究生登录请求
 * 获取方式：Post
 * 
 */

import 'package:wust_helper_ios/http/request/base_request.dart';

class GraduateStuLoginRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  HttpStyles httpStyles() {
    return HttpStyles.YJS;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return "mobileapi/v2/yjs/login";
  }

  @override
  String url() {
    return "https://" + authority() + "/" + path();
  }
}
