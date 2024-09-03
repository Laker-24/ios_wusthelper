/*
 * 
 * 
 *  修改倒计时
 * 
 * 
 */
import 'package:wust_helper_ios/http/request/base_request.dart';

class CountdownModifyRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  HttpStyles httpStyles() {
    return HttpStyles.LH;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    //测试环境
    //return 'http://129.211.66.191:9597/v2/wusthelper/lh/modify-countdown';
    //生产环境
    return 'mobileapi/v2/lh/modify-countdown';
  }
}
