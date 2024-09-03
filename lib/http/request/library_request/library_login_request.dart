import 'package:wust_helper_ios/http/request/base_request.dart';

/*
 * 
 *      登陆
 * 
 */
class LibraryLoginRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "mobileapi/v2/lib/login";
  }
}
