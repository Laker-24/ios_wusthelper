/*
 * 
 *  获取学分统计Html
 *  请求方式 ：get
 *  
 * 
 */
import 'package:wust_helper_ios/http/request/base_request.dart';

class JwcCreditRequest extends BaseRequest {
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
    return 'mobileapi/v2/jwc/get-credit';
  }
}
