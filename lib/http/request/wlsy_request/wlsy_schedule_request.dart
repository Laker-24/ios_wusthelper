import 'package:wust_helper_ios/http/request/base_request.dart';

/*
 * 
 * 物理实验请求课表
 * 
 */
class WlsyScheduleRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
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
    return "mobileapi/v2/wlsy/get-courses";
  }
}
