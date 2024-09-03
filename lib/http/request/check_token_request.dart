/*
 * 
 * 
 *  检查token是否过期
 *  请求方法：get
 * 
 * 
 */
import 'package:wust_helper_ios/http/request/base_request.dart';

class CheckTokenRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return 'mobileapi/v2/lh/check-token';
  }
}
