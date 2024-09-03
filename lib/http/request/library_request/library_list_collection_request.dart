import 'package:wust_helper_ios/http/request/base_request.dart';

/*
 * 
 *      查询收藏图书
 * 
 */
class LibraryListCollectionRequest extends BaseRequest {
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
    return "mobileapi/v2/lib/list-collection";
  }
}
