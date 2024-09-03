/*
 * 
 * 
 *  获取学期时间
 *  接口位置：管理端 ————————其他平台，获取配置信息
 * 
 */
import 'package:wust_helper_ios/http/request/base_request.dart';

class AdminTimeRequest extends BaseRequest {
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
    return "wusthelperadminapi/v1/wusthelper/config";
  }
}
