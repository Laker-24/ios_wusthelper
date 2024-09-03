import 'package:wust_helper_ios/http/request/base_request.dart';

/*
 *  *  获取培养方案
 *  请求方式 ：get
 *  请求头 ：Platform => ios
 * 
 */
class JwcTrainingRequest extends BaseRequest {
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
    return 'mobileapi/v2/jwc/get-scheme';
  }
}
