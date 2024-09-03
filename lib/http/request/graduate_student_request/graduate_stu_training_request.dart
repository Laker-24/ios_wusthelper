/*
 * 
 * 研究生培养计划
 * 获取方式：Get
 * 
 */
import 'package:wust_helper_ios/http/request/base_request.dart';

class GraduateStuTrainingRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  HttpStyles httpStyles() {
    return HttpStyles.YJS;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "mobileapi/v2/yjs/get-scheme";
  }
}
