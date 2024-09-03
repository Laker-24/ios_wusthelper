/*
 * 
 *  结合登陆
 *  请求方式 ：post
 *  请求数据格式 ： application/x-www-form-urlencoded
 * 
 */
import 'base_request.dart';

class JwcCombineRequest extends BaseRequest {
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
    return "mobileapi/v2/jwc/combine-login";
  }
}
