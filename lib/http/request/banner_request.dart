/*
 *
 * 获取发布的轮播图
 * 
 * 
 */
import 'package:wust_helper_ios/http/request/base_request.dart';

class BannerRequest extends BaseRequest {
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
    return "/wusthelperadminapi/v1/wusthelper/act";
  }
}
